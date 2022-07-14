// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../TokenGenerator.sol";
import "forge-std/Vm.sol";
import {console} from "forge-std/console.sol";
import "forge-std/Test.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract TokenGeneratorTest is Test {
    TokenGenerator public generator;
    uint256 public staticTime;
    Vm internal constant cheats = Vm(HEVM_ADDRESS);

    function setUp() public {
        staticTime = block.timestamp;
        generator = new TokenGenerator();
        cheats.warp(staticTime);
    }

    function testDeployNewMockERC20() public {
        bool res0 = generator.deployNewMockERC20("Test", "TST");
        assertTrue(res0);

        bool res1 = generator.deployNewMockERC20("Test", "TST");
        assertTrue(res1);

        bool res2 = generator.deployNewMockERC20("Test", "TST");
        assertTrue(res2);

        uint256 tokens = generator.getMintedERC20s();
        uint256[] memory val = new uint256[](tokens);
        console.log(tokens);
    }

    function testDeployNewMockERC721() public {
        bool res0 = generator.deployNewMockERC721("Test", "TST");
        assertTrue(res0);

        bool res1 = generator.deployNewMockERC721("Test", "TST");
        assertTrue(res1);

        bool res2 = generator.deployNewMockERC721("Test", "TST");
        assertTrue(res2);

        uint256 tokens = generator.getMintedERC721s();
        uint256[] memory val = new uint256[](tokens);
        console.log(tokens);
    }

    function testDeployNewMockERC1155() public {
        bool res0 = generator.deployNewMockERC1155();
        assertTrue(res0);

        bool res1 = generator.deployNewMockERC1155();
        assertTrue(res1);

        bool res2 = generator.deployNewMockERC1155();
        assertTrue(res2);

        uint256 tokens = generator.getMintedERC1155s();
        uint256[] memory val = new uint256[](tokens);
        console.log(tokens);
    }

    // function testFuzzingExample(bytes memory variant) public {
    //     // We expect this to fail, no matter how different the input is!
    //     cheats.expectRevert(bytes("Time interval not met"));
    //     generator.performUpkeep(variant);
    // }
}
