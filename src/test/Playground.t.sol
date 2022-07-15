// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../TokenGenerator.sol";
import "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import "forge-std/Test.sol";
import {Keyrxng} from "../Keyrxng.sol";
import {KxyChain} from "../KxyChain.sol";
import {KeyChainx} from "../KeyChainx.sol";
import {Playground} from "../Playground.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import {IERC721Receiver} from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/interfaces/IERC1155Receiver.sol";

contract PlaygroundTest is IERC1155Receiver, IERC721Receiver, Test {
    TokenGenerator public generator;
    uint256 public staticTime;
    Vm internal constant cheats = Vm(HEVM_ADDRESS);

    Keyrxng keyrxng;
    KxyChain kxyChain;
    KeyChainx keyChainx;
    Playground playground;
    address keyrxng_;
    address kxyChain_;
    address keyChainx_;
    address playground_;

    function setUp() public {
        staticTime = block.timestamp;
        keyrxng = new Keyrxng();
        keyrxng_ = address(keyrxng);
        kxyChain = new KxyChain();
        kxyChain_ = address(kxyChain);
        keyChainx = new KeyChainx();
        kxyChain_ = address(kxyChain);
        playground = new Playground(keyrxng, kxyChain, keyChainx);
        playground_ = address(playground);
        cheats.warp(staticTime);
    }

    function isContract(address _addr) private returns (bool isContract) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function testDeploy() public {
        address token0 = address(keyrxng);
        address token1 = address(kxyChain);
        address token2 = address(keyrxng);
        assertTrue(isContract(token0));
        assertTrue(isContract(token1));
        assertTrue(isContract(token2));
    }

    function testInit() public {
        bool success = keyrxng.init(playground_);
        assertTrue(success);
        bool second = kxyChain.init(playground_);
        assertTrue(second);
        bool third = keyChainx.init(playground_);
        assertTrue(third);
    }

    function testPlaygroundInit() public {
        bool success = playground.init();
        assertTrue(success);
    }

    function testMintERC20() public {
        playground.init();
        assertTrue((keyrxng.balanceOf(address(this)) > 0));
    }

    function testMintERC721() public {
        playground.init();
        cheats.warp(1);
        playground.mintERC721(address(this));
        uint256 bal = kxyChain.balanceOf(address(this));
        console.log(bal);
    }

    function testMintERC1155() public {
        vm.startBroadcast();
        playground.init();
        cheats.warp(1);
        playground.mintERC1155(address(this));
        cheats.warp(1);
        uint256 id = 1;
        uint256 bal = keyChainx.balanceOf(playground_, id);
        console.log(bal);
        vm.stopBroadcast();
    }

    receive() external payable {}

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId)
        external
        view
        returns (bool)
    {
        return true;
    }
}
