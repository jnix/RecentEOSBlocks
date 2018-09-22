//
//  EOSBlockDetailVC.swift
//  RecentEOSBlocks
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import Foundation
import UIKit

class EOSBlockDetailVC : UIViewController {
    
    var blockNum: Int = 0
    var producer: String? = nil
    var producerSig: String? = nil
    var numTransactions: Int = 0
    var transactions: [EOSTransaction]? = nil
    var rawBlock: String? = nil
    
    @IBOutlet weak var uiBlockNum: UITextField!
    @IBOutlet weak var uiProducer: UITextField!
    @IBOutlet weak var uiNumTransactions: UITextField!
    @IBOutlet weak var uiProducerSignature: UITextView!
    @IBOutlet weak var uiShowRawSwitch: UISwitch!
    @IBOutlet weak var uiShowRawText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Block detail: blockNum is \(blockNum)")
        uiBlockNum.text = "\(blockNum)"
        uiShowRawSwitch.setOn(false, animated: false)
        uiProducer.text = producer ?? ""
        if let txs = transactions {
            uiNumTransactions.text = "\(txs.count)"
        } else {
            uiNumTransactions.text = "No transactions"            
        } 
        uiProducerSignature.text = producerSig ?? ""
        uiShowRawText.text = rawBlock ?? ""
        uiShowRawText.isHidden = true
        uiShowRawText.isEditable = false
        uiProducerSignature.isEditable = false
    }
    
    @IBAction func showRawSwitchChanged(_ sender: UISwitch) {
        if uiShowRawText.isHidden {
            uiShowRawText.isHidden = false
        } else {
            uiShowRawText.isHidden = true
        }
    }
}
