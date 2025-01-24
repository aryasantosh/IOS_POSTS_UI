import UIKit

class PostsViewController: UIViewController {
    private let viewModel = PostsViewModel()
    private var dropdownView: UIView?
    private var overlayView: UIView?

    lazy private var collectionView: UICollectionView = { //<- TODO: Name Change as topTenPostView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 18, height: 200)  // Adjusted to fit within screen width with padding
        layout.minimumLineSpacing = 16  // Adjust the spacing between cards
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)  // Adjusted to maintain padding
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    lazy private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()

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
        setupCollectionView()
        setupPageControl()
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pageControl.heightAnchor.constraint(equalToConstant: 20)
            ])
    }

    private func setupNavigationBar() { // TODO: Write a utility function that takes title and returns nav bar. Or use a base view controller and handle navigation in that controller. Make every controller extends to the base view controller. Remember Open for Extension, close for modification.
        let titleButton = UIButton(type: .system)
        titleButton.setTitle("Posts", for: .normal)
        titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButton.semanticContentAttribute = .forceRightToLeft
        titleButton.tintColor = .label
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleButton.addTarget(self, action: #selector(didTapDropdown), for: .touchUpInside)

        navigationItem.titleView = titleButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc private func didTapDropdown() { // TODO: Better keep drop down as sepearate view and add it as subview here. Again Open for extension, closed for modification.
        toggleDropdownView()
    }

    private func toggleDropdownView() {
        if dropdownView != nil {
            dismissDropdown()
            return
        }

        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDropdown)))
        view.addSubview(overlay)
        overlayView = overlay

        let dropdown = UIView()
        dropdown.backgroundColor = .systemBackground
        dropdown.layer.cornerRadius = 8
        dropdown.layer.borderColor = UIColor.lightGray.cgColor
        dropdown.layer.borderWidth = 1
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dropdown)
        dropdownView = dropdown

        let options = [
            ("Home", UIImage(systemName: "house.fill")),
            ("Latest", UIImage(systemName: "network")),
            ("Popular", UIImage(systemName: "gearshape.fill"))
        ]

        var previousStackView: UIStackView?

        for (text, image) in options {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.isUserInteractionEnabled = true
            stackView.translatesAutoresizingMaskIntoConstraints = false
            dropdown.addSubview(stackView)

            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .label
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 20)
            ])

            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .label
            stackView.addArrangedSubview(label)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectOption(_:)))
            stackView.addGestureRecognizer(tapGesture)

            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: dropdown.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: dropdown.trailingAnchor, constant: -16),
                stackView.heightAnchor.constraint(equalToConstant: 40)
            ])

            if let previous = previousStackView {
                stackView.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                stackView.topAnchor.constraint(equalTo: dropdown.topAnchor, constant: 8).isActive = true
            }

            previousStackView = stackView
        }

        previousStackView?.bottomAnchor.constraint(equalTo: dropdown.bottomAnchor, constant: -8).isActive = true

        if let titleView = navigationItem.titleView {
            let titleFrame = titleView.superview?.convert(titleView.frame, to: nil)
            NSLayoutConstraint.activate([
                dropdown.topAnchor.constraint(equalTo: view.topAnchor, constant: (titleFrame?.maxY ?? 64)),
                dropdown.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                dropdown.widthAnchor.constraint(equalToConstant: 200)
            ])
        }
    }

    @objc private func dismissDropdown() {
        dropdownView?.removeFromSuperview()
        dropdownView = nil
        overlayView?.removeFromSuperview()
        overlayView = nil
    }

    @objc private func didSelectOption(_ sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView,
              let label = stackView.arrangedSubviews.compactMap({ $0 as? UILabel }).first else { return }

        print("Selected option: \(label.text ?? "")")
        dismissDropdown()
    }

    // Remaining setup methods for CollectionView, TableView, ActivityIndicator, and ViewModel stay the same



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

//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let width = UIScreen.main.bounds.width * 0.8 // 80% of screen width
//    let height: CGFloat = 200 // Fixed height
//    return CGSize(width: width, height: height)
//}


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
        if indexPath.row == 0 { //TODO: Add collection view in a tableview cell and return here
            return UITableViewCell() // HERE
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = viewModel.remainingPosts[indexPath.row]
        cell.configure(with: post)
        // Assign the delegate to the cell
        cell.delegate = self
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
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return } //TODO: Very badddd, but if you can come up with some other means it is good.
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

extension PostsViewController: PostTableViewCellDelegate {
    func didUpdateFavouriteStatus(for post: Post, isFavourite : Bool) {
        print("Post with ID \(post.id) favourite status updated: \(post.isFavourite ?? false)")
        viewModel.posts[post.id - 1].isFavourite = isFavourite
        
    }
}
