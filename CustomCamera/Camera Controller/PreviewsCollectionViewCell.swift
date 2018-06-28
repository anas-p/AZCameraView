//
//  PreviewsCollectionViewCell.swift
//  CustomCamera
//
//  Created by 🅐🅝🅐🅢 on 28/06/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//  GitHub: https://github.com/anasamanp/AZCameraView

import UIKit

class PreviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func setImage(image:UIImage, selectedIndex: Bool){
        self.imgView.image = image
        if selectedIndex{
            self.layer.borderColor = UIColor.red.cgColor
        }
        else{
            self.layer.borderColor = UIColor.white.cgColor
        }
    }
    
}
