//
// Created by Grantley on 2019-07-13.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import OAuthSwift

class Token
{
   private var tokenString: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMGFjOGQ3ZTE0YzMwNTRiNjE3OTU5YTZhYTFlOGE1NDNjYzM2YjliZjYzNmE2OWIxNjdhMjgzNWRiOTVmMWQzNDkyMmJhY2RiZGJiZDAzMzYiLCJpYXQiOjE2MTQxODE4ODgsIm5iZiI6MTYxNDE4MTg4OCwiZXhwIjoxNjE0Nzg2Njg4LCJzdWIiOiIiLCJzY29wZXMiOlsiY3JlYXRlLXVzZXJzIl19.q435XBipM1wXxoiN3u-tdzKowag8mzs5d4IuK23Crhp99fL6HjlVlgzRtWw4wbAU8gQO6R2ysEtahZT4P4QeSLDryUF7JRd5kkOpIICqYvvBs8CeN5tSbr-G3hXNhzc-aINIdLECMqiJhUMgcNJ99jLDxqBE7BBPZeVcuBrPGlsZIjJvSg0jfprEO4eg4ixqDNBwJvFhSq2Hn4yuFS1j6pqiM03Lv4U9vSYaKgAtu2UXfV-R0VZID7DfFJdvr2od0d6wcvMJgeJp0cgRj0KV5VS198oNdD2e-cQf9LEZQZFhG4goUvC2DxDvy11ltG50rrocT_GDL46yHaROGjRl7XSxfOjReoly9bsmRl5Jzbea254gL2okxr6Z-LQRVhLbmrEsAyTn-GfD1xSj3dG9paKzp-G1jWAPffpPbldwDUnZfswlK9tpC26vNif-nzjkItA9MRawrKK6tgoX71cX8UaWiERqc50pXPm_9R-3si9UoDuf0Bods6LiHVis4jsctmLae3UM3yOzNi_LI-uxFMIYf8djsVQbx1Bhks_13J5qY9KFtnXEik3Ult-TiMDl41hRD4BkOLhmggcWoaDQ9jkLWlW8m6dScMDRMQFI-8FL-L0zLHL3Wv3n0-PNLmE5yneQ86_xoRrVBCGKkDdd58TFVZu05F2O2a-RkVB-JMk"
   private let account = "MemoizeToken"
   let OAUTH:       OAuth2Swift
   
   init(_ serverAddress: String)
   {
      let tokenUrl = serverAddress + "oauth/token"
      OAUTH = OAuth2Swift(
              consumerKey: "",
              consumerSecret: "",
              authorizeUrl: "",
              accessTokenUrl: tokenUrl,
              responseType: "token"
      )
      print("Got token address as \(tokenUrl)")
      //tokenString = getToken()
      guard !tokenString.isEmpty else
      {
         print("No token found, fetching a new one")
         //fetchToken(serverAddress)
         return
      }
   }
   
   /**
   Facade using the Passcode wrapper to load the token from the keychain, if it is available
   Returns an empty string if a token with the account tag is not found,
   */
   public func getToken() -> String
   {
      print("getting token")
      guard !tokenString.isEmpty else
      {
         return Passcode.loadPasscode(account)
      }
      print("token retrieved is: \(tokenString)")
      return tokenString
   }
   
   private func fetchToken(_ serverAddress: String)
   {
      print("Attempting to get app token")
   
      OAUTH.authorize(deviceToken: "Memoize", grantType: "client_credentials",
                                        success: {credential, response, parameters in
                                           print("Got credentials ")
                                           self.tokenString = credential.oauthToken
                                           print(credential.oauthToken)
                                           self.saveToken()
                                        },
                                        failure: {error in print("error in getting token \(error)")})
   }
   
   /**
   Facade using the Passcode wrapper to save the token into the keychain
   */
   func saveToken()
   {
      print("Saving token")
      Passcode.saveToken(tokenString, account)
   }
}
