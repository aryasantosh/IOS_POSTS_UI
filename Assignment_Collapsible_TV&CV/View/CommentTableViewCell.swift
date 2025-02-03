import UIKit

 protocol CommentCellDelegate : AnyObject {
    func handleCommentExpansion(in cell: CommentTableViewCell)
}
class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    weak var delegate: CommentCellDelegate?
    
    lazy private var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10  //to access the visual layer of a UI element
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
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .label
        label.alpha = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy private var rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down.circle")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
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
           // Prevent the email label from being tappable
           emailLabel.isUserInteractionEnabled = false
           // Call the function to add subviews and set constraints
           setupSubviewsAndConstraints()
           seeMoreButton.isHidden = true // Initially hide the button
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviewsAndConstraints() {
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
            
            seeMoreButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -6),
            seeMoreButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    func configure(with comment: Comment, isExpanded: Bool) {
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
        self.isExpanded = isExpanded

        // Update the number of lines and button title
        bodyLabel.numberOfLines = isExpanded ? 0 : 2
        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)

        // Update the arrow icon **immediately**
        rightIconImageView.image = isExpanded ? UIImage(systemName: "chevron.up.circle") : UIImage(systemName: "chevron.down.circle")

        layoutIfNeeded()  //layout is updated properly to reflect the change in the text size
        
        // Check if text is truncated and show/hide the "See More" button accordingly
        let isTruncated = UILabel.isTextTruncated(label: bodyLabel, maxLines: 2)
        seeMoreButton.isHidden = !isTruncated  //displaying
    }

    
    @objc private func expandBody() {
        delegate?.handleCommentExpansion(in: self )
        }
    }


// Extension for calculating dynamic label height
extension UILabel {
    static func isTextTruncated(label: UILabel, maxLines: Int) -> Bool {
        guard let text = label.text, let font = label.font else { return false }

        let maxWidth = label.frame.width
        let maxHeight = font.lineHeight * CGFloat(maxLines)
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let boundingBox = text.boundingRect(
            with: constraintSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return boundingBox.height > maxHeight
    }
}

