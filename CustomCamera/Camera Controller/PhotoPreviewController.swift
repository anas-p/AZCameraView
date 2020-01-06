//
//  PhotoPreviewController.swift
//  CustomCamera
//
//  Created by 🅐🅝🅐🅢 on 28/06/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//  GitHub: https://github.com/anasamanp/AZCameraView

import UIKit

protocol PhotoPreviewControllerDelegate {
    func deletedPhotoIndex(index:Int)
    func addPhotosOnClick()
}


class PhotoPreviewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnRotate: UIButton!

    
    // MARK: - Variables
    var delegate : PhotoPreviewControllerDelegate?
    var previewPhotos = [UIImage]()
    var selectedIndex = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDelete.isHidden = previewPhotos.count == 1 ? true : false
        self.imgView.image = previewPhotos[selectedIndex]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnPhoto.layer.cornerRadius = self.btnPhoto.bounds.width/2
        self.btnAdd.layer.cornerRadius = btnAdd.bounds.width/2
    }
    
    
    // MARK: - Actions & Targets
    @IBAction func btnPhotoOnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseOnClick(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteOnClick(_ sender: UIButton) {
        self.previewPhotos.remove(at: selectedIndex)
        self.delegate?.deletedPhotoIndex(index: selectedIndex)
        if selectedIndex > self.previewPhotos.count - 1 {
            self.selectedIndex = 0
        }
        self.imgView.image = self.previewPhotos[selectedIndex]
        self.collectionView.reloadData()
        self.btnDelete.isHidden = previewPhotos.count == 1 ? true : false
    }
    
    @IBAction func btnAddOnClick(_ sender: UIButton) {
        delegate?.addPhotosOnClick()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRotateOnClick(_ sender: UIButton) {
        let image = previewPhotos[self.selectedIndex]
        guard let newImage = image.rotate(radians: .pi/2) else { return }
        self.previewPhotos.remove(at: self.selectedIndex)
        self.previewPhotos.insert(newImage, at: self.selectedIndex)
        self.collectionView.reloadData()
        self.imgView.image = previewPhotos[self.selectedIndex]
    }
    
}

// MARK: - CollectionView DataSource
extension PhotoPreviewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.previewPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var previewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewsCollectionViewCell", for: indexPath) as? PreviewsCollectionViewCell
        
        if previewCell == nil {
            collectionView.register(UINib(nibName:"PreviewsCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "PreviewsCollectionViewCell")
            previewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewsCollectionViewCell", for: indexPath) as? PreviewsCollectionViewCell
        }
        let isSelected = self.selectedIndex == indexPath.row ? true : false
        previewCell?.setImage(image: self.previewPhotos[indexPath.row], selectedIndex: isSelected)
        return previewCell!
    }
    
}

// MARK: - CollectionView Delegate
extension PhotoPreviewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.imgView.image = previewPhotos[indexPath.row]
        self.collectionView.reloadData()
    }
}

extension UIImage {
    /**
     Rotate UIImage
     - Parameter radians: .pi is 180 deg, .pi/2 is 90 deg, .pi/4 is 45 deg, ..., .pi/180 is 1 deg.
     */
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}








