//
//  PickerImgView.swift
//  PickerImg
//
//  Created by sqluo on 2016/12/6.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


public enum ImgType {
    case name
    case image
}

public class ImgModel {
    
    var img: Any!
    var type:ImgType = .name
    
    init(img: Any, type: ImgType) {
        self.img = img
        self.type = type
    }
    
    
}



class PickerImgView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    
    //layout
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let h: CGFloat = self.frame.height - 5 * 2
        layout.itemSize = CGSize(width: h, height: h)
        
        layout.minimumLineSpacing = 0  //上下间隔
        layout.minimumInteritemSpacing = 5 //左右间隔
        layout.headerReferenceSize = CGSize(width: 5, height: 0)
        layout.footerReferenceSize = CGSize(width: 5, height: 0)

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
        let w = self.frame.width - x * 2
        let h = self.frame.height - y * 2
        
        let rect = CGRect(x: x, y: y, width: w, height: h)
        let collectionView: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: self.layout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: self.identify, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: self.identify)
        
        return collectionView
    }()
    
    //初始有一个添加的图片 数组
    fileprivate var dataArray: [ImgModel] = [ImgModel(img: "plus", type: .name)]
    
    fileprivate var superCtr: UIViewController!
    
    
    init(frame: CGRect, dataArray: [ImgModel]?, target: UIViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red
        
        self.superCtr = target
        
        //如果传入的不为空，则追加到显示数组中
        if let imgArray = dataArray {
            self.dataArray += imgArray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func draw(_ rect: CGRect) {
        
        self.addSubview(self.myCollectionView)
   
    }
 

    //MARK: UICollectionView 代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identify, for: indexPath) as! PickerImgCell

        if self.dataArray.count > 1 {
            
            //最后一个，则为 +
            if indexPath.row == self.dataArray.count - 1 {
                
                let model = self.dataArray[0]
                
                switch model.type {
                case .name:
                    cell.imgView.image = UIImage(named: model.img as! String)
                case .image:
                    cell.imgView.image = model.img as? UIImage
                }
  
                cell.imgView.tag = 0
                cell.closeBtn.isHidden = true
                cell.imgViewHandler = self.imgViewActHandler
            }else{
                
                let model = self.dataArray[indexPath.row + 1]

                switch model.type {
                case .name:
                    cell.imgView.image = UIImage(named: model.img as! String)
                case .image:
                    cell.imgView.image = model.img as? UIImage
                }
  
                cell.closeBtn.isHidden = false
                
                cell.closeBtn.tag = indexPath.row + 1
                cell.imgView.tag = indexPath.row + 1
                
                cell.closeHandler = self.closeBtnActHandler
                cell.imgViewHandler = self.imgViewActHandler
            }
  
            
        }else{
            //只有一个
            let model = self.dataArray[indexPath.row]

            switch model.type {
            case .name:
                cell.imgView.image = UIImage(named: model.img as! String)
            case .image:
                cell.imgView.image = model.img as? UIImage
            }
            
            cell.imgView.tag = indexPath.row

            cell.closeBtn.isHidden = true
            cell.imgViewHandler = self.imgViewActHandler
        }
 
        return cell
    }
    
    
    //MARK:回调
    fileprivate func closeBtnActHandler(_ index: Int){
        print("回调删除-> \(index)")
        
        let alertCtr = UIAlertController(title: "删除提示", message: "是否真的要删除该图片", preferredStyle: .alert)
        
        alertCtr.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        alertCtr.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (alert) in
            
            self.dataArray.remove(at: index)
            
            self.myCollectionView.reloadData()
        }))
        
        
        
        self.superCtr.present(alertCtr, animated: true, completion: nil)
 
    }
    
    //显示大图片
    fileprivate var imgView: UIImageView?
    
    fileprivate func imgViewActHandler(_ index: Int){
        print("图片点击回调-> \(index)")
        //index == 0 则为添加图片，否则则显示图片大图
        if index == 0 {
            self.selectImgAct()
        }else{
            
            let imgArray = self.getAllImgArray()

            let bigVC = BigImgViewController(imgArray: imgArray, index: index)
 
            self.superCtr.present(bigVC, animated: false, completion: nil)
        }
        
        
    }
    

    
    
    
    
    fileprivate func selectImgAct(){
        
        let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.phtoAct()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.default, handler: { (act:UIAlertAction) in
            self.selecetPhto()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        
        if self.superCtr != nil{
            self.superCtr!.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    //拍照
    fileprivate func phtoAct(){
        var sourceTyte = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController .isSourceTypeAvailable(.camera)
        {
            sourceTyte = UIImagePickerControllerSourceType.photoLibrary
        }
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        pickerC.allowsEditing = true
        pickerC.sourceType = sourceTyte
        pickerC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.superCtr!.present(pickerC, animated: false) { () -> Void in
            
        }
    }
    //拍照的照片
    var image = UIImagePickerController()
    
    //相册选取
    fileprivate func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.superCtr!.present(image, animated: false, completion: nil)
    }
 
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        picker.dismiss(animated: false, completion: nil)
        
        
        var image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        let model = ImgModel(img: image, type: .image)
        self.dataArray.append(model)
        self.myCollectionView.reloadData()
    }

    
    //MARK:开放的接口
    
    //根据index 获取对应的图片
    func getImage(index: Int) -> UIImage?{
        
        let model = self.dataArray[index]
        
        switch model.type {
        case .name:
            return UIImage(named: model.img as! String)
        case .image:
            return model.img as? UIImage
        }

    }

    //获取所有的图片
    func getAllImgArray() -> [UIImage]{
        
        //如果需要返回 url 的图片，需要另外处理
        
        var imgArray = [UIImage]()
        
        for i in 0..<self.dataArray.count {
            //不需要返回第0个，第0个为默认的添加图片
            if i != 0 {
                
                let model = self.dataArray[i]
                
                switch model.type {
                case .name: //如果是图片名字
                    imgArray.append(UIImage(named: model.img as! String)!)
                case .image: //如果已经是图片
                    imgArray.append(model.img as! UIImage)
                }
     
            }
        }
        
        return imgArray
        
    }
    
    
}







