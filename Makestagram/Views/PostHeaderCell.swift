//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Quang Vu on 6/29/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        print("Button Tapped")
    }
}
