# Pinception
Decentralized IPFS Pinning Service AVS

<img src="https://github.com/wesfloyd/pinception/assets/260568/fb6c8685-888b-450d-842b-9060a7fd0ace" alt="pinception" width="400"/>


## Goals
To build an AVS in the open, via community, that enables crypto incentivized IPFS Pinning as an AVS on [EigenLayer](https://docs.eigenlayer.xyz/eigenlayer/overview). Background [here](https://x.com/DennisonBertram/status/1772621874192584962).

# Design

## User Stories

Story 0) Operator Registration
- Operator registers their IPFS address and [IPFS peerID](ipns://docs.ipfs.tech/concepts/dht/#kademlia) to their Operator Address in EigenLayer registry contracts.

Story 1) Data Submission:
- User submits an [IPFS hash (CID)](docs.ipfs.tech/concepts/content-addressing) to an AVS contract along with a payment.
  - Payment amount dictates the duration of data storage and delivery.
- All AVS nodes are expected host the IPFS Content within a specified amount of time and then deliver the content to any request in the IPFS network.

Story 2) Daily Proving of Data:
- (Note: there are many, many, many potential solutions to this problem. For now, we're starting with an example high level, simplest route to achieving these goals)
- At a regular interval (eg daily) a randomized group of nodes are chosen to be act as a "retrievability" proving committee. The committee will choose a subset of CIDs to confirm retrievablity.
  - The committee will attempt to connect to each IPFS server, downloaded the file, and verify it matches the CID.
  - Eg ipfs swarm connect `ipfs swarm connect /ip4/<server_ip_address>/tcp/4001/ipfs/<peer_id>` , `ipfs get <ipfs_file_hash>`
- Committee updates the AVS contracts with the peerID, CID and success or failure of the download operation.

Story 3) Payments and Slashing conditions:
- Payments: each time interval - payments are sent to the IPFS servers listed as hosting a given CID
- Slashing: any IPFS server whom the committee records 66% failure for a given CID gets [some very small penalty, tbd, potentially slashed a small amount of their stake].

## Architecture

Ideas:
- Build the backend AVS code in Javascript in order to appeal to the largest audience possible.
- Reuse existing IPFS bits where possible ([example](https://github.com/ipfs/kubo?tab=readme-ov-file#docker)).

# Roadmap

- Build a draft AVS offline service in Javascript that listens for an event (NewDataSubmission) and pins the associated CID
- Test: setup a local [Foundry Anvil](https://book.getfoundry.sh/anvil/) test script that emits the event to trigger the CID download.
- Build EigenLayer AVS contracts to register Operators, register the AVS and custom AVS contracts to manage the state of pinned CIDs & their Operators.
- Test: modify test scripts to automate registration and and validate new contracts.
- Build & Test Story 2.
- Build & Test Story 3. 
