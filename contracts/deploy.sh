
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ETH_RPC_SOCKET=http://localhost:8545

// deploy contract via forge
forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $ETH_RPC_SOCKET \
    --private-key $PRIVATE_KEY --broadcast

