//
//  ViewController.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//

import UIKit

class PostsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = PostsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        activityIndicator.startAnimating()
        viewModel.fetchPosts() // Fetch posts asynchronously
    }
    
    private func setupViews() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostTableCell")
    }
    
    private func bindViewModel() {
        viewModel.onPostsUpdated = { [weak self] in
            self?.activityIndicator.stopAnimating() // Hide loading indicator
            self?.collectionView.reloadData()
            self?.tableView.reloadData()
        }
    }
}

extension PostsViewController: UICollectionViewDataSource, UITableViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath)
        let post = viewModel.topPosts[indexPath.row]
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.numberOfLines = 2
        label.text = "\(post.title)\n\(post.body.prefix(100))" // Title + 2 lines of content
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        
        cell.textLabel?.text = post.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Bold and larger font for title
        cell.detailTextLabel?.text = String(post.body.prefix(100)) // Show preview of content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        let detailVC = PostDetailsViewController()
        detailVC.post = selectedPost
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


