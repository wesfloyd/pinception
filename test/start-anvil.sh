
foundryup




// Start the anvil chain 
anvil


PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

// deploy contract via forge
forge script ../scripts/CIDEmitter.sol:CIDEmitter --fork-url http://localhost:8545 \
--private-key $PRIVATE_KEY --broadcast
