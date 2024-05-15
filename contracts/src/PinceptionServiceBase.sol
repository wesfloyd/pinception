// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@eigenlayer/contracts/libraries/BytesLib.sol";
import "@eigenlayer-middleware/src/ServiceManagerBase.sol";


contract IncredibleSquaringServiceManager is ServiceManagerBase {

    constructor(
        IAVSDirectory _avsDirectory,
        IRegistryCoordinator _registryCoordinator,
        IStakeRegistry _stakeRegistry
    )
        ServiceManagerBase(
            _avsDirectory,
            IPaymentCoordinator(address(0)), // payments not yet required
            _registryCoordinator,
            _stakeRegistry
        )
    {
        // todo next
    }

}