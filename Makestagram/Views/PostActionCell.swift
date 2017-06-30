//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Quang Vu on 6/29/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {

    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likePost(_ sender: Any) {
        
    }
}
