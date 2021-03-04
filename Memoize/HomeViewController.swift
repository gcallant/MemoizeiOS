//
// Created by Grant on 2019-02-26.
// Copyright (c) 2019 grantcallant.com All rights reserved.
// QR Scanning code by Paul Hudson
// See https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
// Also https://www.andrewcbancroft.com/2018/02/24/swift-cheat-sheet-for-iphone-camera-access-usage/
//

import Foundation
import UIKit
import AVFoundation

@available(iOS 13.0, *)
class HomeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
   private var captureSession: AVCaptureSession!
   private var previewLayer:   AVCaptureVideoPreviewLayer!
   private var user = User.loadUser()
   private static let qrCodeError = "Error: No Random Data Available"
   
   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection)
   {
      if let metadataObject = metadataObjects.first
      {
         guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject
         else
         {return}
         guard let stringValue = readableObject.stringValue
         else
         {return}
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
         processCode(stringValue)
      }
   }
   
   @IBOutlet weak var cameraBox: UIImageView!
   
   private func processCode(_ data: String)
   {
      if(data != HomeViewController.qrCodeError)
      {
         captureSession.stopRunning()
         let server = ClientServerController()
         server.requestLogin(user, data)
         {
            (success, error) in
            if(success != nil)
            {
               print("Hooray! It worked")
            }
            else
            {
               //
            }
         }
         
      }
      else
      {
         showWrongServerAlert()
      }
   }
   
   private func trimString(_ stringToTrim: String) -> String
   {
      return stringToTrim.filter{!$0.isNewline && !$0.isWhitespace}
   }
   
   private func showWrongServerAlert()
   {
      let alert = UIAlertController(title: "Error capturing code",
                                    message: "Sorry, this is not a valid code, please reload the page and try again.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
   }
   
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask
   {return .portrait}
   
   override func viewWillDisappear(_ animated: Bool)
   {
      super.viewWillDisappear(animated)
      
      if(captureSession != nil && captureSession.isRunning)
      {
         captureSession.stopRunning()
      }
   }
   
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      checkCameraAuthorization()
   }
   
   private func checkCameraAuthorization()
   {
      let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
      
      switch authorizationStatus
      {
         case .notDetermined: requestCameraPermission()
         case .authorized: presentCamera()
         case .restricted, .denied: alertCameraAccessRequired()
      }
   }
   
   override func viewWillAppear(_ animated: Bool)
   {
      super.viewWillAppear(animated)
      
      if(captureSession != nil && !captureSession.isRunning)
      {
         captureSession.startRunning()
      }
   }
   
   private func alertCameraAccessRequired()
   {
      let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!)!
      
      
      let alert = UIAlertController(title: "Need Camera Access", message: "Camera is required to allow 2FA login",
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Cancel", style: .default))
      alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler:
      {
         (alert) -> Void in
         UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
      }))
      DispatchQueue.main.async
      {self.present(alert, animated: true)}
   }
   
   private func presentCamera()
   {
      view.backgroundColor = .black
      captureSession = AVCaptureSession()
      
      guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
      else
      {return}
      let videoInput: AVCaptureDeviceInput
      
      do
      {
         videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
      }
      catch
      {
         return
      }
      
      if(captureSession.canAddInput(videoInput))
      {
         captureSession.addInput(videoInput)
      }
      else
      {
         deviceFailedAlert()
         return
      }
      
      let metadataOuput = AVCaptureMetadataOutput()
      
      if(captureSession.canAddOutput(metadataOuput))
      {
         captureSession.addOutput(metadataOuput)
         metadataOuput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
         metadataOuput.metadataObjectTypes = [.qr]
      }
      else
      {
         deviceFailedAlert()
         return
      }
      
      previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      previewLayer.frame = view.layer.bounds
      previewLayer.videoGravity = .resizeAspectFill
      view.layer.addSublayer(previewLayer)
      
      captureSession.startRunning()
   }
   
   private func deviceFailedAlert()
   {
      let alert = UIAlertController(title: "QR Login Failed", message: "You device does not support " +
                                                                       "scanning QR codes, or camera is not functioning. Please try again, or have device checked.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
      captureSession = nil
   }
   
   private func requestCameraPermission()
   {
      AVCaptureDevice.requestAccess(for: .video, completionHandler:
      {
         accessGranted in
         guard accessGranted == true
         else
         {return}
         self.presentCamera()
      })
   }
}
