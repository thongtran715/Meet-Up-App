//
//  MessageTableViewCell.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/7/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Bond
import Parse
class MessageTableViewCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            // 1
            if let post = post {
                //2
                // bind the image of the post to the 'postImage' view
                post.name.bindTo(topicLabel.bnd_text)
                post.date.bindTo(dateLabel.bnd_text)
                post.location.bindTo(locationLabel.bnd_text)
                post.creator.bindTo(creatorLabel.bnd_text)
            }
        }
    }
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var creatorLabel: UILabel!
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
