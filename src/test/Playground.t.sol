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
import {console} from "forge-std/console.sol";

contract PlaygroundTest is Test {
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
        assertTrue((keyrxng.balanceOf(address(this)) == 0));
        cheats.warp(1);
        playground.mintERC721(address(this));
        uint256 bal = kxyChain.balanceOf(address(this));
        assertTrue(bal > 0);
    }

    function testMintERC1155() public {
        vm.startBroadcast();
        playground.init();
        cheats.warp(1);
        assertTrue((keyrxng.balanceOf(address(this)) > 0));
        playground.mintERC1155(address(this));
        cheats.warp(1);
        uint256 id = 0;
        uint256 bal = keyChainx.balanceOf(address(this), id);
        assertTrue(bal > 0);
        vm.stopBroadcast();
    }
}
