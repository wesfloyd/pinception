// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IHelloWorldServiceManager {
    

    // EVENTS
    event NewCIDRequestTaskCreated(uint32 indexed taskIndex, Task task);
    event CIDRequestResponse(uint32 indexed taskIndex, Task task, address operator);


    // STRUCTS
    struct Task {
        string cid;
        uint32 taskCreatedBlock;
    }

    // FUNCTIONS
    // NOTE: this function creates new task.
    function createNewCIDPinTask(
        string memory cid
    ) external;

    // NOTE: this function is called by operators to respond to a task.
    function respondToCIDPinTask(
        Task calldata task,
        uint32 referenceTaskIndex,
        bytes calldata signature
    ) external;
}