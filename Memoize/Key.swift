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
        let address = getServerAddress()
        if let digestibleKey = convertKey(publicKey)
        {
            
        }
    }
    
    private class func convertKey(_ key: SecKey?) -> String?
    {
        let keyData = SecKeyCopyExternalRepresentation(key!, nil)! as Data
        let keyType       = kSecAttrKeyTypeECSECPrimeRandom
        let keySize       = 256
        let exportManager = CryptoExportImportManager()
        if let exportablePEMKey = exportManager.exportPublicKeyToPEM(keyData, keyType: keyType as String, keySize: keySize)
        {
            return exportablePEMKey
        }
        
        return nil
    }
    
    private static func getServerAddress() -> String
    {
        let infoPlist = Bundle.main.infoDictionary
        let address   = infoPlist!["ServerAddress"] as! String
        return address
    }
    
    static func generateKey(_ user: User) -> SecKey?
    {
        let tag                       = "\(user.name).\(user.phone).\(user.email).key".data(using: .utf8)!
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
