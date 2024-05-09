<p align="center">
  <a href="https://github.com/wesfloyd/pinception">
    <img src="https://github.com/wesfloyd/pinception/assets/260568/fb6c8685-888b-450d-842b-9060a7fd0ace" alt="pinception" width="400"/>
  </a>
</p>

<h1 align="center">Pinception</h1>
<h3 align="center">Decentralized IPFS Pinning Service Built on EigenLayer</h2>

# Project Goals
- Build an AVS in the open, via community, that enables decentralized, crypto incentivized "[IPFS](ipfs.tech) Pinning as a Service" (AVS) on [EigenLayer](https://docs.eigenlayer.xyz/eigenlayer/overview). 
- Background and inspiration [here](https://x.com/DennisonBertram/status/1772621874192584962).
- Interested in following our progress? Join the discussions [here](https://github.com/wesfloyd/pinception/discussions). Join the Telegram group [here](https://t.me/+IZGuHJNzOQQwZDRh).

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

## Proposed Simplified Design
This system provides a decentralized solution for IPFS pinning and ensures that node operators are genuinely hosting the pinned files. It utilizes smart contracts, Merkle trees, and a verification process to prove the availability and integrity of the data.

### Diagram
<img width="847" alt="Screenshot 2024-04-05 at 4 29 47 PM" src="https://github.com/wesfloyd/pinception/assets/1938013/ac89fc78-7660-4fb3-a7ef-6fb5e712ea34">


### Pinning a File
- A user pins a file by providing the following information to a smart contract:
`CID`: The IPFS hash of the file.
`Merkle Root`: The Merkle root of the file, split into chunks, with each chunk hashed against the signer's public key.
`Payment`: A fee for the pinning service.

- The smart contract emits an event containing this data, making it available for the AVS (Availability Verification System) network to index.

### Committee Verification
- A randomly chosen committee verifies the file's availability to prevent griefing attacks.
- The committee pulls the file, splits it into chunks, hashes each chunk with the pinner's public key, creates a Merkle tree, and compares the root with the one provided by the pinner.
- Each committee member then hashes the chunks with their own unique public key, creates a Merkle tree, and puts a signed message on-chain with their unique Merkle root.
This allows anyone with access to the file (specifically the original pinner) to verify that the AVS network has successfully reached and replicated the file and verified its contents.

### Proof of Storage
- At intervals, the network randomly chooses a subset of the AVS network participants to prove they are hosting the data.
- The selected participants are asked to provide a Merkle root of a tree of chunks from multiple randomly selected files.
- For each file, a random chunk is requested. The node operator collects the randomly selected chunks, hashes each chunk with their public key, creates a Merkle trie, and posts the Merkle root on-chain.
- Other participants can verify the correctness of the posted Merkle root by performing the calculation themselves and comparing it with the original files' Merkle roots when published on-chain by the pinners.
- If the Merkle root is incorrect, it can be proven on-chain by working backwards from the original files' Merkle roots and comparing the chunks.

### File Retrieval
- The process of requesting a file should also include the proving system.(maybe?) 
- This ensures that the node operators are genuinely hosting the data and not just pulling it from other nodes at the time of request.

### Benefits
- Ensures the availability and integrity of pinned files in a decentralized manner.
- Prevents node operators from cheating by merely pulling files from other nodes at the time of request.
- Utilizes Merkle trees and proofs of storage to make it impractical for node operators to cheat.
- Provides a verification mechanism that allows anyone to validate the availability and correctness of the pinned files.

# Roadmap
See Issues for ongoing sprint tracking.

# Demo

For now, see `demo.sh`
Working demo video here: https://www.loom.com/share/96f95fc55c0a48bb934465e9be55b5ea


