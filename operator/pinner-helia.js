import { createHelia } from 'helia'
import { unixfs } from '@helia/unixfs'
import readline from 'readline'
import { program } from 'commander'
import { createLibp2p } from 'libp2p'
import { noise } from '@chainsafe/libp2p-noise'
import { yamux } from '@chainsafe/libp2p-yamux'
import { identify } from '@libp2p/identify'
import { webSockets } from '@libp2p/websockets'
import { bootstrap } from '@libp2p/bootstrap'
import { tcp } from '@libp2p/tcp'
import { MemoryBlockstore } from 'blockstore-core'
import { MemoryDatastore } from 'datastore-core'

async function processString(input) {
    // Process the input string here
    console.log('Received input:', input)
}


async function createNode () {
    // the blockstore is where we store the blocks that make up files
    const blockstore = new MemoryBlockstore()
  
    // application-specific data lives in the datastore
    const datastore = new MemoryDatastore()
  
    // libp2p is the networking layer that underpins Helia
    const libp2p = await createLibp2p({
      datastore,
      addresses: {
        listen: [
          '/ip4/127.0.0.1/tcp/0'
        ]
      },
      transports: [
        tcp()
      ],
      connectionEncryption: [
        noise()
      ],
      streamMuxers: [
        yamux()
      ],
      peerDiscovery: [
        bootstrap({
          list: [
            '/dnsaddr/bootstrap.libp2p.io/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN',
            '/dnsaddr/bootstrap.libp2p.io/p2p/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa',
            '/dnsaddr/bootstrap.libp2p.io/p2p/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb',
            '/dnsaddr/bootstrap.libp2p.io/p2p/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt'
          ]
        })
      ],
      services: {
        identify: identify()
      }
    })
  
    return await createHelia({
      datastore,
      blockstore,
      libp2p
    })
  }


async function main() {
    const node1 = await createNode()
    const fs = unixfs(node1)

    const encoder = new TextEncoder()
    const bytes = encoder.encode('Something unique wes' + Math.random() + ' to write to IPFS.')

    const cid = await fs.addBytes(bytes)

    console.log('Added file:', cid.toString())

    // Pause the program here
    await new Promise(() => {})

    // Todo find out why the CID isn't available publicly yet

    /** 
     * Next - accept interactive user input and write the string to IPFS
     
    program
        .version('1.0.0')
        .description('Accept input from the user')

    program
        .command('input')
        .alias('i')
        .description('Enter a string')
        .action(async () => {
            const rl = readline.createInterface({
                input: process.stdin,
                output: process.stdout
            })

            rl.question('Enter a string: ', async (input) => {
                // Call the processString function with the input
                await processString(input)

                // Close the readline interface
                rl.close()
            })
        })

    program.parse(process.argv)
    */

    
}

main()