import UIKit

final class PostsViewController: BaseViewController {
    private let viewModel = PostsViewModel()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar(withTitle: "Posts")
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostsCollectionTableViewCell.self, forCellReuseIdentifier: PostsCollectionTableViewCell.identifier) // Ensure this is registered

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {  //setting up the ViewModel for handling network monitoring, fetching posts.
        activityIndicator.startAnimating()
        
        let onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.viewModel.sortPostsByFavorites()
                self?.tableView.reloadData()
            }
        }
        
        let onError: ((String) -> Void) = { errorMessage in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                print("Error: \(errorMessage)")
            }
        }
        
        let showToastMessage: ((String) -> Void) = { [weak self] message in
            self?.showToast(message: message)
        }
        
        viewModel.setupNetworkMonitor(onPostsUpdated: onPostsUpdated, onError: onError, showToast: showToastMessage)
        viewModel.checkInternetAndFetchPosts(onPostsUpdated: onPostsUpdated, onError: onError)
    }
}

// MARK: - UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.remainingPosts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { //method is called every time a new cell is about to appear on the screen.
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsCollectionTableViewCell.identifier, for: indexPath) as? PostsCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.topPosts) { [weak self] selectedPost in //The closure is likely a callback function that is executed when a post is tapped.
                self?.navigateToPostDetails(post: selectedPost)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = viewModel.remainingPosts[indexPath.row - 1]  //first row is used for the collection view
        cell.configure(with: post)  //set
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        let post = viewModel.remainingPosts[indexPath.row - 1] //display the posts
        navigateToPostDetails(post: post)
    }
}

private extension PostsViewController {
    func navigateToPostDetails(post: Post) {
        DispatchQueue.main.async {
            let detailVC = PostDetailViewController(post: post, viewModel: PostDetailViewModel())
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension PostsViewController: PostTableViewCellDelegate {
    func didUpdateFavouriteStatus(for post: Post, isFavourite: Bool) {
        viewModel.updateFavoriteStatus(for: post.id, isFavorite: isFavourite)
        viewModel.sortPostsByFavorites()
        tableView.reloadData()
    }
}

