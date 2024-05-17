##
## This is a complete list of commands to set up and test a local environment 
## for testing the project.
##

# Pre-requisites

## Update your local foundry instance
foundryup

## install jq for macos
brew install jq

# Setup local test env variables
source ../operator/.env
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ETH_RPC_SOCKET=http://localhost:8545
# IPFS container for local operator
IPFS_OPERATOR=ipfs-op1
# IPFS container to simulate remote instance for testing purposes
IPFS_SIM_REMOTE=ipfs-sim-remote1
IPFS_OPERATOR_API=http://127.0.0.1:5001/api/v0
IPFS_SIM_REMOTE_API=http://127.0.0.1:5002/api/v0


# Start the anvil chain locally
anvil > logs/anvil.log 2>&1 &
ANVIL_PID=$!


## Deploy local contracts
## cd to contracts directory so that 'forge' command works correctly
## deploy contract via forge
(cd ../contracts && \
    forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $ETH_RPC_SOCKET \
    --private-key $PRIVATE_KEY --broadcast \
)

# Local Setup for IPFS Daemon
docker run --rm -d --name $IPFS_OPERATOR \
    -p 4001:4001 \
    -p 5001:5001/tcp \
    -p 4001:4001/udp \
    ipfs/kubo:latest

# Simulated IPFS container to represent a rmeote IPFS server for testing
docker run --rm -d --name $IPFS_SIM_REMOTE \
    -p 4002:4001 \
    -p 5002:5001/tcp \
    -p 4002:4001/udp \
    ipfs/kubo:latest



# Pin a file on a remote IPFS server
MSG="Hello, IPFS Today is $(date '+%Y-%m-%d') and the time is $(date '+%H:%M:%S')"
CID1=$(curl -X POST -F file=@- "${IPFS_OPERATOR_API}/add" <<< "${MSG}" | jq -r .Hash)
curl -X POST "${IPFS_OPERATOR_API}/pin/add?arg=${CID1}" | jq


# Open a second terminal window, run operator code
## Todo: how to remove the file path dependency for operator ?? think
(cd ../operator && node pinner-ipfsd.js &) && PINNER_PID=$!

# Open a third window to call the CID emit contract on chain
# hard coded contract addr for now
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
CID_EMITTER_CONTRACT_ADDR=0x5FbDB2315678afecb367f032d93F642f64180aa3


cast send $CID_EMITTER_CONTRACT_ADDR "emitCIDToPIN(string)" "${CID1}" \
    --private-key $PRIVATE_KEY

# Back on local - test that the CID was pinned
curl -X POST ${IPFS_OPERATOR_API}/cat?arg=${CID1}
curl -X POST ${IPFS_SIM_REMOTE_API}/cat?arg=${CID1}




## Stop everything

# Stop anvil locally
kill $ANVIL_PID
kill $PINNER_PID

## Additional testing utilities available as needed
docker stop $IPFS_OPERATOR
docker stop $IPFS_SIM_REMOTE






##############################################################################
## Appendix (not used)
##############################################################################


## Optional: run otterscan locally to view the chain
docker run --rm -d -p 5100:80 --name otterscan -d otterscan/otterscan:latest



# Test connectivity to local kubo node
curl -X POST ${IPFS_OPERATOR_API}/id
curl -X POST ${IPFS_SIM_REMOTE_API}/id

# Open in browser
http://localhost:5001
http://localhost:5002

## Check the list of locally pinned files
# ipfs pin ls
curl -X POST ${IPFS_OPERATOR_API}/pin/ls | jq 
curl -X POST ${IPFS_OPERATOR_API}/ls?arg=QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn

## to unpin all added content
# ipfs pin ls --type recursive | cut -d' ' -f1 | xargs -n1 ipfs pin rm
curl -X POST $IPFS_OPERATOR_API/pin/rm?arg=QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn&recursive=true

## then optionally run storage garbage collection to actually remove things:
# ipfs repo gc






# Example to use google cloud console running the following commands:
gcloud auth login
gcloud init
gcloud cloud-shell ssh

wget https://dist.ipfs.tech/kubo/v0.28.0/kubo_v0.28.0_linux-amd64.tar.gz
tar -xvzf kubo_v0.28.0_linux-amd64.tar.gz
cd kubo
sudo bash install.sh
ipfs --version
ipfs daemon &


# NOT yet WORKING
# Start the anvil chain via docker container
docker pull ghcr.io/foundry-rs/foundry
ANVIL_CONTAINER_NAME=anvil-node
docker run --rm -d --name $ANVIL_CONTAINER_NAME
    -p 8545:8545 \
    ghcr.io/foundry-rs/foundry
# Stop local anvil chain
docker stop #ANVIL_CONTAINER_NAME
