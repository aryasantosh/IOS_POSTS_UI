import UIKit

class PostsViewController: UIViewController {
    private let viewModel = PostsViewModel()
    private var expandedCommentIndex: Int?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true // Enable paging
        collectionView.showsHorizontalScrollIndicator = false // Hide line animation
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        return pageControl
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.alpha = 0 // Start with hidden activity indicator
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        setupPageControl()
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
    }

    private func setupNavigationBar() {
    
        // Create custom buttons with heart and cloud icons (SF Symbols)
        let heartButton = UIButton(type: .custom)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)

        let cloudButton = UIButton(type: .custom)
        cloudButton.setImage(UIImage(systemName: "cloud.fill"), for: .normal)
        cloudButton.addTarget(self, action: #selector(didTapCloud), for: .touchUpInside)

        // Create a container view for the bar buttons
        let containerView = UIView()
        
        // Set the container view's frame to adjust the size
        containerView.frame = CGRect(x: 0, y: 0, width: 120, height: 40) // Adjust width and height as needed
        
        // Create a stack view for the buttons and add them to the container view
        let stackView = UIStackView(arrangedSubviews: [heartButton, cloudButton])
        stackView.axis = .horizontal
        stackView.spacing = 16 // Adjust spacing between the buttons
        stackView.alignment = .center
        stackView.distribution = .fill
        
        // Add the stack view to the container view
        containerView.addSubview(stackView)
        
        // Set the stack view's constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Set the container view as the right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView)
    }




    @objc private func didTapHeart() {
        let alert = UIAlertController(title: "Heart Button", message: "You tapped the heart icon!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapCloud() {
        let alert = UIAlertController(title: "Cloud Button", message: "You tapped the cloud icon!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
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
                self?.collectionView.reloadData()
                self?.tableView.reloadData()
                self?.pageControl.numberOfPages = self?.viewModel.topPosts.count ?? 0
                UIView.animate(withDuration: 0.3) {
                    self?.collectionView.alpha = 1.0
                    self?.tableView.alpha = 1.0
                }
            }
        }
        viewModel.onError = { errorMessage in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                print("Error: \(errorMessage)")
            }
        }
        viewModel.fetchPosts()
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
        cell.configure(with: post.title, description: post.body)

        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1.0
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.topPosts[indexPath.item]
        navigateToPostDetails(post: post)

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                           cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.2) {
                               cell.transform = CGAffineTransform.identity
                           }
                       })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else {
            return // Prevent division by zero
        }
        let pageIndex = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        pageControl.currentPage = pageIndex
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.remainingPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = viewModel.remainingPosts[indexPath.row]
        cell.configure(with: post)

        // Add subtle animation for cell appearance
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1.0
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.remainingPosts[indexPath.row]
        navigateToPostDetails(post: post)

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2,
                           animations: {
                               cell.alpha = 0.5
                               cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                           }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.alpha = 1.0
                    cell.transform = CGAffineTransform.identity
                }
            }
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
