//
//  FindFriendsViewController.swift
//  Makestagram
//
//  Created by Quang Vu on 6/28/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit

class FindFriendsViewController: UIViewController {
    // MARK: - Properties
    
    var users = [User]()
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove separators for empty cells ???
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
}
