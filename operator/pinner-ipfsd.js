/**
 * Pinner using local IPFS daemon
 */


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

  // Check the IPFS server status
  
  try {
    // Kubo API: ipns://docs.ipfs.tech/reference/kubo/rpc/#getting-started
    
    const responseID = await fetch('http://127.0.0.1:5001/api/v0/id',{
      method: "POST"
    })
    json = await response.json()
    console.log(json); 


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
  

  /**

  if (json.status === 'completed') {
    return res.json(json);
  } else {

    return res.json({
      status: 'running'
    });
  }
    */

}
main()