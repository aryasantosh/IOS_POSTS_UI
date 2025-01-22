//
//  PostDetailsViewController.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//

import UIKit

class PostDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CommentsViewModel()
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        
        if let postId = post?.id {
            viewModel.fetchComments(for: postId) // Fetch comments asynchronously
        }
    }
    
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func bindViewModel() {
        viewModel.onCommentsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension PostDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = viewModel.comments[indexPath.row]
        
        if viewModel.expandedIndexes.contains(indexPath.row) {
            cell.textLabel?.text = "\(comment.email): \(comment.body)"
        } else {
            cell.textLabel?.text = comment.email // Show only the email when collapsed
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleComment(at: indexPath.row) // Toggle comment expansion/collapse
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

