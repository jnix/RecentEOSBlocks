//
//  RecentEOSBlocksTests.swift
//  RecentEOSBlocksTests
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import XCTest
@testable import RecentEOSBlocks

class RecentEOSBlocksTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController() as! MainViewController
        let _ = mainVC.view
        XCTAssertEqual("Recent EOS Blocks", mainVC.title!)
    }
    
    func testEOSInfoModel() {
        let jsonData = """
{
"block_cpu_limit": 192091,
"block_net_limit": 1048184,
"chain_id": "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
"head_block_id": "010a9c9e1ef98cadca3972d9adda4edf973da8793539212484686e5f2e4ebff0",
"head_block_num": 17472670,
"head_block_producer": "starteosiobp",
"head_block_time": "2018-09-20T21:38:27.500",
"last_irreversible_block_id": "010a9b522b0c4193f947e282d87dbbe07b21d803c4bd9928afee8a5f0996a067",
"last_irreversible_block_num": 17472338,
"server_version": "3e6d766a",
"server_version_string": "v1.2.6-dirty",
"virtual_block_cpu_limit": 200000000,
"virtual_block_net_limit": 1048576000
}
""".data(using: .utf8)
        do {
            let eosInfo = try JSONDecoder().decode(EOSInfo.self, from: jsonData!)
            let headBlockNum = eosInfo.head_block_num
            XCTAssertEqual(headBlockNum,17472670)
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testEOSBlockModel() {
        let jsonData = """
{
"action_mroot": "d6a501311e5b157cd13646008d3ba481732da71e6bfa4b71e5213acb07516c8c",
"block_extensions": [],
"block_num": 17469583,
"confirmed": 0,
"header_extensions": [],
"id": "010a908f75525b20be9000b424f5806100fc980b89b416dba0c2cf7181f85901",
"new_producers": null,
"previous": "010a908e284573fab5dbfbb6e9a24d96f53735b6095cd8d366e5bdf7ddcca0c5",
"producer": "eospaceioeos",
"producer_signature": "SIG_K1_K1MFk3EE9NakfC2s3FXVQhVK7VfjuEM9eXC7Yoxf7FDcvzoXn1VTowoLewsWZDucXwaZhVpC638iF4fRLgWDhrSfvU6FLY",
"ref_block_prefix": 3019935934,
"schedule_version": 361,
"timestamp": "2018-09-20T21:12:44.000",
"transaction_mroot": "b4c6a8f5c6b8d9faf322f37b509bb7df3810cc9fe9dc2b6987d5505228d68ed1",
"transactions": [
{
"cpu_usage_us": 1092,
"net_usage_words": 0,
"status": "executed",
"trx": "60426a9344a68e04145d17d9b748df678edcbe71d646a9dfa7fe889cc9cdac01"
},
{
"cpu_usage_us": 3410,
"net_usage_words": 27,
"status": "executed",
"trx": {
"compression": "none",
"context_free_data": [],
"id": "87c8f61ecf9633786fd3eca9248131c45c08e2b431ed01d6b2386c51aa36bf58",
"packed_context_free_data": "",
"packed_trx": "860da45b468ff6846bac00000000011030556cbac3a63b00008891de86b239011030556cbac3a63b00000000a8ed323279783130303237385f315f31303b3130303237385f325f31303b3130303237385f335f31303b3130303237385f345f31303b3130303237385f355f31303b3130303237385f365f31303b3130303237385f375f31303b3130303237385f385f31303b3130303237385f395f31303b3130303237385f31305f313000",
"signatures": [
"SIG_K1_KWztyKiCksCKya8EuumAjKnd54bKwi9fMvUUAfKqqEygVnjAvsgk56rYNyHDLqeHXmVrk24WmZvgtMpvoZdKDQHt4jQ1Bx"
],
"transaction": {
"actions": [
{
"account": "bingbingeos1",
"authorization": [
{
"actor": "bingbingeos1",
"permission": "active"
}
],
"data": {
"request": "100278_1_10;100278_2_10;100278_3_10;100278_4_10;100278_5_10;100278_6_10;100278_7_10;100278_8_10;100278_9_10;100278_10_10"
},
"hex_data": "783130303237385f315f31303b3130303237385f325f31303b3130303237385f335f31303b3130303237385f345f31303b3130303237385f355f31303b3130303237385f365f31303b3130303237385f375f31303b3130303237385f385f31303b3130303237385f395f31303b3130303237385f31305f3130",
"name": "batchroll"
}
],
"context_free_actions": [],
"delay_sec": 0,
"expiration": "2018-09-20T21:13:42",
"max_cpu_usage_ms": 0,
"max_net_usage_words": 0,
"ref_block_num": 36678,
"ref_block_prefix": 2892727542,
"transaction_extensions": []
}
}
}
]
}
""".data(using: .utf8)
        do {
            let eosBlock = try JSONDecoder().decode(EOSBlock.self, from: jsonData!)
            let blockNum = eosBlock.block_num
            XCTAssertEqual(blockNum,17469583)
            let producer = eosBlock.producer
            XCTAssertEqual(producer,"eospaceioeos")
            let producer_signature = eosBlock.producer_signature
            XCTAssertEqual(producer_signature,"SIG_K1_K1MFk3EE9NakfC2s3FXVQhVK7VfjuEM9eXC7Yoxf7FDcvzoXn1VTowoLewsWZDucXwaZhVpC638iF4fRLgWDhrSfvU6FLY")            
            let timestamp = eosBlock.timestamp
            XCTAssertEqual(timestamp,"2018-09-20T21:12:44.000")
            let transactions = eosBlock.transactions
            XCTAssert( transactions!.count == 2 )
        } catch _ {
            XCTAssert(false)
        }
    }
    
    func testNetworkFetch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eosController = storyboard.instantiateViewController(withIdentifier: "EOSBlockListTableViewController") as! RecentEOSBlocks.EOSBlockListTableViewController
        
        let expectation = XCTestExpectation(description: "Network Fetch of 20 blocks of EOS data") 
        eosController.performNetworkFetch()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(25), execute: { 
            XCTAssertNotNil(eosController.eosInfo)
            XCTAssertEqual(eosController.eosBlocks!.count, 20)
            expectation.fulfill() 
        })
        wait(for: [expectation], timeout: 30.0)
    }
}
