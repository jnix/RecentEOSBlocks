//
//  EOSInfo.swift
//  RecentEOSBlocks
//
//  Created by J Nichols on 9/20/18.
//  Copyright © 2018 Butterfly Valley LLC. All rights reserved.
//

import Foundation

/* sample EOSInfo JSON:
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

*/

struct EOSInfo : Decodable {
    let head_block_num: Int?
}

