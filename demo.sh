// always good practice to update your local foundry instance
foundryup

// Start the anvil chain 
anvil &


PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
RPC_URL=http://localhost:8545

// cd to contracts directory so that forge command works correctly
cd contracts
// deploy contract via forge
forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $RPC_URL \
    --private-key $PRIVATE_KEY --broadcast
cd ..


CID_CONTRACT_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3

cast send $CID_CONTRACT_ADDRESS "emitCIDToPIN(string)" "Qm000TestHashValue1" \
    --private-key $PRIVATE_KEY

## todo use later  cast call $CID_CONTRACT_ADDRESS "getEmittedCIDs()"
