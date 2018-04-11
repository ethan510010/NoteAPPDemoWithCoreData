//
//  PhotoTableViewCell.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/4/10.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageview: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
