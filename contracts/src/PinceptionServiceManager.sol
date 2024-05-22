// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@eigenlayer/contracts/libraries/BytesLib.sol";
import "@eigenlayer-middleware/src/unaudited/ECDSAServiceManagerBase.sol";
import "@eigenlayer-middleware/src/unaudited/ECDSAStakeRegistry.sol";
import {IRegistryCoordinator} from "@eigenlayer-middleware/src/interfaces/IRegistryCoordinator.sol";
import "@eigenlayer/contracts/permissions/Pausable.sol";
import "@openzeppelin-upgrades/contracts/utils/cryptography/ECDSAUpgradeable.sol";
import "./IPinceptionServiceManager.sol";

contract PinceptionServiceManager is 
    ECDSAServiceManagerBase,
    IHelloWorldServiceManager,
    Pausable
{

    using BytesLib for bytes;
    using ECDSAUpgradeable for bytes32;

    

    // CONTRACT STORAGE 
    // The latest task index
    uint32 public latestTaskNum;

    // mapping of task indices to all tasks hashes
    // when a task is created, task hash is stored here,
    // and responses need to pass the actual task,
    // which is hashed onchain and checked against this mapping
    mapping(uint32 => bytes32) public allTaskHashes;

    // mapping of task indices to hash of abi.encode(taskResponse, taskResponseMetadata)
    mapping(address => mapping(uint32 => bytes)) public allTaskResponses;

    // MODIFIERS
    modifier onlyOperator() {
        require(
            ECDSAStakeRegistry(stakeRegistry).operatorRegistered(msg.sender) 
            == 
            true, 
            "Operator must be the caller"
        );
        _;
    }

    constructor(
        address _avsDirectory,
        address _stakeRegistry,
        address _delegationManager
    )
        ECDSAServiceManagerBase(
            _avsDirectory,
            _stakeRegistry,
            address(0), // hello-world doesn't need to deal with payments
            _delegationManager
        )
    {}

    // FUNCTIONS 

    // Creates new CID Pin request task, assigns it a taskId
    function createNewCIDPinTask(
        string memory cid
    ) external {
        // create a new task struct
        Task memory newTask;
        newTask.cid = cid;
        newTask.taskCreatedBlock = uint32(block.number);

        // store hash of task onchain, emit event, and increase taskNum
        allTaskHashes[latestTaskNum] = keccak256(abi.encode(newTask));
        emit NewCIDRequestTaskCreated(latestTaskNum, newTask);
        latestTaskNum = latestTaskNum + 1;
    }

    // Responds to existing CID Pin request tasks
    function respondToCIDPinTask(
        Task calldata task,
        uint32 referenceTaskIndex,
        bytes calldata signature
    ) external onlyOperator {
        // check that the task is valid, hasn't been responsed yet, and is being responded in time
        require(
            keccak256(abi.encode(task)) ==
                allTaskHashes[referenceTaskIndex],
            "supplied task does not match the one recorded in the contract"
        );
        // some logical checks
        require(
            allTaskResponses[msg.sender][referenceTaskIndex].length == 0,
            "Operator has already responded to the task"
        );

        // The message that was signed
        bytes32 messageHash = keccak256(abi.encodePacked("Hello, ", task.cid));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();

        // Recover the signer address from the signature
        address signer = ethSignedMessageHash.recover(signature);

        require(signer == msg.sender, "Message signer is not operator");

        // updating the storage with task responsea
        allTaskResponses[msg.sender][referenceTaskIndex] = signature;

        // emitting event
        emit CIDRequestResponse(referenceTaskIndex, task, msg.sender);
    }

}



