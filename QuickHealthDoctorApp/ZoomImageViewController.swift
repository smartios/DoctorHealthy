//
//  ZoomImageViewController.swift
//  CrowBar
//
//  Created by SS-184 on 18/04/17.
//  Copyright © 2017 SS114. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet var imageCollectionView: UICollectionView!
    var imageArray = NSMutableArray()
  
       override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        imageCollectionView.backgroundColor = UIColor.clear
        
         imageCollectionView.register(UINib(nibName: "ZoomCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "imgCell")
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedToDismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func tappedToDismissView(_ sender: AnyObject)
    {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionView Datasource/Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      Bundle.main.loadNibNamed("ZoomCollectionViewCell", owner: self, options: nil)
        
        
        var cell:UICollectionViewCell!
        
       cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath)
        
        let scroll = cell.viewWithTag(1) as! UIScrollView
        scroll.delegate = self
        scroll.minimumZoomScale = 1.0
        scroll.zoomScale = 1.0
        scroll.maximumZoomScale = 2.0
        let image = cell.viewWithTag(2) as! UIImageView
        if let imageUrl = imageArray.object(at: indexPath.row) as? String
        {
            let url = NSURL(string: imageUrl)
            image.setImageWith(url as! URL, placeholderImage: nil)
        }else if let imageData = imageArray.object(at: indexPath.row) as? Data
        {
            image.image = UIImage(data: imageData)
        }
        image.contentMode = .scaleAspectFit
        return cell
    }
    // MARK: UIScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    
    
    
}
