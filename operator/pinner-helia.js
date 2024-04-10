import { createHelia } from 'helia'
import { unixfs } from '@helia/unixfs'
import readline from 'readline'
import { program } from 'commander'

async function processString(input) {
    // Process the input string here
    console.log('Received input:', input)
}

async function main() {
    const helia = await createHelia()
    const fs = unixfs(helia)

    const encoder = new TextEncoder()
    const bytes = encoder.encode('Hello World 101')

    const cid = await fs.addBytes(bytes)

    console.log('Added file:', cid.toString())

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
}

main()