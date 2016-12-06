//
//  BigImgViewController.swift
//  PickerImg
//
//  Created by sqluo on 2016/12/6.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BigImgViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{

    
    fileprivate var imgArray = [UIImage]()
    fileprivate var index = 0
    
    
    init(imgArray: [UIImage], index: Int){
        super.init(nibName: nil, bundle: nil)
        
        self.imgArray = imgArray
        
        self.index = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //layout
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let h: CGFloat = self.view.frame.width
        layout.itemSize = CGSize(width: h, height: h)
        
        layout.minimumLineSpacing = 0  //上下间隔
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        
        return layout
    }()
    //id
    fileprivate let identify = "PickerImgCell"
    //myCollectionView
    fileprivate lazy var myCollectionView: UICollectionView = {
        //左右边距
        let x: CGFloat = 0
        //上下边距
        let y: CGFloat = 0
        let w = self.view.frame.width - x * 2
        let h = self.view.frame.height - y * 2
        
        let rect = CGRect(x: x, y: y, width: w, height: h)
        let collectionView: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: self.layout)
        
        collectionView.backgroundColor = UIColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        
        let nib = UINib(nibName: self.identify, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: self.identify)
        
        return collectionView
    }()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.myCollectionView)
        
        self.myCollectionView.contentOffset.x = CGFloat(self.index - 1) * self.view.frame.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: UICollectionView 代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! PickerImgCell

        cell.imgView.image = self.imgArray[indexPath.row]
        cell.closeBtn.isHidden = true
        cell.imgView.contentMode = .scaleAspectFit
        
        cell.imgView.isUserInteractionEnabled = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
