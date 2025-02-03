//
//  PostCollectionViewManager.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 27/01/25.
//

import UIKit

class PostsCollectionTableViewCell: UITableViewCell {
    static let identifier = "PostsCollectionTableViewCell"
    private var randomTextCache: [Int: String] = [:]
    private var posts: [Post] = []
    private var navigateToPostDetails: ((Post) -> Void)?

    private lazy var layout: UICollectionViewFlowLayout = {  //organizes items into a grid
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 200) //the width of the screen in points
        layout.minimumLineSpacing = 16
        let horizontalInset = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.9)) / 2 //find the horizontal space that should be added on both sides
        layout.sectionInset = UIEdgeInsets(top: 16, left: horizontalInset, bottom: 16, right: horizontalInset) //the space between the edges of a section and its contents
        return layout
    }()

    // Lazy property for the collection view
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast  //scrolling
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // Lazy property for the page control
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),

            // Page control constraints
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with posts: [Post], navigateToPostDetails: @escaping (Post) -> Void) {
        self.posts = posts
        self.navigateToPostDetails = navigateToPostDetails
        randomTextCache.removeAll() // Clear cache to allow new random texts
        pageControl.numberOfPages = posts.count // Sync page control with posts count
        collectionView.reloadData() // Reload collection view data
    }
}

// MARK: - Collection View Data Source
extension PostsCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        

        let post = posts[indexPath.item]
        let randomText = Constants.randomTexts[indexPath.item % Constants.randomTexts.count] // Assign fixed random text
        cell.configure(with: post.title, description: post.body, index: indexPath.item, randomText: randomText)
        
        // Assign a consistent random text to each indexPath
        if randomTextCache[indexPath.item] == nil {
            randomTextCache[indexPath.item] = Constants.randomTexts.randomElement() ?? "Default Text"
        }
        cell.setRandomText(randomTextCache[indexPath.item]!)
        return cell
    }
}

// MARK: - Collection View Delegate
extension PostsCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        navigateToPostDetails?(post)
    }
}

// MARK: - Scroll View Delegate
extension PostsCollectionTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + (pageWidth / 2)) / pageWidth)
        pageControl.currentPage = currentPage
    }
}

