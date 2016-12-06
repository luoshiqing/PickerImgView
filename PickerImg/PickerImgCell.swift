//
//  PickerImgCell.swift
//  PickerImg
//
//  Created by sqluo on 2016/12/6.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit






class PickerImgCell: UICollectionViewCell {

    //删除回调
    typealias closeBtnActHandler = (_ index: Int) -> Swift.Void
    var closeHandler: closeBtnActHandler?
    //图片点击回调
    typealias imgViewActHandler = (_ index: Int) -> Swift.Void
    var imgViewHandler: imgViewActHandler?
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.closeBtn.addTarget(self, action: #selector(self.closeBtnAct(send:)), for: .touchUpInside)
        
        self.imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imgViewTapAct(send:)))
        self.imgView.addGestureRecognizer(tap)
        
        
    }

    //删除按钮点击
    func closeBtnAct(send: UIButton){
        self.closeHandler?(send.tag)
    }
    
    //图片点击
    func imgViewTapAct(send: UITapGestureRecognizer){
        self.imgViewHandler?(send.view!.tag)
    }
    
    
    
}
