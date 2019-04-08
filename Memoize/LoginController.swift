//
// Created by Grantley on 2019-04-03.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import LocalAuthentication
import BCryptSwift

class LoginController
{
   private let user = User.loadUser()!
   
   func login(_ passcode: String) -> Bool
   {
      let account       = "\(user.name).\(user.phone).\(user.email)"
      let savedPasscode = Passcode.loadPasscode(account)
      let passMatches   = BCryptSwift.verifyPassword(passcode, matchesHash: savedPasscode)
      if passMatches == nil
      {
         print("Saved passcode was hashed incorrectly")
         return false
      }
      guard passMatches!
      else
      {
         print("Passcode did not match saved passcode")
         return false
      }
      return true
   }
}