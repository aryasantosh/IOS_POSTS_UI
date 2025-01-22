import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .darkGray
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .black
        label.isHidden = true // Initially hidden
        return label
    }()

    // Animated SF Symbol
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        let symbol = UIImage(systemName: "chevron.down.circle.fill") // SF Symbol
        button.setImage(symbol, for: .normal)
        button.tintColor = .blue
        return button
    }()

    private var isCollapsed = true {
        didSet {
            bodyLabel.isHidden = isCollapsed
            // Animation for expanding/collapsing
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()  // Smooth transition on expansion/collapse
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // ContentView setup
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        
        // Add subviews
        contentView.addSubview(emailLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(expandButton)

        // Set constraints for emailLabel, bodyLabel, and expandButton
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emailLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor, constant: -8),
            
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expandButton.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        // Set action for the expandButton (SF Symbol)
        expandButton.addTarget(self, action: #selector(expandBody), for: .touchUpInside)
        
        // Initially hiding body text
        bodyLabel.isHidden = isCollapsed
        
        // Make email label clickable
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailTapped)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with comment: Comment, isExpanded: Bool) {
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
        isCollapsed = !isExpanded
    }

    @objc func expandBody() {
        // Apply the bounce animation to the SF Symbol (expandButton)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: .curveEaseOut, animations: {
            self.expandButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)  // Scale the button
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.expandButton.transform = CGAffineTransform.identity // Reset scale back
            })
        }

        // Toggle the body visibility
        isCollapsed.toggle()
    }
    
    @objc func emailTapped() {
        // Toggle visibility of the bodyLabel when email is tapped
        isCollapsed.toggle()
    }
}
