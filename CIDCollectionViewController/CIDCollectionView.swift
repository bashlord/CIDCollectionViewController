//
//  CIDCollectionView.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import AVFoundation
import UIKit

class CIDCollectionView: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var photos = [Photo]()
    var flag: Int!
    var layouts = [CIDLayout]()
    // Number of pages.  Required when determining the number of elements per page, as well as 
    //  determining the offset for each item
    var numOfPages = 1
    // Index of the current page.  Essential when there are multiple pages for determining the item
    //  for indexPath + offset depending on the page index (see collectionView delegate functions)
    var currPage = 0
    let cellId = "MemeCell"
    
    lazy var collectionView: UICollectionView = {
        self.layouts.append(CIDLayout())
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.layouts[0])
        cv.backgroundColor = UIColor.rgb(224, green: 224, blue: 224)
        cv.dataSource = self
        cv.delegate = self
        self.layouts[0].delegate = self
        return cv
    }()
    
    func prepPhotos(flag: Int){
        // Retrieves images from Photos.xcassets by iterating through Photos.plist (which contains the pathnames of the images)
        //  The flag just acts as a switch case. (See Photo.swift)
        photos = Photo.allPhotos(flag: flag)
        self.flag = flag
    }
    
    func incrementPages(){
        // Does a recalculation of all the layouts/collectionViews with the new offset
        // itemsPerPage = numOfPhotos/numOfPages
        //  item's indexPath.item = indexPath.item+(itemsPerPage*currentPageIndex)
        
        // Increment number of pages
        numOfPages+=1
        // Set the current page to the last page
        currPage = numOfPages-1
        // Add a new CIDLayout, and set its column count to the current column count and append it to the array of layouts
        let l = CIDLayout()
        l.setCol(i: layouts[0].getCol())
        layouts.append(l)
        // clear all layout caches in order to recalculate layout params
        clearCaches()
        for i in (0...numOfPages-1).reversed(){
            self.collectionView.collectionViewLayout = layouts[i]
            self.collectionView.reloadData()
            (self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
            currPage-=1
        }
        // Set the current page index back to 0 (since the for loop will set it to -1)
        currPage = 0
    }
    
    func decrementPages(){
        // Same logic of incrementPages(), but decrements
        // Does a recalculation of all the layouts/collectionViews with the new offset
        // itemsPerPage = numOfPhotos/numOfPages
        //  item's indexPath.item = indexPath.item+(itemsPerPage*currentPageIndex)
        if numOfPages > 1{
            // empty layout param caches
            numOfPages-=1
            currPage = numOfPages-1
            collectionView.collectionViewLayout = layouts[currPage]
            self.layouts.popLast()
            clearCaches()

            for i in (0...numOfPages-1).reversed(){
                print(i)
                self.collectionView.collectionViewLayout = layouts[i]
                self.collectionView.reloadData()
                (self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
                
                currPage -= 1
            }
            currPage = 0
        }
    }
    
    func clearCaches(){
        // Simply clears the caches of all the layouts in the array
        for l in layouts{
            l.clearCache()
        }
    }
    
    func nextPage(){
        // Goes to the next page possible
        if currPage < numOfPages-1{
            currPage += 1
            collectionView.collectionViewLayout = layouts[currPage]
            collectionView.reloadData()
        }
    }
    
    func prevPage(){
        // Goes to the previous page possible
        if currPage > 0{
            currPage -= 1
            collectionView.collectionViewLayout = layouts[currPage]
            collectionView.reloadData()
        }
    }
    
    func incCol(){
        columnsCaches(flag: 0)
    }
    
    func decCol(){
        columnsCaches(flag: 1)
    }
    
    func columnsCaches(flag: Int){
        if flag == 0{// increment column count in all layouts
            for l in layouts{
                l.incCol()
            }
        }else if (layouts[0].getCol()) > 1{// decrement
            for l in layouts{
                l.decCol()
            }
        }
        // no need to repeat the code, but still need to make sure layouts are recalculated
        //  when they need to be (for example, if column count is 1, do not waste time 
        //  recalculating the layouts again)
        if flag == 0 || (flag == 1 && (layouts[0].getCol()) > 0){
            // set currPage in order to match the delegate
            currPage = numOfPages-1
            clearCaches()
            for i in (0...numOfPages-1).reversed(){
                self.collectionView.collectionViewLayout = layouts[i]
                self.collectionView.reloadData()
                (self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
                currPage-=1
            }
            currPage = 0
        }
        
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(MemeCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Depending on he number of pages, and the photo count (which is 30), calculate the number
        //  of elements per page depending on the current page.  If the photo count is not wholly divisible 
        //  by the number of pages, calculate the difference once at the last page
        if photos.count%numOfPages == 0{
            return photos.count/numOfPages
        }else{
            let rounded = Int(ceil(Double(photos.count/numOfPages)))
            if (1+currPage)*rounded > photos.count{
                return (1+currPage)*rounded - photos.count
            }else{
                return rounded
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCell
        let rounded = Int(ceil(Double(photos.count/numOfPages)))
        cell.photo = photos[(rounded*currPage)+indexPath.item]
        return cell
    }
    
}

extension CIDCollectionView : CIDLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        let rounded = Int(ceil(Double(photos.count/numOfPages)))
        let photo = photos[(rounded*currPage)+indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        return rect.size.height
    }
}
