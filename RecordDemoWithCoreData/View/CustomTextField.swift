//
//  CustomTextField.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/6/18.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
class CustomTextField:UITextField{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(string: "輸入標題", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}
