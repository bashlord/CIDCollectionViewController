//
//  Photo.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit
import CoreFoundation
class Photo {
    
    //let memeURLS = CFArray()
    class func allPhotos(flag:Int) -> [Photo] {
        var fstr: String = ""
        if flag == 1{
            fstr = "Photos1"
        }else if flag == 2{
            fstr = "Photos2"
        }else{
            fstr = "Photos0"
        }
        
        var photos = [Photo]()
        if let URL = Bundle.main.url(forResource: fstr, withExtension: "plist") {
            if let photosFromPlist = NSArray(contentsOf: URL) {
                for dictionary in photosFromPlist {
                    let photo = Photo(dictionary: dictionary as! NSDictionary)
                    photos.append(photo)
                }
            }
        }
        return photos
    }
    
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(image: image!)
    }
    
    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: "").boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
