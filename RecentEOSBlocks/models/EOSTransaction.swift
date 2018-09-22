//
//  EOSTransaction.swift
//  RecentEOSBlocks
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import Foundation

/*
 example of two transactions:
 
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
 */

struct EOSTransaction: Codable {
    let status: String?
    let cpu_usage_us: Int64?
    let net_usage_words: Int64?
    //let trx: EOSTransactionTx?
}

struct EOSTransactionTx : Codable {
    let id: String?
    let compression: String?
    let packed_context_free_data: String?
    let packed_trx: String?
    let signatures: [String]?
    let transaction: [EOSTransactionTxTransaction]?
}

struct EOSTransactionTxTransaction : Codable {
    let actions: EOSTransactionTxTransactionAction?
    let context_free_actions: [String]?
    let delay_sec: Int64? 
    let expiration: String?
    let max_cpu_usage_ms: Int64?
    let max_net_usage_words: Int64?
    let ref_block_num: Int64?
    let ref_block_prefix: Int64?
    let transaction_extensions: [String]?
}

struct EOSTransactionTxTransactionAction : Codable {
    let account: String?
    let authorization: [[String: String]]?
    let data: [String: String]?
    let hex_data: String?
    let name: String?
}

