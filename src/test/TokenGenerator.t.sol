// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

// import "../TokenGenerator.sol";
// import "forge-std/Vm.sol";
// import {console} from "forge-std/console.sol";
// import "forge-std/Test.sol";
// import {MockERC20} from "./mocks/MockERC20.sol";

// contract TokenGeneratorTest is Test {
//     TokenGenerator public generator;
//     uint256 public staticTime;
//     Vm internal constant cheats = Vm(HEVM_ADDRESS);

//     function setUp() public {
//         staticTime = block.timestamp;
//         generator = new TokenGenerator();
//         cheats.warp(staticTime);
//     }

//     function testDeployNewMockERC20() public {
//         bool res0 = generator.deployNewMockERC20("TST", "TST");
//         assertTrue(res0);

//         MockERC20 token0 = generator.mintedERC20s(0);

//         address t0Owner = token0.owner();
//         console.log(t0Owner, address(this), msg.sender);
//         assertTrue(t0Owner != address(this));
//         // assertTrue(t0Owner != msg.sender);
//         cheats.warp(1);

//         /// 1st

//         bool res1 = generator.deployNewMockERC20("TST", "TST");
//         assertTrue(res1);

//         MockERC20 token1 = generator.mintedERC20s(1);

//         address t1Owner = token1.owner();

//         assertTrue(t1Owner != address(this));
//         // assertTrue(t1Owner != msg.sender);
//         cheats.warp(1);

//         /// 2nd

//         bool res2 = generator.deployNewMockERC20("TST", "TST");
//         assertTrue(res2);

//         MockERC20 token2 = generator.mintedERC20s(2);

//         address t2Owner = token2.owner();

//         assertTrue(t2Owner != address(this));
//         // assertTrue(t2Owner != msg.sender);
//         cheats.warp(1);
//         /// 3rd

//         uint256 tokens = generator.getMintedERC20s();
//         uint256[] memory val = new uint256[](tokens);
//         console.log(tokens);
//     }

//     ////// ERC721

//     function testDeployNewMockERC721() public {
//         bool res0 = generator.deployNewMockERC721("TST", "TST");
//         assertTrue(res0);

//         MockERC721 token0 = generator.mintedERC721s(0);

//         address t0Owner = token0.owner();
//         console.log(t0Owner, address(this), msg.sender);

//         assertTrue(t0Owner != address(this));
//         cheats.warp(1);

//         /// 1st

//         bool res1 = generator.deployNewMockERC721("TST", "TST");
//         assertTrue(res1);

//         MockERC721 token1 = generator.mintedERC721s(1);

//         address t1Owner = token1.owner();

//         assertTrue(t1Owner != address(this));
//         // assertTrue(t1Owner != msg.sender);
//         cheats.warp(1);

//         /// 2nd

//         bool res2 = generator.deployNewMockERC721("TST", "TST");
//         assertTrue(res2);

//         MockERC721 token2 = generator.mintedERC721s(2);

//         address t2Owner = token2.owner();

//         assertTrue(t2Owner != address(this));
//         // assertTrue(t2Owner != msg.sender);
//         console.log(t2Owner, address(this), msg.sender);
//         cheats.warp(1);

//         /// 3rd

//         uint256 tokens = generator.getMintedERC721s();
//         uint256[] memory val = new uint256[](tokens);
//         console.log(tokens);
//     }

//     ////// ERC1155

//     function testDeployNewMockERC1155() public {
//         bool res0 = generator.deployNewMockERC1155();
//         assertTrue(res0);

//         MockERC1155 token0 = generator.mintedERC1155s(0);

//         address t0Owner = token0.owner();
//         console.log(t0Owner, address(this), msg.sender);
//         assertTrue(t0Owner != address(this));
//         assertTrue(t0Owner != msg.sender);
//         cheats.warp(1);

//         /// 1st

//         bool res1 = generator.deployNewMockERC1155();
//         assertTrue(res1);

//         MockERC1155 token1 = generator.mintedERC1155s(1);

//         address t1Owner = token1.owner();

//         assertTrue(t1Owner != address(this));
//         assertTrue(t1Owner != msg.sender);
//         cheats.warp(1);

//         /// 2nd

//         bool res2 = generator.deployNewMockERC1155();
//         assertTrue(res2);

//         MockERC1155 token2 = generator.mintedERC1155s(2);

//         address t2Owner = token2.owner();

//         assertTrue(t2Owner != address(this));
//         // assertTrue(t2Owner != msg.sender);
//         console.log(t2Owner, address(this), msg.sender);
//         cheats.warp(1);

//         /// 3rd

//         uint256 tokens = generator.getMintedERC1155s();
//         uint256[] memory val = new uint256[](tokens);
//         console.log(tokens);
//     }

//     // function testFuzzingExample(bytes memory variant) public {
//     //     // We expect this to fail, no matter how different the input is!
//     //     cheats.expectRevert(bytes("Time interval not met"));
//     //     generator.performUpkeep(variant);
//     // }
// }
