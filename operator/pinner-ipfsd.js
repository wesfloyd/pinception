/**
 * Pinning service using local IPFS daemon
 */
import fetch from 'node-fetch'
import 'dotenv/config'
import Web3 from 'web3';
import fs from 'fs';


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



async function listenForNewCIDTask(){
  const web3 = new Web3(process.env.RPC_URL);

  // Replace with the ABI (Application Binary Interface) of your smart contract
  var jsonFile = "../contracts/out/CIDEmitter.sol/CIDEmitter.json";
  var parsed = JSON.parse(fs.readFileSync(jsonFile));
  var contractABI = parsed.abi;

  // Replace with the contract address of your smart contract
  const cidEmitterContractAddr = process.env.CID_EMITTER_CONTRACT_ADDR;
  const contract = new web3.eth.Contract(contractABI, contractAddress);

  // Listen for the 'newTask' event
  contract.events.newTask({}, (error, event) => {
    if (error) {
      console.error('Error:', error);
    } else {
      console.log('New task created:', event.returnValues._task);
      return event.returnValues._task;
    }
  });

  return 'No new task found on chain';
}



async function main() {
  const myVariable = process.env.MY_VARIABLE;

  // Kubo API reference: ipns://docs.ipfs.tech/reference/kubo/rpc/#getting-started
  checkIPFSDaemonAvailable();
  
  cidTask = listenForNewCIDTask();

  console.log("SUCCESS: ready to pin cidTask value:" + cidTask);

  //const testHash = "QmXuZ8Ge2FFoF5DWQUmwBDrdvCV3wCe9nToKRRAe2PVziQ";
  //addIPFSHash(testHash);

  


}
main()