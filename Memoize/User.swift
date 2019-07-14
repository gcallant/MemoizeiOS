//
//  User.swift
//  Memoize
//
//  Created by Grant on 2/14/19.
//  Copyright © 2019 grantcallant. All rights reserved.
//

import Foundation

class User: CustomStringConvertible
{
   public var description: String
   {return "User: \(name)\nPhone: \(phone)\nEmail: \(email)"}
   
   var name:       String?
   var phone:      String?
   var email:      String?
   var biometrics: Bool
   var userID: Int
   var userKey: Key
   var tag: Data
   
   
   init?(_ name: String?, _ phone: String?, _ email: String?, _ biometrics: Bool, _ userID: Int = 0)
   {
      guard ((name != nil) || (phone != nil) || (email != nil))
      else
      {
         return nil
      }
      self.name = name
      self.phone = phone
      self.email = email
      self.userID = userID
      self.biometrics = biometrics
      self.tag = "\(name).\(phone).\(email).key".data(using: .utf8)!
      self.userKey = Key(tag)
   }
   
   static func userFactory(_ dictionary: [String: Any?]) -> User?
   {
      let name       = dictionary["Name"] as? String
      let phone      = dictionary["Phone"] as? String
      let email      = dictionary["Email"] as? String
      let biometrics = dictionary["Biometrics"] as? Bool ?? false
      let passcode   = dictionary["Passcode"] as! String
      let account    = "\(name).\(phone).\(email)"
      Passcode.savePasscode(passcode, account)
      
      return User(name, phone, email, biometrics)
   }
   
   func saveUser()
   {
      UserDefaults.standard.set(name, forKey: "Name")
      UserDefaults.standard.set(phone, forKey: "Phone")
      UserDefaults.standard.set(email, forKey: "Email")
      UserDefaults.standard.set(biometrics, forKey: "Biometrics")
      UserDefaults.standard.set(userID, forKey: "userID")
      UserDefaults.standard.set(false, forKey: "firstRun")
      UserDefaults.standard.synchronize()
      print("User \(self) was saved")
   }
   
   static func clearUser()
   {
      UserDefaults.standard.removeObject(forKey: "Name")
      UserDefaults.standard.removeObject(forKey: "Phone")
      UserDefaults.standard.removeObject(forKey: "Email")
      UserDefaults.standard.removeObject(forKey: "Biometrics")
      UserDefaults.standard.removeObject(forKey: "userID")
   }
   
   static func loadUser() -> User?
   {
      let name       = UserDefaults.standard.string(forKey: "Name")
      let phone      = UserDefaults.standard.string(forKey: "Phone")
      let email      = UserDefaults.standard.string(forKey: "Email")
      let biometrics = UserDefaults.standard.bool(forKey: "Biometrics")
      let userID = UserDefaults.standard.integer(forKey: "userID")
      
      return User(name, phone, email, biometrics, userID)
   }
}
