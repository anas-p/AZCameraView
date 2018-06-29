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








