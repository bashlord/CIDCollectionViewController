//
//  CIDLayout.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//
// Modified version of UICollectionView Custom Layout Tutorial CID
// Changed so CollectionView could be done programmatically rather than through Storyboard
import UIKit
protocol CIDLayoutDelegate {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth:CGFloat) -> CGFloat
}

class CIDLayoutAttributes:UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var photoHeight: CGFloat = 0.0
    
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! CIDLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? CIDLayoutAttributes {
            if( attributtes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class CIDLayout: UICollectionViewFlowLayout {
    //1. CID Layout Delegate
    var delegate:CIDLayoutDelegate!
    
    //2. Configurable properties
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [CIDLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight:CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    func clearCache(){
        cache.removeAll()
        // Important to reset the height as well to allow a recalculation of the content height
        //  when calculating the heights of all the collectionView elements
        contentHeight = 0.0
    }
    
    func getCol() -> Int{
        return numberOfColumns
    }
    
    func setCol(i: Int){
        numberOfColumns = i
    }
    
    func incCol(){
        numberOfColumns+=1
    }
    
    func decCol(){
        if numberOfColumns > 0{
            numberOfColumns-=1
        }
    }
    
    override class var layoutAttributesClass : AnyClass {
        return CIDLayoutAttributes.self
    }
    
    override func prepare() {
        // 1. Only calculate once
        if cache.isEmpty && delegate != nil{
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // 3. Iterates through the list of items in the first section
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                let width = columnWidth - cellPadding*2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                let height = cellPadding +  photoHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                let attributes = CIDLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6. Updates the collection view content height
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                //column += 1
                if column >= (numberOfColumns - 1){
                    column = 0
                }else{
                    column += 1
                }
            }
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
