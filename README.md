<p align="center">
  <a href="https://github.com/wesfloyd/pinception">
    <img src="https://github.com/wesfloyd/pinception/assets/260568/fb6c8685-888b-450d-842b-9060a7fd0ace" alt="pinception" width="400"/>
  </a>
</p>

<h1 align="center">Pinception</h1>
<h3 align="center">Decentralized IPFS Pinning Service Built on EigenLayer</h2>

# Project Goals
- Build a reference architecture AVS based on Hello World AVS.
- Build in the open, via community, and enable decentralized, crypto incentivized "[IPFS](ipfs.tech) Pinning as a Service" (AVS) on [EigenLayer](https://docs.eigenlayer.xyz/eigenlayer/overview). 
- Background and inspiration [here](https://x.com/DennisonBertram/status/1772621874192584962).
- Interested in roadmap and following our progress? Join the discussions [here](https://github.com/wesfloyd/pinception/discussions).

# Demo Video

[Decentralize Your dApp’s Secret Off Chain Backend w/EigenLayer](https://www.youtube.com/watch?v=_rWdJZkJYVw) (End of this talk at [15m44s](https://youtu.be/_rWdJZkJYVw?si=8K0D4iworyjwnPxw&t=944))

<p><img width="400" alt="image" src="assets/pinception-architecture.png"></p>
<a href="https://link.excalidraw.com/l/1XPZRMVbRNH/Ai6Tz8fAVsw">Excalidraw available here</a>.


# Why Pinception?
- IPFS is great ✅
- IPFS is p2p (w/o incentives) 🤷
- Self-hosting an IPFS server not great 👎
- Existing IPFS pinning services require centralized hosting infra 😬






# Local Devnet Deployment


The following instructions explain how to manually deploy the AVS from scratch including EigenLayer and AVS specific contracts using Foundry (forge) to a local anvil chain, and start Typescript Operator application and tasks.

Install dependencies:

- [Node](https://nodejs.org/en/download/)
- [Typescript](https://www.typescriptlang.org/download)
- [ts-node](https://www.npmjs.com/package/ts-node)
- [tcs](https://www.npmjs.com/package/tcs#installation)
- [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [Foundry](https://getfoundry.sh/)
- [ethers](https://www.npmjs.com/package/ethers)

### Start Anvil Chain

In terminal window #1, execute the following commands:

```sh

# Install npm packages
npm install

# Start local anvil chain
npm run start:anvil
```

### Deploy Contracts and Start Operator

Open a separate terminal window #2, execute the following commands

```sh
# Setup .env file
cp .env.example .env
cp contracts/.env.example contracts/.env

# pinceptionSpecific Step
source .env

# Updates dependencies if necessary and builds the contracts 
npm run build

# Deploy the EigenLayer contracts
npm run deploy:core

# Deploy the Hello World AVS contracts
npm run deploy:hello-world

### pinceptionSpecific Steps START

# Note: Start local docker daemon
# eg on mac: 
open /Applications/Docker.app

# Start Local IPFS Container
docker run --rm -d --name $IPFS_OPERATOR_NAME \
    -p 4001:4001 \
    -p 5001:5001/tcp \
    -p 4001:4001/udp \
    ipfs/kubo:latest

### pinceptionSpecific Steps END

# Start the Operator application
npm run start:operator

```

### Create Hello-World-AVS Tasks

Open a separate terminal window #3, execute the following commands

```sh

source .env

# Simulated IPFS container to simulate a remote (separate) IPFS server for testing
docker run --rm -d --name $IPFS_SIM_REMOTE \
    -p 4002:4001 \
    -p 5002:5001/tcp \
    -p 4002:4001/udp \
    -p 8081:8080 \
    ipfs/kubo:latest


# Pin a file on a simulated remote IPFS server
MSG="Hello, IPFS Today is $(date '+%Y-%m-%d') and the time is $(date '+%H:%M:%S') .. and Nashville is amazing"
echo $MSG
# Add file to simulated remote IPFS server
CID1=$(curl -X POST -F file=@- "${IPFS_SIM_REMOTE_API}/add" <<< "${MSG}" | jq -r .Hash)
# Pin the CID
curl -X POST "${IPFS_SIM_REMOTE_API}/pin/add?arg=${CID1}" | jq

## Check the list of simulated remote pinned files
curl -X POST ${IPFS_SIM_REMOTE_API}/pin/ls | jq 


## Check the list of pinned files on the local operator
curl -X POST ${IPFS_OPERATOR_API}/pin/ls | jq



AVS_CONTRACT_ADDR=$(jq -r '.addresses.helloWorldServiceManager' contracts/deployments/hello-world/31337.json)
# Call the CID emit contract on chain
cast send $AVS_CONTRACT_ADDR "createNewTask(string)" "${CID1}" \
    --private-key $PRIVATE_KEY


## Check the list of locally pinned files
curl -X POST ${IPFS_OPERATOR_API}/pin/ls | jq 
## Check the lis of simulated remote pinned files
curl -X POST ${IPFS_SIM_REMOTE_API}/pin/ls | jq


```

