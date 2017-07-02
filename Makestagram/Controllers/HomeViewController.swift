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
    
    // Convert date to a formatted string
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve the post
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post Header Cell", for: indexPath) as! PostHeaderCell
            cell.username.text = User.current.username
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post Image Cell", for: indexPath) as! PostImageCell
            
            // Instantiate URL object with the image's url
            let imageURL = URL(string: post.imageURL)
            // Using Kingfisher to set the image
            cell.postImageView.kf.setImage(with: imageURL)
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post Action Cell", for: indexPath) as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)

            return cell

        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.numberOfLikes.text = "\(post.likeCount) likes"
    }
    
}

extension HomeViewController: UITableViewDelegate {
    // Dynamically set the height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
        case 2:
            return PostActionCell.height
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
}

extension HomeViewController: PostActionCellDelegate {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        // Check the indexPath exists on the given cell
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // ignore event triggered by the user for now. Note: Difference then isEnabled
        likeButton.isUserInteractionEnabled = false
        // Grab the associated post
        let post = posts[indexPath.section]
        
        // trigger the like/dislike action
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // Trigger this just before we are about the exit this block of code
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // Check to see if the like/dislike action was successful or not
            guard success else { return }
            
            // Increase/Decrease like count based on the current action
            post.likeCount += !post.isLiked ? 1 : -1
            // Set the state of the post
            post.isLiked = !post.isLiked
            
            // Get the reference of the current cell
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            // Notify main queue and update the UI
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
