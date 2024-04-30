
foundryup

// Start the anvil chain 
anvil --rpc-url http://localhost:8545 &

// deploy contract via forge
forge create contracts/CIDEmitter.sol:CIDEmitter