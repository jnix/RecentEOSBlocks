//
//  MainViewController.swift
//  RecentEOSBlocks
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    lazy var mainNavigationController: MainNavigationController = { () -> MainNavigationController in
        let appDelegate = UIApplication.shared.delegate as! EOSBlocksAppDelegate
        let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController    
        appDelegate.navigationController = mainNavigationController
        return mainNavigationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func ViewRecentBlocksButtonPressed(_ sender: UIButton) {
        present(mainNavigationController, animated: false, completion: { () in 
            if let topController = UIApplication.topViewController() {
                if (topController is EOSBlockListTableViewController) {
                    if let eosController = topController as? EOSBlockListTableViewController { 
                        eosController.resetData()
                        eosController.performNetworkFetch()
                    }
                }
            }
        })
    }
    
}

