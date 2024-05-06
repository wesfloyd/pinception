
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
RPC_URL=http://localhost:8545

// deploy contract via forge
forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $RPC_URL \
    --private-key $PRIVATE_KEY --broadcast

