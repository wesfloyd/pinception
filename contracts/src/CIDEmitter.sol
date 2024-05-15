// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CIDEmitter {
    event CIDToPIN(string cid);

    function emitCIDToPIN(string memory cid) public {
        emit CIDToPIN(cid);
    }

}