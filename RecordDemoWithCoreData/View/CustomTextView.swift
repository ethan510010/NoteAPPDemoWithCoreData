//
//  CustomTextView.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/6/18.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
class CustomTextView:UITextView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.textColor = UIColor.white
    }
}

