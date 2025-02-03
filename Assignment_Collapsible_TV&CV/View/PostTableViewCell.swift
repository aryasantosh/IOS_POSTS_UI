//  Assignment_Collapsible_TV&CV
//
//To prevent issues with cell reuse, I reset the cell's state in the `prepareForReuse()` method by clearing animations, transforms, and removing any temporary UI elements (like the toast label). I also manage the favorite button state (`heartImageView`) by ensuring it reflects the current post’s `isFavourite` status each time the cell is configured. To avoid duplicate gesture recognizers, I remove any existing ones before adding new ones. This approach ensures that actions like tapping the favorite button are handled correctly, and the correct state is shown even during cell reuse.

//  Created by Arya Kulkarni on 21/01/25.
//
//PostTableViewCell.swift


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
        view.backgroundColor = UIColor.tertiarySystemBackground // Subtle adaptive color
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
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
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
        
        self.post = post //Store reference to post
        
        // Set the heart image based on the isFavourite state
        let isFavourite = post.isFavourite ?? false //optional boolean
        heartImageView.image = UIImage(systemName: isFavourite ? Constants.heartFilled : Constants.heartEmpty)
        
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
        post.isFavourite = !(post.isFavourite ?? false) // Toggle and ! flip the boolean value.
        delegate?.didUpdateFavouriteStatus(for: post, isFavourite: post.isFavourite ?? false)
    }
    
    private func startChevronAnimation() {
        chevronImageView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: {
            self.chevronImageView.transform = self.chevronImageView.transform.translatedBy(x: 10, y: 0) //points
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.chevronImageView.alpha = 0.6 //controls the transparency of the view. It will continuously toggle between fully visible (alpha = 1.0) and semi-transparent
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chevronImageView.transform = CGAffineTransform.identity
        chevronImageView.alpha = 1.0
        toastLabel?.removeFromSuperview()
    }
    
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
