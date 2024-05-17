/**
 * Pinning service using local IPFS daemon
 */
import fetch from 'node-fetch'
import 'dotenv/config'
import fs from 'fs'
import { ethers } from "ethers";


// todo encapsulate this in a global module or namespace object
const ipfsDaemonSocket = process.env.IPFS_DAEMON_SOCKET;

async function checkIPFSDaemonAvailable(){

  // Check the IPFS server status
  const apiUrl = ipfsDaemonSocket + '/api/v0/id';

  // Test fetching data from the API
  fetch(apiUrl, {
    method: 'POST'
  })
    .then(response => {
      // Check if the response is successful
      if (response.ok) {
        // Parse the response as JSON
        // return response.json();
        console.log("Local IPFS daemon is running.");
      } else {
        // Throw an error if the response is not successful
        throw new Error('Failed to fetch data. \n Response status: ' + response.status + ' ' + response.statusText);
      }
    })
    .then(data => {
      // Handle the parsed JSON data
      console.log(data);
      // You can perform any further operations with the data here
    })
    .catch(error => {
      // Handle any errors that occurred during the fetch operation
      console.error('Error:', error);
    });
}

async function addIPFSHash(hash) {
  try {
    
    console.log('Sending IPFS pin add request for hash:', hash);

    // Make the POST request to the IPFS API
    const response = await fetch(ipfsDaemonSocket + 
        '/api/v0/pin/add?arg=' + hash, {
      method: 'POST'
    });
    
    // The response from the IPFS API will contain the hash of the added file
    console.log('IPFS hash added:', await response.text());
  } catch (error) {
    console.log(error);
  }
}


async function listenForNewCIDTask() {

  const provider = new ethers.JsonRpcProvider(process.env.ETH_RPC_SOCKET);
  
  //console.log ("Blocknumber" + await provider.getBlockNumber());

  const jsonFile = "../contracts/out/CIDEmitter.sol/CIDEmitter.json";
  const parsed = JSON.parse(fs.readFileSync(jsonFile));
  const contractABI = parsed.abi;

  const contract = new ethers.Contract(process.env.CID_EMITTER_CONTRACT_ADDR, contractABI, provider);

  console.log('Listening for new event CIDToPIN ...');

  // Listen for the event
  contract.on('CIDToPIN', (data) => {
    console.log('CIDToPIN emitted:', data);
    addIPFSHash(data);
    
  });

}


async function main() {
  const myVariable = process.env.MY_VARIABLE;

  // Kubo API reference: ipns://docs.ipfs.tech/reference/kubo/rpc/#getting-started
  //checkIPFSDaemonAvailable();
  
  // Listen for new CID and invoke addIPFSHash
  listenForNewCIDTask();
  
  //addIPFSHash(cidToBePinned);

}
main()
