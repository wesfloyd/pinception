/**
 * Pinning service using local IPFS daemon
 */
import fetch from 'node-fetch'


async function checkIPFSDaemonAvailable(){

  // Check the IPFS server status
  const apiUrl = 'http://127.0.0.1:5001/api/v0/id';

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


async function testAddLocalFile(){
  
    
  try {
    
    
    // URL of the API endpoint

    // Relative path to the image file
    const imagePath = '../assets/pinception.png';

    // Create a new File object from the image file
    const imageFile = new File([/* file contents */], 'image.png', {
      type: 'image/png',
      lastModified: new Date().getTime()
    });

    // Create a FormData object to hold the file
    const formData = new FormData();
    formData.append('file', getFileToBePinned);

    // Make the POST request to the IPFS API
    fetch('/api/v0/add', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      // The response from the IPFS API will contain the hash of the added file
      console.log('IPFS hash:', data.Hash);
    })
   

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
  
  const testHash = "";
  addIPFSHash(testHash);
  //testAddLocalFile();
  //listenForNewCIDTask


}
main()