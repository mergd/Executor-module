// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ExecutorModule.sol";

contract ExecutorScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address safeAddress = vm.envAddress("SAFE_ADDRESS");
        vm.broadcast(deployerPrivateKey);
        ExecutorModule exec = new ExecutorModule(safeAddress);
        // Add module to multisig, add Guard modules as well.
        vm.stopBroadcast();
    }
}
