// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CIDEmitter} from "../src/CIDEmitter.sol";

contract CIDEmitterTest is Test {
    CIDEmitter public cidEmitter;
    string public TEST_CID = "QmQK3SHcMYebcFubt6j3jVEWM5y71VA8LMB6rb1st65UWh";
    event CIDToPIN(string cid);

    function setUp() public {
        cidEmitter = new CIDEmitter();
        
    }

    function testEmitCIDToPIN() public {
        vm.expectEmit(address(cidEmitter));
        emit CIDToPIN(TEST_CID);
        cidEmitter.emitCIDToPIN(TEST_CID);
    }
}
