##
## This is a complete list of commands to set up and test a local environment 
## for testing the project.
##

## always good practice to update your local foundry instance
foundryup

source ./operator/.env

# Start the anvil chain locally
anvil  > /dev/null 2>&1  &
ANVIL_PID=$!

# Stop anvil locally
kill $ANVIL_PID


# NOT yet WORKING
# Start the anvil chain via docker container
docker pull ghcr.io/foundry-rs/foundry
ANVIL_CONTAINER_NAME=anvil-node
docker run --rm -d --name $ANVIL_CONTAINER_NAME
    -p 8545:8545 \
    ghcr.io/foundry-rs/foundry

# Stop local anvil chain
docker stop #ANVIL_CONTAINER_NAME


## Deploy local contracts

PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ETH_RPC_SOCKET=http://localhost:8545

## cd to contracts directory so that 'forge' command works correctly
cd contracts
## deploy contract via forge
forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $ETH_RPC_SOCKET \
    --private-key $PRIVATE_KEY --broadcast
cd ..

# Optional: run otterscan locally to view the chain
docker run --rm -d -p 5100:80 --name otterscan -d otterscan/otterscan:latest

# Local Setup for IPFS Daemon

IPFS_CONTAINER_NAME=ipfs-node
docker run --rm -d --name $IPFS_CONTAINER_NAME \
    -p 4001:4001 \
    -p 5001:5001/tcp \
    -p 4001:4001/udp \
    ipfs/kubo:latest


## Additional testing utilities available as needed
docker stop $IPFS_CONTAINER_NAME

## Test connectivity to local kubo node
curl -X POST $IPFS_DAEMON_SOCKET/api/v0/id


# Check the list of locally pinned files
ipfs pin ls
curl -X POST $IPFS_DAEMON_SOCKET/api/v0/pin/ls
curl -X POST $IPFS_DAEMON_SOCKET/api/v0/ls?arg=QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn

# to unpin all added content
ipfs pin ls --type recursive | cut -d' ' -f1 | xargs -n1 ipfs pin rm
curl -X POST $IPFS_DAEMON_SOCKET/api/v0/pin/rm?arg=QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn&recursive=true

# then optionally run storage garbage collection to actually remove things:
ipfs repo gc

# Pin a file on a remote IPFS server
# Use any service you like. For example, I use google cloud console running the following commands:
gcloud auth login
gcloud init
gcloud cloud-shell ssh

wget https://dist.ipfs.tech/kubo/v0.28.0/kubo_v0.28.0_linux-amd64.tar.gz
tar -xvzf kubo_v0.28.0_linux-amd64.tar.gz
cd kubo
sudo bash install.sh
ipfs --version

ipfs daemon &
echo "Hello, IPFS! Today is $(date '+%Y-%m-%d') and the time is $(date '+%H:%M:%S')" | ipfs add --pin=true
# Take note of the resulting CID


#Open a new terminal window, run
## Todo: how to remove the file path dependency for operator ?? think
cd operator
node pinner-ipfsd.js

# Open a another window to call the CID emit contract on chain
# hard coded contract addr for now
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
CID_EMITTER_CONTRACT_ADDR=0x5FbDB2315678afecb367f032d93F642f64180aa3
TEST_CID=[CID from remote IPFS server] QmQGf8gmQhbZMBuzDs6ZDojrJXVjtD2yRFnr8ziyHYYg4V

cast send $CID_EMITTER_CONTRACT_ADDR "emitCIDToPIN(string)" "$CID_TO_EMIT" \
    --private-key $PRIVATE_KEY

# Back on local - test that the CID was pinned
curl -X POST $IPFS_DAEMON_SOCKET/api/v0/cat?arg=$TEST_CID