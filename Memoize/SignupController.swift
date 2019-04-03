//
//  SignupController.swift
//  Memoize
//
//  Created by Grantley on 10/15/18.
//  Copyright © 2018 grantcallant. All rights reserved.
//

import Foundation
import BCryptSwift
import Security

class SignupController
{
   private static let service = "Memoize"
   
   static func setupKeys(user: User)
   {
      print("Generating key")
      let publicKey = generateKey(user: user)
      print("Key Generated")
   }
   
   static func createUser(dictionary: [String: Any?]) -> User?
   {
      let name       = dictionary["Name"] as? String
      let phone      = dictionary["Phone"] as? String
      let email      = dictionary["Email"] as? String
      let biometrics = dictionary["Biometrics"] as? Bool ?? false
      var passcode   = dictionary["Passcode"] as! String
      
      savePasscode(passcode: passcode)
      
      return User(name: name, phone: phone, email: email, biometrics: biometrics)
   }
   
   
   private static func savePasscode(passcode: String)
   {
      let hashedPasscode = getHashedPasscode(passcode: passcode)
      KeychainService.savePassword(hashedPasscode)
   }
   
   private static func getHashedPasscode(passcode: String) -> String?
   {
      let salt     = BCryptSwift.generateSalt()
      let passHash = BCryptSwift.hashPassword(passcode, withSalt: salt)
      return passHash
   }
   
   static func saveUser(user: User)
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
      let biometrics = UserDefaults.standard.string(forKey: "Biometrics")
      
      return User(name: name, phone: phone, email: email, biometrics: (biometrics != nil))
   }
   
   private static func generateKey(user: User) -> SecKey?
   {
      if(user == nil)
      {
         return nil
      }
      let tag                       = "\(user.name).\(user.email).\(user.phone)".data(using: .utf8)!
      let type                      = kSecAttrKeyTypeECSECPrimeRandom
      var error:      Unmanaged<CFError>?
      let access                    =
              SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                              kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                              .biometryAny,
                                              &error)!
      let attributes: [String: Any] =
              [
                 kSecAttrKeyType as String: type,
                 kSecAttrKeySizeInBits as String: 256,
                 kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
                 kSecPrivateKeyAttrs as String:
                 [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: tag,
                    kSecAttrAccessControl as String: access
                 ]
              ]
      
      
      guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
      else
      {
         print(error!.takeRetainedValue())
         exit(-1)
      }
      
      return SecKeyCopyPublicKey(privateKey)
   }
}
