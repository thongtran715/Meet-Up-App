//
//  TimeLinetableviewCell.swift
//  Meet Up
//
//  Created by Thong Tran on 7/13/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import UIKit

class TimeLinetableviewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet var imageOfEvent: UIImageView!
    @IBOutlet var topicName: UILabel!

    @IBOutlet var whereTheEvent: UILabel!
    @IBOutlet var timeEvent: UILabel!
}
