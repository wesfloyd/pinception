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

# Optional
docker run --rm -p 5100:80 --name otterscan -d otterscan/otterscan:latest


# Local Setup for IPFS Daemon

# Install IPFS Kubo binaries locally on your machine
# https://github.com/ipfs/kubo?tab=readme-ov-file#official-prebuilt-binaries
# Init and start your ipfs server
# todo orchestrate this with Docker compose
ipfs init
ipfs daemon

# Check the list of locally pinned files
ipfs pin ls

# to unpin all added content
ipfs pin ls --type recursive | cut -d' ' -f1 | xargs -n1 ipfs pin rm
# then optionally run storage garbage collection to actually remove things:
ipfs repo gc

# Pin a file on a remote IPFS server
# Use any service you like. For example, I use google cloud console running the following commands:
ipfs daemon
echo "Hello, IPFS! from google $(date +%s%N)" | ipfs add --pin=true


#Open a new terminal window, run
node pinner-ipfsd.js

# Open a another window to call the CID emit contract on chain

# hard coded contract addr for now
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
CID_EMITTER_CONTRACT_ADDR=0x5FbDB2315678afecb367f032d93F642f64180aa3
CID_TO_EMIT=Qmb4S89ZFiZEwXYXkubWq9dRrhjGJnn6fwvCXKguVvC7jV

cast send $CID_EMITTER_CONTRACT_ADDR "emitCIDToPIN(string)" "$CID_TO_EMIT" \
    --private-key $PRIVATE_KEY

