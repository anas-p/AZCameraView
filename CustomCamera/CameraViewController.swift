//
//  CameraViewController.swift
//  CustomCamera
//
//  Created by 🅐🅝🅐🅢 on 24/06/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnFlashToggle: UIButton!
    @IBOutlet weak var btnCount: UIButton!
    @IBOutlet weak var lblMaxAlert: UILabel!
    
    // MARK: - Variables
    let cameraController = CameraController()
    var photos = [UIImage]()
    
    var widthConstraint = NSLayoutConstraint()
    var rightConstraint = NSLayoutConstraint()
    
    // MARK: - View Lifecycle
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideOrShowPreview()
        configureCameraController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func orientationChanged(notification:Notification){
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            self.setFramesForLandscape(with: CGFloat.pi/2)
        case .landscapeRight:
            self.setFramesForLandscape(with: -(CGFloat.pi/2))
        case .faceUp:
            self.setFramesForPortrait()
        default:
            self.setFramesForPortrait()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIDeviceOrientationDidChange)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnCapture.layer.cornerRadius = btnCapture.bounds.width/2
        btnCapture.layer.borderColor = UIColor.white.cgColor
        btnCapture.layer.borderWidth = 3
        photoPreview.layer.borderWidth = 0.5
        photoPreview.layer.borderColor = UIColor.white.cgColor
        photoPreview.layer.cornerRadius = 5
        btnAdd.layer.cornerRadius = btnAdd.bounds.width/2
        btnCount.layer.cornerRadius = btnCount.bounds.width/2
        lblMaxAlert.layer.cornerRadius = 3
    }
    
    func setFramesForPortrait(){
        UIView.animate(withDuration: 0.3) {
            self.btnCapture.transform = CGAffineTransform(rotationAngle: 0)
            self.btnFlashToggle.transform = CGAffineTransform(rotationAngle: 0)
            self.btnAdd.transform = CGAffineTransform(rotationAngle: 0)
            self.photoPreview.transform = CGAffineTransform(rotationAngle: 0)
            self.btnCount.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    func setFramesForLandscape(with angle: CGFloat){
        UIView.animate(withDuration: 0.3) {
            self.btnCapture.transform = CGAffineTransform(rotationAngle: angle)
            self.btnFlashToggle.transform = CGAffineTransform(rotationAngle: angle)
            self.btnAdd.transform = CGAffineTransform(rotationAngle: angle)
            self.photoPreview.transform = CGAffineTransform(rotationAngle: angle)
            self.btnCount.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    // MARK: - Actions
    @IBAction func btnCaptureOnClick(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            self.photos.append(image)
            self.hideOrShowPreview()
            
            //Save photos to library
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
    @IBAction func btnAddOnClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCloseOnClick(_ sender: UIButton) {
    }
    
    @IBAction func btnFlashToggleOnClick(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            btnFlashToggle.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
        else {
            cameraController.flashMode = .on
            btnFlashToggle.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    // MARK: - Helper Methods
    func hideOrShowPreview(){
        if photos.count == 5{
            btnCapture.isUserInteractionEnabled = false
            btnCapture.alpha = 0.5
            lblMaxAlert.isHidden = false
        }
        else{
            btnCapture.isUserInteractionEnabled = true
            btnCapture.alpha = 1
            lblMaxAlert.isHidden = true
        }
        if photos.count > 0{
            self.btnCount.isHidden = false
            self.photoPreview.isHidden = false
            self.photoPreview.image = self.photos.last
            self.btnCount.setTitle("\(self.photos.count)", for: .normal)
        }
        else{
            self.btnCount.isHidden = true
            self.photoPreview.isHidden = true
        }
    }
    
    // MARK: - Cofigure camera
    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
    
    
}

