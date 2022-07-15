// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/TokenGenerator.sol";
import "./HelperConfig.sol";

contract DeployTokenGenerator is Script, HelperConfig {
    function run() external {
        HelperConfig helperConfig = new HelperConfig();

        (, , , , uint256 updateInterval, , , , ) = helperConfig
            .activeNetworkConfig();

        vm.startBroadcast();

        TokenGenerator TokenGen = new TokenGenerator();

        vm.stopBroadcast();
    }
}
