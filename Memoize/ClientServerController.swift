//
// Created by Grantley on 2019-05-31.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import OAuthSwift
import CommonCrypto

typealias ServiceResponse = (NSDictionary?, Error?) -> Void

class ClientServerController
{
   private var serverAddress: String
   private var token:         Token
   
   init()
   {
      let infoPlist = Bundle.main.infoDictionary
      let address   = infoPlist!["ServerAddress"] as! String
      serverAddress = address
      print("Got server address as \(address)")
      token = Token(serverAddress)
   }
   
   func uploadUserToServer(_ user: User, _ onCompletion: @escaping ServiceResponse) -> Void
   {
      let server:  String = serverAddress + "api/user"
      let newUser: [String: Any]
                          = ["name": user.name!, "email": user.email!, "phone": user.phone!, "public_key": user.userKey.convertPublicKeyForExport()!]
      token.OAUTH.client.post(
              server, parameters: newUser,
              headers: ["Accept": "application/json", "Authorization": "Bearer \(token.getToken())", "Content-Type": "application/json; charset=utf-8"],
              success: {response in
                 let jsonDict = try? response.jsonObject() as! [String: AnyObject]
                 print(jsonDict)
                 let userID = jsonDict?["id"] as! Int
                 user.userID = userID
                 print("UserID is \(userID)")
                 onCompletion([:], nil)
              },
              failure: {error in
                 print("Error in creating user \(error)")
                 onCompletion(nil, error)
              }
      )
   }
   
   func requestLogin(_ user: User?, _ sessionID: String, _ onCompletion: @escaping ServiceResponse)
   {
      let server = serverAddress + "api/login"
      guard var data = (user!.userID.description + sessionID).data(using: .utf8)
      else
      {
         onCompletion(nil, NSError())
         print("Failed creating data")
         return
      }
      print("Created data as \(data)")
      let payload                 = sha512Hash(data: &data)
      guard let signature               = signData(payload: payload, key: (user?.userKey.privateKey)!) else
      {
         print("Could not sign data payload")
         onCompletion(nil, NSError())
         return
      }
      let userData: [String: Any] = ["user_id": "\(user!.userID)", "payload": payload, "signature": String(decoding: signature as! Data, as: UTF8.self)]
      let headers                 = ["Accept": "application/json", "Authorization": "Bearer \(token.getToken())", "Content-Type": "application/json; charset=utf-8"]
      token.OAUTH.client.post(
              server, parameters: userData, headers: headers, success: {response in
            onCompletion([:], nil)
      }, failure: {error in print("Error when requesting login"); onCompletion(nil, error)}
      )
   }
   
   private func signData(payload: String, key: SecKey) -> CFData?
   {
      
      var error: Unmanaged<CFError>?
      guard let cfData = CFDataCreate(kCFAllocatorDefault, payload, payload.count) else
      {
         print("Could not create CFdata")
         return nil
      }
      print("Created CFdata object as \(cfData)")
      guard let signature               = SecKeyCreateSignature(key,
                                                          SecKeyAlgorithm.ecdsaSignatureMessageX962SHA512,
                                                          payload.data(using: .utf8) as! CFData, &error) else
      {
         print("Signing payload failed with \(error)")
         return nil
      }
      print("Created signature as \(signature)")
      return signature
   }
   
   private func sha512Hash(data: inout Data) -> String
   {
      var buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA512_DIGEST_LENGTH))
      var thing = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
      buffer.initialize(to: 0)
      CC_SHA512(&data, CC_LONG(data.count), &thing)
      let payload = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
      for byte in thing
      {
         payload.appendFormat("%02x", byte)
      }
      print("Hashed payload as \(payload)")
      buffer.deinitialize(count: 1)
      buffer.deallocate()
      return payload as String
   }
}