//
//  AnnotatedPhotoCell.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class MemeCell: BaseCell {
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                setupViews()
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        //iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func colorFlag(flag:Int){
        if flag == 0{
            self.imageView.backgroundColor = .green
        }else if flag == 1{
            self.imageView.backgroundColor = UIColor.rgb(103, green: 255, blue: 255)
        }else{
            self.imageView.backgroundColor = UIColor.rgb(255, green: 102, blue: 255)
        }
    }
    
    
    var imageViewHeightLayoutConstraint: NSLayoutConstraint?
    var imageViewWidthLayoutConstraint: NSLayoutConstraint?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint?.constant = attributes.photoHeight
        }
    }
    
    override func setupViews() {
        super.setupViews()
        if photo != nil{
            imageView.image = photo?.image
            addSubview(imageView)
            
            imageViewHeightLayoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
            addConstraint(imageViewHeightLayoutConstraint!)
            imageViewWidthLayoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
            addConstraint(imageViewWidthLayoutConstraint!)
            
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)
        }
    }
}
