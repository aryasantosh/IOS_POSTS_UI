import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"

    lazy private var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }()
    
    lazy private var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .systemBlue
        return label
    }()

    lazy private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2  // Initially set to 2 for truncation
        label.textAlignment = .left
        label.textColor = .label
        label.alpha = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down.circle")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy private var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        button.addTarget(self, action: #selector(expandBody), for: .touchUpInside)
        return button
    }()
    
    private var isExpanded = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        contentView.addSubview(cardView)

        //TODO: Write below code in seperate function.
        // Add subviews to the card view
        cardView.addSubview(emailLabel)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(seeMoreButton)
        cardView.addSubview(rightIconImageView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        rightIconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for card view
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emailLabel.trailingAnchor.constraint(equalTo: rightIconImageView.leadingAnchor, constant: -8),

            rightIconImageView.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            rightIconImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            rightIconImageView.widthAnchor.constraint(equalToConstant: 20),
            rightIconImageView.heightAnchor.constraint(equalToConstant: 20),

            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            
            seeMoreButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            seeMoreButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])

        seeMoreButton.isHidden = true // Initially hide the button
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with comment: Comment, isExpanded: Bool) {
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
        self.isExpanded = isExpanded

        // Update the number of lines and button title
        bodyLabel.numberOfLines = isExpanded ? 0 : 2
        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)

        // Show or hide the "See More" button based on whether text is truncated
        let isTruncated = UILabel.isTextTruncated(label: bodyLabel, maxLines: 2)
        seeMoreButton.isHidden = !isTruncated
    }

    @objc private func expandBody() {
        isExpanded.toggle()

        // Update the number of lines and button title
        bodyLabel.numberOfLines = isExpanded ? 0 : 2
        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)

        // Immediately update the cell layout
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })

        // Force the table view to recalculate row heights
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

// Extension for calculating dynamic label height
extension UILabel {
    static func isTextTruncated(label: UILabel, maxLines: Int) -> Bool {
        let maxHeight = label.font.lineHeight * CGFloat(maxLines)
        return label.frame.size.height > maxHeight
    }
}


//import UIKit
//
//class CommentTableViewCell: UITableViewCell {
//    static let identifier = "CommentTableViewCell"
//
//    private let cardView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 6
//        return view
//    }()
//    
//    private let emailLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.numberOfLines = 1
//        label.textColor = .systemBlue
//        return label
//    }()
//
//    private let bodyLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.numberOfLines = 2  // Initially set to 2 for truncation
//        label.textAlignment = .left
//        label.textColor = .label
//        label.alpha = 1
//        label.lineBreakMode = .byTruncatingTail
//        return label
//    }()
//
//    private let rightIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.down.circle")
//        imageView.tintColor = .systemBlue
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    private let seeMoreButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("See More", for: .normal)
//        button.addTarget(self, action: #selector(expandBody), for: .touchUpInside)
//        return button
//    }()
//    
//    private var isExpanded = false
//    private var bodyLabelHeightConstraint: NSLayoutConstraint!
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        self.selectionStyle = .none
//        contentView.addSubview(cardView)
//
//        // Add subviews to the card view
//        cardView.addSubview(emailLabel)
//        cardView.addSubview(bodyLabel)
//        cardView.addSubview(seeMoreButton)
//        cardView.addSubview(rightIconImageView)
//
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
//        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        rightIconImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        // Set up constraints for card view
//        NSLayoutConstraint.activate([
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//
//            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            emailLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
//            emailLabel.trailingAnchor.constraint(equalTo: rightIconImageView.leadingAnchor, constant: -8),
//
//            rightIconImageView.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
//            rightIconImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
//            rightIconImageView.widthAnchor.constraint(equalToConstant: 20),
//            rightIconImageView.heightAnchor.constraint(equalToConstant: 20),
//
//            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
//            bodyLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
//            
//            seeMoreButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
//            seeMoreButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
//            seeMoreButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
//        ])
//
//        // Set bodyLabel height constraint for smooth expansion and collapse
//        bodyLabelHeightConstraint = bodyLabel.heightAnchor.constraint(equalToConstant: 44) // Default height
//        bodyLabelHeightConstraint.isActive = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with comment: Comment, isExpanded: Bool) {
//        emailLabel.text = comment.email
//        bodyLabel.text = comment.body
//        self.isExpanded = isExpanded
//
//        // Update the number of lines and button title
//        bodyLabel.numberOfLines = isExpanded ? 0 : 2
//        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)
//
//        // Show or hide the "See More" button based on whether text is truncated
//        let isTruncated = UILabel.isTextTruncated(label: bodyLabel, maxLines: 2)
//        seeMoreButton.isHidden = !isTruncated
//    }
//
//    @objc private func expandBody() {
//        isExpanded.toggle()
//
//        // Update the number of lines and button title
//        bodyLabel.numberOfLines = isExpanded ? 0 : 2
//        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)
//
//        // Animate the height change of body label for smooth expansion and collapse
//        UIView.animate(withDuration: 0.3, animations: {
//            // If expanded, set a larger height (e.g., 200), otherwise reset to original height
//            self.bodyLabelHeightConstraint.constant = self.isExpanded ? 200 : 44
//            self.layoutIfNeeded() // Trigger layout update for just this cell
//        })
//
//        // Ensure the table view cells are properly re-laid out when expanded/collapsed
//        if let tableView = self.superview as? UITableView {
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
//    }
//}
//
//// Extension for calculating dynamic label height
//extension UILabel {
//    static func isTextTruncated(label: UILabel, maxLines: Int) -> Bool {
//        let maxHeight = label.font.lineHeight * CGFloat(maxLines)
//        return label.frame.size.height > maxHeight
//    }
//}
