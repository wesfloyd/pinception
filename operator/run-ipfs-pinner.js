
//- Build a draft offline service in Javascript that listens for an on chain event (NewDataSubmission) and pins the associated CID.
/** Short term planning:
 * build a program that inovkes the local IPFS server instance
 * modify the program to get status from local IPFS server instance
 * modify to add and pin IPFS file locally
 * write test functions
 */

// - Test: setup a local [Foundry Anvil](https://book.getfoundry.sh/anvil/) test script that emits the event to trigger the CID download.
/**
 * Modify run script to launch anvil chain
 * load simple contract to the chain that emits the new file name event
 * 
 */




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