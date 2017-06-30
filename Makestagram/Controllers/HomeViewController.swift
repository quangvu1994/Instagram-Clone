//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Quang Vu on 6/28/17.
//  Copyright © 2017 Quang Vu. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomeViewController: UIViewController, UITableViewDataSource {
    
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Fetch our posts from the database
        UserService.fetchPosts(for: User.current, completion: { (postList) in
            self.posts = postList
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Image Cell", for: indexPath) as! PostImageCell
        // Retrieve the post
        let post = posts[indexPath.row]
        // Instantiate URL object with the image's url
        let imageURL = URL(string: post.imageURL)
        // Using Kingfisher to set the image
        cell.postImageView.kf.setImage(with: imageURL)

        return cell
    }
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDelegate {
    // Dynamically set the height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        return post.imageHeight
    }
}
