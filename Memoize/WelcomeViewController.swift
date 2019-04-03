//
// Created by Grantley on 2019-02-26.
// Copyright (c) 2019 grantcallant. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController
{
   @IBOutlet var viewTap: UIView!
   var           tapGesture = UITapGestureRecognizer()
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      viewTap.addGestureRecognizer(tapGesture)
      viewTap.isUserInteractionEnabled = true
   }
   
   @objc func handleTapGesture(_ sender: UITapGestureRecognizer)
   {
      let mainStoryboard:       UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let signupViewController: SignupView   = mainStoryboard.instantiateViewController(
              withIdentifier: "SignupView") as! SignupView
      self.present(signupViewController, animated: true)
   }
}
