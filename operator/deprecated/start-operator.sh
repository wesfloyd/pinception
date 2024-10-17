# Setup local test env variables
source .env

# Local Setup for IPFS Daemon
docker run --rm -d --name $IPFS_OPERATOR_NAME \
    -p 4001:4001 \
    -p 5001:5001/tcp \
    -p 4001:4001/udp \
    ipfs/kubo:latest

# Open a second terminal window, run operator code
## Todo: how to remove the file path dependency for operator ?? think

node pinner-ipfsd.js > logs/pinner-ipfsd.log 2>&1 &
echo $! > pinner-ipfsd.pid



