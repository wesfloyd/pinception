// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/CIDEmitter.sol";

contract CIDEmitterScript is Script {
    function setUp() public {}

    function run() public {
       
        vm.startBroadcast();
        CIDEmitter cidEmitter = new CIDEmitter();
        vm.stopBroadcast();
    }
}