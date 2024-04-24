/**
 * Pinning service using local IPFS daemon
 */
import fetch from 'node-fetch'

// todo encapsulate this in a global module or namespace object
const ipfsDaemonSocket = 'http://127.0.0.1:5001';

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
  const Web3 = require('web3');
  const web3 = new Web3('https://mainnet.infura.io/v3/YOUR-PROJECT-ID');

  // Replace with the ABI (Application Binary Interface) of your smart contract
  const contractABI = [
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_task",
          "type": "string"
        }
      ],
      "name": "newTask",
      "type": "event"
    },
    // Other contract functions and events
  ];

  // Replace with the contract address of your smart contract
  const contractAddress = '0x1234567890123456789012345678901234567890';

  const contract = new web3.eth.Contract(contractABI, contractAddress);

  // Listen for the 'newTask' event
  contract.events.newTask({}, (error, event) => {
    if (error) {
      console.error('Error:', error);
    } else {
      console.log('New task created:', event.returnValues._task);
    }
  });
}



async function main() {

  // Kubo API reference: ipns://docs.ipfs.tech/reference/kubo/rpc/#getting-started
  checkIPFSDaemonAvailable();
  
  const testHash = "QmXuZ8Ge2FFoF5DWQUmwBDrdvCV3wCe9nToKRRAe2PVziQ";
  addIPFSHash(testHash);

  //listenForNewCIDTask();


}
main()