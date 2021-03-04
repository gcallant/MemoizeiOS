//
// Created by Grantley on 2019-04-04.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import BCryptSwift

class Passcode
{
   private static let APP_NAME = "Memoize"
   
   static func savePasscode(_ passcode: String, _ account: String)
   {
      let hashedPasscode = getHashedPasscode(passcode)!
      KeychainService.savePassword(service: APP_NAME, account: account, data: hashedPasscode)
   }
   
   static func saveToken(_ token: String, _ account: String)
   {
      KeychainService.savePassword(service: APP_NAME, account: account, data: token)
   }
   
   static func loadPasscode(_ account: String) -> String
   {
      return KeychainService.loadPassword(service: APP_NAME, account: account) ?? ""
   }
   
   private static func getHashedPasscode(_ passcode: String) -> String?
   {
      let salt     = BCryptSwift.generateSalt()
      let passHash = BCryptSwift.hashPassword(passcode, withSalt: salt)
      return passHash
   }
}