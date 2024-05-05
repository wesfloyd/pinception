pragma solidity ^0.8.0;

contract CIDEmitter {
    event CIDToPIN(string cid);

    string[] private deployedCIDs;

    function emitCIDToPIN(string memory cid) public {
        emit CIDToPIN(cid);
        deployedCIDs.push(cid);
    }

    function getEmittedCIDs() public view returns (string memory) {
        bytes memory output;
        for (uint256 i = 0; i < deployedCIDs.length; i++) {
            output = abi.encodePacked(output, deployedCIDs[i]);
        }
        return string(output);
    }

}