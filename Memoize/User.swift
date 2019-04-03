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
   
   
   init?(name: String?, phone: String?, email: String?, biometrics: Bool)
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
   
}
