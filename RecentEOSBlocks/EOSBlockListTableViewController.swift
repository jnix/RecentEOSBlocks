//
//  EOSBlockListTableViewController.swift
//  RecentEOSBlocks
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import Foundation
import UIKit

class EOSBlockListTableViewController : UITableViewController {
    
    var eosInfo : EOSInfo? = nil
    var eosBlocks : [EOSBlock]? = nil
    var numBlocksFetched : Int {
        return eosBlocks?.count ?? 0
    }
    
    var segueBlockIndex : Int = 0
    
    var spinner : UIView? = nil
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("finished viewWillAppear")
    }
    
    // resetData Called by MainViewController before launching this ViewController.  Not done in an init because hitting back and entering the VC again won't recreate the VC.  
    // Not done in viewWillAppear because coming back from the detail screen shouldn't cause a (slow) reload of data.
    func resetData() { 
        eosInfo = nil
        eosBlocks = nil
        fetchResultArray = [EOSBlock]()  
    }
    
    // show spinner when waiting for network data to load
    func showSpinner() {
        spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    func hideSpinner() {
        if let spinner = spinner {
            UIViewController.removeSpinner(spinner: spinner)
            self.spinner = nil
        }
    }
    
    // MARK: - Network fetch
    
    func performNetworkFetch() {
        print("network fetch")
        showSpinner()
        networkFetchEOSInfo()
        
    }
    
    // Asynchronous fetch of the EOS Info endpoint to get the head block number
    // When completed, this will call networkFetchEOSBlocks() to fetch the individual blocks
    func networkFetchEOSInfo() { 
        let url = "https://api.eosnewyork.io/v1/chain/get_info"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
        do{
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("Fetch EOS Info: status code = \(statusCode)")
                    
                }
                if let error = error {
                    print ("Fetch EOS Info: error - \(error)")
                }
                if let data = data {
                    do{
                        let eosInformation = try
                           JSONDecoder().decode(EOSInfo.self, from: data)
                        self.eosInfo = eosInformation
                        if let blockNum = eosInformation.head_block_num {
                            print ("Fetch EOS Info: head block number is \(blockNum)")
                            self.networkFetchEOSBlocks()
                        } else {
                            print ("Fetch EOS Info: no blockNum")
                        }
                    } catch _ {
                        print ("Fetch EOS Info: JSON format issue")
                    }
                }
            })
            task.resume()
        } 
        
    }
    
    var fetchResultArray = [EOSBlock]()
    
    // async fetch of the last 20 EOS Blocks, using a DispatchGroup
    func networkFetchEOSBlocks() { 
        if let headBlockNum = eosInfo?.head_block_num {
            print ("Fetch EOS Blocks: head block number is \(headBlockNum)")
            
            if (headBlockNum < 20) {
                print("Fetch EOS Blocks: Error: something is wrong, block num < 20 ")
                return
            }
            
            let grp = DispatchGroup()
            
            for blk in 0...19 {
                grp.enter()
                    
                networkFetchSingleEOSBlock(fromHeadBlock: headBlockNum, blocksBackwardIndex:blk, usingDispatchGroup: grp, attemptCount: 0)
            }
            grp.notify(queue: DispatchQueue.main) { // called after all 20 blocks are completed
                self.networkFetchFinished()
            }
                
        }
    }
    
    // fetch an individual EOS Block, indexed backwards by 'blocksBackwardIndex' blocks from the last block number ('fromHeadBlock'),
    // and using the DispatchGroup named by 'usingDispatchGroup'.  Always call with attemptCount 0.  attemptCount will be incremented if a retry is necessary.
    func networkFetchSingleEOSBlock(fromHeadBlock headBlockNum : Int, blocksBackwardIndex blk : Int, usingDispatchGroup grp: DispatchGroup, attemptCount attempt: Int) {
        
        let url = "https://api.eosnewyork.io/v1/chain/get_block"
        
        var params: [String: Any]?
        let fetchingBlockNum = headBlockNum-blk
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("preparing to fetch block \(fetchingBlockNum)")
        params = ["block_num_or_id" : fetchingBlockNum]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: JSONSerialization.WritingOptions()) 
        } catch let error {
            print("Fetch EOS Block: error forming request body - \(error.localizedDescription)")
            return 
        }
        
        print("fetch block index \(blk)")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if let response = response {
                let nsHTTPResponse = response as! HTTPURLResponse
                let statusCode = nsHTTPResponse.statusCode
                print ("Fetch EOS Block: status code = \(statusCode)")
                if (statusCode != 200) {
                    print("response is: \(response)")
                    if (statusCode == 429) {
                        // 429 means too many requests
                        if (attempt < 5) {
                            // retry the fetch, up to 4 times, avoiding the grp.leave (because it should be done when it succeeds)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                self.networkFetchSingleEOSBlock(fromHeadBlock : headBlockNum, blocksBackwardIndex: blk, usingDispatchGroup: grp, attemptCount: attempt+1)
                            })
                        } else {
                            print("Fetch EOS Block: Too many retries, giving up on block \(fetchingBlockNum)")
                            grp.leave()                  
                        }
                        return
                    }
                } 
            }
            if let error = error {
                print ("Fetch EOS Block: error - \(error)")
            }
            if let data = data {
                do{
                    let dataString = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    print ("Fetch EOS Block: data = \(dataString)")
                    var eosBlockResult = try
                        JSONDecoder().decode(EOSBlock.self, from: data)
                    eosBlockResult.entireRawBlock = dataString
                    self.fetchResultArray.append( eosBlockResult )
                    if let blockNum = eosBlockResult.block_num {
                        print ("Fetch EOS Block: block number fetched is \(blockNum), index is \(blk)")
                    } else {
                        print ("Fetch EOS Block: no blockNum")
                    }
                } catch let error {
                    print ("Fetch EOS Block: JSON format issue.  \(error.localizedDescription)")
                }
            }
            grp.leave() 
        })
        task.resume()
    }
    
    func networkFetchFinished() {
        print("finished network fetch")
        eosBlocks = fetchResultArray
        blockNumberSort()
        hideSpinner()
        self.tableView.reloadData()
    }
    
    // Async network requests come back in random order, so the resulting array should be sorted by blocknumber
    func blockNumberSort() {
        eosBlocks?.sort(by: {
            guard let b0 = $0.block_num, let b1 = $1.block_num else { return false }
            return b0 > b1
        }) 
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numBlocksFetched
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EOSBlockCell", for: indexPath)
        
        if let blockNum = eosBlocks?[indexPath.row].block_num {
            cell.textLabel?.text = "Block number: \(blockNum)" 
        }
        if let blockTime = eosBlocks?[indexPath.row].timestamp {
            cell.detailTextLabel?.text = "Block time: \(blockTime)" 
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueDetail") {
            let vc = segue.destination as! EOSBlockDetailVC
            
            if let blockNum = eosBlocks?[segueBlockIndex].block_num {
                vc.blockNum = blockNum 
            }
            if let blockProd = eosBlocks?[segueBlockIndex].producer {
                vc.producer = blockProd 
            }
            if let blockProdSig = eosBlocks?[segueBlockIndex].producer_signature {
                vc.producerSig = blockProdSig 
            }
            if let blockTx = eosBlocks?[segueBlockIndex].transactions {
                vc.transactions = blockTx
            }
            if let rawBlock = eosBlocks?[segueBlockIndex].entireRawBlock {
                vc.rawBlock = rawBlock
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row for cell id \(indexPath.row)")
        segueBlockIndex = indexPath.row
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    

    // MARK: - actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        resetData()
        self.tableView.reloadData()
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
