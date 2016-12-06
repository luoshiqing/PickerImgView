//
//  ViewController.swift
//  PickerImg
//
//  Created by sqluo on 2016/12/6.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.gray
        
        
        let rect = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 120)
        
        
        let imgArray = [ImgModel(img: "plus", type: .name),
                        ImgModel(img: UIImage(named: "plus")!, type: .image)]
 
        
        let picker = PickerImgView(frame: rect, dataArray: nil, target: self)
        
        self.view.addSubview(picker)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

