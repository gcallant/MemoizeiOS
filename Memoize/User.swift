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
   var userKey: Key
   var tag: Data
   
   
   init?(_ name: String?, _ phone: String?, _ email: String?, _ biometrics: Bool)
   {
      guard ((name != nil) || (phone != nil) || (email != nil))
      else
      {
         return nil
      }
      self.name = name
      self.phone = phone
      self.email = email
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
      UserDefaults.standard.set(false, forKey: "firstRun")
      UserDefaults.standard.synchronize()
   }
   
   static func clearUser()
   {
      UserDefaults.standard.removeObject(forKey: "Name")
      UserDefaults.standard.removeObject(forKey: "Phone")
      UserDefaults.standard.removeObject(forKey: "Email")
      UserDefaults.standard.removeObject(forKey: "Biometrics")
   }
   
   static func loadUser() -> User?
   {
      let name       = UserDefaults.standard.string(forKey: "Name")
      let phone      = UserDefaults.standard.string(forKey: "Phone")
      let email      = UserDefaults.standard.string(forKey: "Email")
      let biometrics = UserDefaults.standard.object(forKey: "Biometrics") as! Bool
      
      return User(name, phone, email, biometrics)
   }
}
