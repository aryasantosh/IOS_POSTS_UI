import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didUpdateFavouriteStatus(for post: Post, isFavourite: Bool)
}

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    
    weak var delegate: PostTableViewCellDelegate? // Delegate property
    var post: Post? // Reference to the post object
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.5)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()
    
    lazy private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy private var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy private var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right.dotted.chevron.right")
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.heartEmpty) // Using Constants for image names
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var isHeartFilled: Bool = false
    private var toastLabel: UILabel?
    
    var collectionView: UICollectionView?

    
    func configureCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: 200)
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView?.backgroundColor = .clear
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
            contentView.addSubview(collectionView!)

            collectionView?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView!.topAnchor.constraint(equalTo: contentView.topAnchor),
                collectionView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collectionView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collectionView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                collectionView!.heightAnchor.constraint(equalToConstant: 200)
            ])
        }

        // Reset data source and delegate every time
        collectionView?.dataSource = dataSource
        collectionView?.delegate = delegate
        collectionView?.reloadData()
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Separate code into its own function for better modularity and readability
        setupCellContentView()

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            chevronImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            heartImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            heartImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -3),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),
            heartImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        titleLabel.text = "\(post.id). " + post.title
        bodyLabel.text = post.body
        
        self.post = post
        
        // Set the heart image based on the isFavourite state
        let isFavourite = post.isFavourite ?? false
        heartImageView.image = UIImage(systemName: isFavourite ? Constants.heartFilled : Constants.heartEmpty)
        
        // Reset collection view if it's part of the cell
        collectionView?.reloadData() // Ensure it shows the correct content for this cell
        
        // Remove previous gesture recognizers to avoid duplicates
           heartImageView.gestureRecognizers?.forEach { heartImageView.removeGestureRecognizer($0) }

        
        // Add a tap gesture recognizer to the heart image view
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        heartImageView.addGestureRecognizer(tapGesture)
        heartImageView.isUserInteractionEnabled = true
        

        startChevronAnimation()
    }
    
    @objc private func heartTapped() {
        guard var post = self.post else { return }
        
        post.isFavourite = !(post.isFavourite ?? false) // Toggle the favourite state
        
        if post.isFavourite == true {
            heartImageView.image = UIImage(systemName: Constants.heartFilled) // Using Constants for image names
//            showToast(message: "Added to Favourites")
        } else {
            heartImageView.image = UIImage(systemName: Constants.heartEmpty) // Using Constants for image names
//            showToast(message: "Removed from Favourites")
        }
        
        delegate?.didUpdateFavouriteStatus(for: post, isFavourite: post.isFavourite ?? false)
        
    }
    
//    @objc private func heartTapped() {
//        guard let currentPost = self.post else { return }
//
//        // Toggle the favourite state
//        let newFavouriteState = !(currentPost.isFavourite ?? false)
//        self.post?.isFavourite = newFavouriteState
//
//        // Update the heart image based on the new state
//        heartImageView.image = UIImage(systemName: newFavouriteState ? Constants.heartFilled : Constants.heartEmpty)
//
//        // Notify the delegate to update the global data source
//        delegate?.didUpdateFavouriteStatus(for: currentPost, isFavourite: newFavouriteState)
//    }







    
    private func showToast(message: String) {
        toastLabel?.removeFromSuperview()
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        contentView.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            toastLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
            toastLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.toastLabel = toastLabel
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    private func startChevronAnimation() {
        chevronImageView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: {
            self.chevronImageView.transform = self.chevronImageView.transform.translatedBy(x: 10, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.chevronImageView.alpha = 0.6
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chevronImageView.transform = CGAffineTransform.identity
        chevronImageView.alpha = 1.0
        toastLabel?.removeFromSuperview()
    }
    
    // MARK: - Helper Function
    private func setupCellContentView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        cardView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(chevronImageView)
        cardView.addSubview(heartImageView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}



//import UIKit
//
//protocol PostTableViewCellDelegate: AnyObject {
//    func didUpdateFavouriteStatus(for post: Post, isFavourite : Bool)
//}
//
//class PostTableViewCell: UITableViewCell {
//    static let identifier = "PostTableViewCell"
//
//    weak var delegate: PostTableViewCellDelegate? // Delegate property //TODO: Know before you use
//    var post: Post? // Reference to the post object
//    
//    lazy private var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.numberOfLines = 6
//        label.adjustsFontForContentSizeCategory = true
//        label.textColor = .label
//        return label
//    }()
//    
//    lazy private var bodyLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 2
//        label.textColor = .secondaryLabel
//        label.adjustsFontForContentSizeCategory = true
//        return label
//    }()
//    
//    lazy private var cardView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.layer.cornerRadius = 8
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 4
//        view.layer.masksToBounds = false
//        return view
//    }()
//    
//    lazy private var chevronImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.right.dotted.chevron.right")
//        imageView.tintColor = .systemGray
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    lazy private var heartImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "heart")
//        imageView.tintColor = .systemRed
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private var isHeartFilled: Bool = false
//    private var toastLabel: UILabel?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        contentView.addSubview(cardView)
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        
//        //TODO: seperate function
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        cardView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        cardView.addSubview(chevronImageView)
//        cardView.addSubview(heartImageView)
//        
//        
//        NSLayoutConstraint.activate([
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0), // Removed extra padding
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0), // Removed extra padding
//            
//            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
//            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
//            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
//            
//            chevronImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
//            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
//            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
//            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
//            
//            // Heart image view constraints - positioned at top-right of the cardView
//            heartImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),  // Adjust the top padding
//            heartImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),  // Adjust the right padding
//            heartImageView.widthAnchor.constraint(equalToConstant: 24),
//            heartImageView.heightAnchor.constraint(equalToConstant: 24)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with post: Post) {
//        titleLabel.text = post.title
//        bodyLabel.text = post.body
//        
//        self.post = post
//        
//        // Add a tap gesture recognizer to the heart image view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
//        heartImageView.addGestureRecognizer(tapGesture)
//        heartImageView.isUserInteractionEnabled = true
//        
//        // Set the initial state of the heart
//        if let isFavourite = post.isFavourite, isFavourite {
//            heartImageView.image = UIImage(systemName: "heart.fill") // Filled heart
//            showToast(message: "Added to Favourites")
//        } else {
//            heartImageView.image = UIImage(systemName: "heart") // Empty heart
//            showToast(message: "Not Added to Favourites")
//        }
//        startChevronAnimation()
//    }
//    
//    @objc private func heartTapped() {
//        // Toggle the favourite state
//        guard var post = self.post else { return }
//        
//        post.isFavourite = !(post.isFavourite ?? false) // Toggle the favourite state
//        
//        // Update the heart image based on the new favourite state
//        if post.isFavourite == true {
//            heartImageView.image = UIImage(systemName: "heart.fill") // Filled heart //TODO: ImageNames in Constants
//            showToast(message: "Added to Favourites")
//        } else {
//            heartImageView.image = UIImage(systemName: "heart") // Empty heart
//            showToast(message: "Removed from Favourites")
//        }
//        delegate?.didUpdateFavouriteStatus(for: post, isFavourite: post.isFavourite ?? false)
//        // Optionally, notify the view controller to update the data model
//        // Example: delegate?.didUpdateFavouriteStatus(for: post)
//    }
//    
//    private func showToast(message: String) {
//        toastLabel?.removeFromSuperview()
//        
//        let toastLabel = UILabel()
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastLabel.textColor = .white
//        toastLabel.font = UIFont.systemFont(ofSize: 14)
//        toastLabel.textAlignment = .center
//        toastLabel.text = message
//        toastLabel.alpha = 0.0
//        toastLabel.layer.cornerRadius = 8
//        toastLabel.clipsToBounds = true
//        
//        contentView.addSubview(toastLabel)
//        toastLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            toastLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            toastLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//            toastLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
//            toastLabel.heightAnchor.constraint(equalToConstant: 30)
//        ])
//        
//        self.toastLabel = toastLabel
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            toastLabel.alpha = 1.0
//        }) { _ in
//            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
//                toastLabel.alpha = 0.0
//            }, completion: { _ in
//                toastLabel.removeFromSuperview()
//            })
//        }
//    }
//    
//    private func startChevronAnimation() {
//        chevronImageView.transform = CGAffineTransform.identity
//        
//        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: {
//            self.chevronImageView.transform = self.chevronImageView.transform.translatedBy(x: 10, y: 0)
//        })
//        
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.chevronImageView.alpha = 0.6
//        })
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        chevronImageView.transform = CGAffineTransform.identity
//        chevronImageView.alpha = 1.0
//        toastLabel?.removeFromSuperview()
//    }
//}
//
//
//
//
//
//
