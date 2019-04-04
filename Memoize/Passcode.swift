//
// Created by Grantley on 2019-04-04.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import BCryptSwift

class Passcode
{
   private static let service = "Memoize"
   
   static func savePasscode(_ passcode: String, _ account: String)
   {
      let hashedPasscode = getHashedPasscode(passcode)!
      KeychainService.savePassword(service: service, account: account, data: hashedPasscode)
   }
   
   private static func getHashedPasscode(_ passcode: String) -> String?
   {
      let salt     = BCryptSwift.generateSalt()
      let passHash = BCryptSwift.hashPassword(passcode, withSalt: salt)
      return passHash
   }
}