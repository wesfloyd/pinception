##
## This is a complete list of commands to set up and test a local environment 
## for testing the project.
##

# Pre-requisites
## Update your local foundry instance
foundryup
## install jq for macos
brew install jq



# Terminal1: Start the anvil chain locally
# anvil > logs/anvil.log 2>&1 &
# ANVIL_PID=$!
anvil




# Terminal 2

## Setup local test env variables
source ../operator/.env
source ./.env

# Deploy local contracts
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
    -p 8080:8080 \
    ipfs/kubo:latest

# Simulated IPFS container to represent a rmeote IPFS server for testing
docker run --rm -d --name $IPFS_SIM_REMOTE \
    -p 4002:4001 \
    -p 5002:5001/tcp \
    -p 4002:4001/udp \
    -p 8081:8080 \
    ipfs/kubo:latest

# Run the operator binary
# (cd ../operator && node pinner-ipfsd.js &) && PINNER_PID=$!
(cd ../operator && node pinner-ipfsd.js )





# Open a third window 
## Setup local test env variables
source ../operator/.env
source ./.env


# Pin a file on a (pretend) remote IPFS server
MSG="Hello, IPFS Today is $(date '+%Y-%m-%d') and the time is $(date '+%H:%M:%S') .. and Prague is amazing"
echo $MSG
# Add file to remote IPFS server
CID1=$(curl -X POST -F file=@- "${IPFS_SIM_REMOTE_API}/add" <<< "${MSG}" | jq -r .Hash)
# Pin the CID
curl -X POST "${IPFS_SIM_REMOTE_API}/pin/add?arg=${CID1}" | jq

## Check the list of simulated remote pinned files
curl -X POST ${IPFS_SIM_REMOTE_API}/pin/ls | jq 

## Cat the contents of the CID
curl -X POST ${IPFS_SIM_REMOTE_API}/cat?arg=${CID1}

## Check the list of pinned files on the local operator
curl -X POST ${IPFS_OPERATOR_API}/pin/ls | jq



# Call the CID emit contract on chain
cast send $CID_EMITTER_CONTRACT_ADDR "emitCIDToPIN(string)" "${CID1}" \
    --private-key $PRIVATE_KEY


## Check the list of locally pinned files
curl -X POST ${IPFS_OPERATOR_API}/pin/ls | jq 
## Check the lis of simulated remote pinned files
curl -X POST ${IPFS_SIM_REMOTE_API}/pin/ls | jq 


# Stop everything
# kill $ANVIL_PID
# kill $PINNER_PID
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
