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
   
   static func saveUser(_ user: User)
   {
      print("\(user) was created")
      UserDefaults.standard.set(user.name, forKey: "Name")
      UserDefaults.standard.set(user.phone, forKey: "Phone")
      UserDefaults.standard.set(user.email, forKey: "Email")
      UserDefaults.standard.set(user.biometrics, forKey: "Biometrics")
      UserDefaults.standard.synchronize()
      print("\(user) was saved")
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
