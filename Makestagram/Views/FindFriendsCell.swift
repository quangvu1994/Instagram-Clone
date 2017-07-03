//
//  FindFriendsCell.swift
//  Makestagram
//
//  Created by Quang Vu on 7/2/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import UIKit

class FindFriendsCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
    }

    @IBAction func followUser(_ sender: UIButton) {
    }

}
