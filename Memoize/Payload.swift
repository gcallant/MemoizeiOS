//
// Created by Grantley on 2/16/21.
// Copyright (c) 2021 grantcallant. All rights reserved.
//

import Foundation

struct Payload : Codable
{
   var payload_hash: String
   var payload_json: Data
   var signatures: [String: [String: String]]
}
