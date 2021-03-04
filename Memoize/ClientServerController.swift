//
// Created by Grantley on 2019-05-31.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import OAuthSwift
import CommonCrypto
import CryptoKit

typealias ServiceResponse = (NSDictionary?, Error?) -> Void

@available(iOS 13.0, *)
extension Digest
{
   var bytes: [UInt8]
   {Array(makeIterator())}
   var data:  Data
   {Data(bytes)}
   
   var hexString: String
   {
      bytes.map {String(format: "%02x", $0)}.joined()
   }
}


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
      let headers         = ["Accept": "application/json", "Authorization": "Bearer \(token.getToken())", "Content-Type": "application/json; charset=utf-8"]
      let newUser: [String: Any]
                          = ["name": user.name!, "email": user.email!, "phone": user.phone!, "public_key": user.userKey.convertPublicKeyForExport()!]
      print(headers)
      token.OAUTH.client.post(
              server, parameters: newUser,
              headers: headers,
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
   
   @available(iOS 13.0, *)
   func requestLogin(_ user: User?, _ randomID: String, _ onCompletion: @escaping ServiceResponse)
   {
      let server  = serverAddress + "api/login"
      let encoder = JSONEncoder()
      guard let payloadJson = try? encoder.encode(["user_id": "\(user!.userID)", "random_id": randomID])
      else
      {
         onCompletion(nil, NSError())
         print("Failed creating data")
         return
      }
      //print("Created data as \(String(data: payloadJson, encoding: .utf8))")
      let hash = SHA512.hash(data: payloadJson)
      print("Hash: \(hash)")
      print("Hash as hex \(hash.hexString)")
      guard let signature = signData(payload: payloadJson, key: (user?.userKey.privateKey)!)
      else
      {
         print("Could not sign data payload")
         onCompletion(nil, NSError())
         return
      }
      let params = Payload(
              payload_hash: hash.hexString,
              payload_json: payloadJson,
              signatures: ["user": [
                 "signature": signature.base64EncodedString(),
                 "type": "ecdsa-sha512"
              ]]
      )
      
      let encoding = try? encoder.encode(params).base64EncodedString()
      let payload  = ["payload": encoding]
      
      let headers = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8"]
      token.OAUTH.client.post(
              server, parameters: payload, headers: headers, success: {response in
         print(response.data)
         onCompletion([:], nil)
      }, failure: {error in print("Error when requesting login"); onCompletion(nil, error)}
      )
   }
   
   private func signData(payload: Data, key: SecKey) -> Data?
   {
      var error: Unmanaged<CFError>?
      guard let signature = SecKeyCreateSignature(key,
                                                  SecKeyAlgorithm.ecdsaSignatureMessageX962SHA512,
                                                  payload as CFData, &error)
      else
      {
         print("Signing payload failed with \(error)")
         return nil
      }
      print("Created signature as \(signature)")
      return signature as Data
   }
   
   private func sha512Hash(data: inout Data) -> String
   {
      let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA512_DIGEST_LENGTH))
      var thing  = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
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
