//
// Created by Grantley on 2019-04-04.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import Security

class Key
{
   var publicKey:  SecKey? = nil
   var privateKey: SecKey? = nil
   
   init(_ tag: Data)
   {
      privateKey = getPrivateKey(tag)
      guard privateKey != nil else
      {
         print("Key not found, generating new one")
         generateKey(tag)
         return
      }
      print("Key found, retrieving public")
      publicKey = getPublicKey(privateKey!)
      print("Public key found")
   }
   
   public func getPrivateKey(_ tag: Data) -> SecKey?
   {
      let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                     kSecAttrApplicationTag as String: tag,
                                     kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                     kSecReturnRef as String: true]
      
      var item: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &item)
      guard status == errSecSuccess else {print("Couldn't retrieve private key \(tag)");return nil}
      return item as! SecKey
   }
   
   public func getPublicKey(_ privateKey: SecKey) -> SecKey?
   {
      guard let key = SecKeyCopyPublicKey(privateKey) else {print("Couldn't retrieve public key");return nil}
      return key
   }
   
   public func convertKeyForExport(_ key: SecKey?) -> String?
   {
      let keyData       = SecKeyCopyExternalRepresentation(key!, nil)! as Data
      let keyType       = kSecAttrKeyTypeECSECPrimeRandom
      let keySize       = 256
      let exportManager = CryptoExportImportManager()
      if let exportablePEMKey = exportManager.exportPublicKeyToPEM(keyData, keyType: keyType as String,
                                                                   keySize: keySize)
      {
         return exportablePEMKey
      }
      
      return nil
   }
   
   /**
   Generates private key, and uses it to generate public key
   References to both are assigned to data members
   
   - parameter userTag: A unique tag to identify the key, see User.tag
   */
   private func generateKey(_ userTag: Data)
   {
      let tag                       = userTag
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
      
      self.privateKey = privateKey
      self.publicKey = SecKeyCopyPublicKey(privateKey)
   }
}
