# Script to start anvil chain locally and initialize contracts

# Setup local test env variables
source ../operator/.env
source .env

# Start the anvil chain locally
anvil > logs/anvil.log 2>&1 &
echo $! > anvil.pid

## Deploy local contracts
## cd to contracts directory so that 'forge' command works correctly
## deploy contract via forge
(cd ../contracts && \
    forge script script/CIDEmitter.s.sol:CIDEmitterScript --fork-url $ETH_RPC_SOCKET \
    --private-key $PRIVATE_KEY --broadcast \
)
