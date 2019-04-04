//
// Created by Grantley on 2019-04-04.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import Security

class Key
{
   private var publicKey: SecKey? = nil
   
   static func setupKeys(_ user: User)
   {
      print("Generating key")
      let publicKey = generateKey(user)
      print("Key Generated")
      self.sendKeyToServer(publicKey)
   }
   
   private class func sendKeyToServer(_ publicKey: SecKey?)
   {
      //Code to Send Key to server
   }
   
   static func generateKey(_ user: User) -> SecKey?
   {
      let tag                       = "\(user.name).\(user.phone).\(user.email)".data(using: .utf8)!
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