import UIKit


class PostsViewController: UIViewController {
    private let viewModel = PostsViewModel()
    private var dropdownView: DropdownView?
    private var overlayView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .networkStatusChanged, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }

    @objc private func networkStatusChanged() {
        if NetworkMonitor.shared.isConnected {
            showToast(message: "Internet connection restored")
            viewModel.fetchPosts()
        } else {
            showToast(message: "No internet connection")
            viewModel.showOnlyFavorites()
        }
    }


    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.alpha = 0
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
    }
    
    private func setupNavigationBar() {
        let titleButton = UIButton(type: .system)
        titleButton.setTitle("Posts", for: .normal)
        titleButton.semanticContentAttribute = .forceRightToLeft
        titleButton.tintColor = .label
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        navigationItem.titleView = titleButton
    }
    
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        
        UIView.animate(withDuration: 0.1) {
            self.activityIndicator.alpha = 1.0
        }
    }
    
    private func setupViewModel() {
        activityIndicator.startAnimating()
        viewModel.onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.viewModel.sortPostsByFavorites() // Sort posts with favorites on top
                self?.tableView.reloadData()
                
            }
        }
        viewModel.onError = { errorMessage in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                print("Error: \(errorMessage)")
            }
        }
        if NetworkMonitor.shared.isConnected {
                viewModel.fetchPosts()
            } else {
                showToast(message: "No internet connection. Showing only favorites.")
                viewModel.fetchPosts()
            }
//        viewModel.fetchPosts()
    }
}

extension PostsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        let post = viewModel.topPosts[indexPath.item]
        cell.configure(with: post.title, description: post.body, index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.topPosts[indexPath.item]
        navigateToPostDetails(post: post)
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let collectionView = scrollView as? UICollectionView else { return }
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
            
            let pageControl = cell.contentView.subviews.compactMap { $0 as? UIPageControl }.first
            let pageWidth = scrollView.frame.width
            let pageIndex = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            
            pageControl?.currentPage = pageIndex
        }
    
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.remainingPosts.count + 1
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let collectionCell = UITableViewCell()
            
            let layout = SnappingFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 200)
            layout.minimumLineSpacing = 16

            let horizontalInset = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.9)) / 2
            layout.sectionInset = UIEdgeInsets(top: 16, left: horizontalInset, bottom: 16, right: horizontalInset)

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.decelerationRate = .fast // Enable smooth snapping
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

            collectionView.dataSource = self
            collectionView.delegate = self

            
            let pageControl = UIPageControl()
            pageControl.hidesForSinglePage = true
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = .systemBlue
            pageControl.numberOfPages = viewModel.topPosts.count
            
            collectionCell.contentView.addSubview(collectionView)
            collectionCell.contentView.addSubview(pageControl)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: collectionCell.contentView.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: collectionCell.contentView.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: collectionCell.contentView.trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 200),
                
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
                pageControl.centerXAnchor.constraint(equalTo: collectionCell.contentView.centerXAnchor),
                pageControl.bottomAnchor.constraint(equalTo: collectionCell.contentView.bottomAnchor, constant: -8)
            ])
            
            return collectionCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = viewModel.remainingPosts[indexPath.row - 1]
        cell.configure(with: post)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Prevent interaction with the collection view row
        if indexPath.row == 0 { return }
        
        // Navigate to post details for the selected table view card
        let post = viewModel.remainingPosts[indexPath.row - 1] // Adjust for the collection view row
        navigateToPostDetails(post: post)
    }
}

private extension PostsViewController {
    func navigateToPostDetails(post: Post) {
        viewModel.fetchComments(for: post.id)
        viewModel.onCommentsUpdated = { [weak self] in
            DispatchQueue.main.async {
                let detailVC = PostDetailViewController(post: post, comments: self?.viewModel.comments ?? [])
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension PostsViewController: PostTableViewCellDelegate {
    func didUpdateFavouriteStatus(for post: Post, isFavourite: Bool) {
        viewModel.updateFavoriteStatus(for: post.id, isFavorite: isFavourite) // Update in ViewModel
        viewModel.sortPostsByFavorites() // Reorder posts
        tableView.reloadData() // Refresh the UI
    }
}






