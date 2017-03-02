//
//  MainController.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/7/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import AVFoundation
import UIKit


class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    let cellId = "cellId"
    let titles = ["Create", "Made", "Favorites"]
    var cid: CIDCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Dank."
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        let button0 = UIBarButtonItem(title: "Col--", style: .done, target: self, action: #selector(reduceColumn))
        let button1 = UIBarButtonItem(title: "++Col", style: .done, target: self, action: #selector(increaseColumn))
        let button2 = UIBarButtonItem(title: "Page--", style: .done, target: self, action: #selector(removePage))
        let button3 = UIBarButtonItem(title: "++Page", style: .done, target: self, action: #selector(addPage))
        let button4 = UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(prevPage))
        let button5 = UIBarButtonItem(title: ">", style: .done, target: self, action: #selector(nextPage))

        button0.tintColor = UIColor.white
        button1.tintColor = UIColor.white
        button2.tintColor = UIColor.white
        button3.tintColor = UIColor.white
        button4.tintColor = UIColor.white
        button5.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [button1, button0, button3, button2,button5, button4]
        setupCollectionView()
    }
    
    func nextPage(){
        (cid?.nextPage())
    }

    func prevPage(){
        (cid?.prevPage())
    }
    
    func reduceColumn(){
        cid?.decCol()
    }
    
    func increaseColumn(){
        cid?.incCol()
    }
    
    func removePage(){
        let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0))
        if cell != nil{
            ((cell as! CIDCollectionView).decrementPages())
            
            //((cell as! CIDCollectionView).collectionView.collectionViewLayout as! CIDLayout).
        }
    }
    
    func addPage(){
        let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0))
        if cell != nil{
            (cid?.incrementPages())
            
            //((cell as! CIDCollectionView).collectionView.collectionViewLayout as! CIDLayout).
        }
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CIDCollectionView.self, forCellWithReuseIdentifier: cellId)
        collectionView?.isPagingEnabled = true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String = cellId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CIDCollectionView
        cell.prepPhotos(flag: -1)
        if cid == nil{
            cid = cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sizeForItemAt/width/height ", indexPath, view.frame.width, view.frame.height)
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}


