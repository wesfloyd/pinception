const { exec } = require('child_process');
const { spawn } = require('child_process');

const child = spawn('ipfs daemon' );



function execCmd(cmdString) {
    exec(cmdString, (error, stdout, stderr) => {
        if (error) {
            console.log(`cmdString: ${cmdString}`);
            console.error(`Error: ${error.message}`);
            return;
        } else if (stderr) {
            console.log(`cmdString: ${cmdString}`);
            console.error(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        
    });
}

async function main() {
    
    // Start the IPFS server
    execCmd(" &");
    
    // Check the IPFS server status
    
    // Kubo API: ipns://docs.ipfs.tech/reference/kubo/rpc/#getting-started
    const response = await fetch('http://127.0.0.1:5001/api/v0/id');
    const json = await response.json()
    console.log(json);

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