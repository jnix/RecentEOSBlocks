# Recent EOS Blocks

'Recent EOS Blocks' is a tool for seeing the contents of the most recent blocks on the public EOS cryptocurrency blockchain.

It supports iOS only, at this time.

It was build with XCode 9.2 using Swift 4.0.   

## Main Features
- Fetches the 20 most recent blocks on the EOS public blockchain.
- Displays a list of the fetched blocks in a TableView.
- When an individual block is selected, a Block Details screen will show more information about the block.
- Raw data is optionally available at the Block Details screen.

## Getting Started

### Compilation

On a Mac, with XCode installed, click on RecentEOSBlocks.xcodeproj to open the Project in XCode.
Then press the run button.  The project will compile and run on the simulator you have selected.

To run the Unit tests, select ```Test``` from the ```Product``` Menu in XCode.  The Unit tests will run and should pass after
awhile.
Model decoding from JSON is tested, as well as a network fetch of the blockchain.

### Code Structure

This project uses the storyboard.
- The Main screen is implemented in ```MainViewController.swift```
- The List screen is implemented in ```EOSBlockListTableViewController.swift```
- The Block Details screen is implemented in ```EOSBlockDetailVC.swift```

Models are in the models directory: 
- ```EOSInfo.swift``` is the model for the preliminary information fetch which obtains the most recent block number.
- ```EOSBlock.swift``` is the model for holding Block data.
- ```EOSTransaction.swift``` is the model for holding Transaction data.

This project uses the new Codable mechanism in Swift 4, for JSON decoding.

### Usage

The first screen is as follows:

![Main Screen](/images/Main.png)

Press the "View Recent Blocks" button to start a network fetch of the last 20 EOS blocks.

After a few seconds, the blocks will be shown in a list, as follows:

![EOS Blocks List Screen](/images/Blocklist.png)

You can scroll down to see the rest of the blocks.

To see the details of a block, tap one of the block cells.   It will open up a Detail screen:

![EOS Block Details Screen](/images/Details.png)

(To see the raw content, toggle the switch labeled "Show Raw")





