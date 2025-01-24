import UIKit

class PostDetailHeaderCell: UITableViewCell {
    static let identifier = "PostDetailHeaderCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Setup title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.label // Adapts to light/dark mode
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Setup description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = UIColor.secondaryLabel // Adapts to light/dark mode
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        // Content view setup for card-like effect
        contentView.backgroundColor = UIColor.systemBackground // Adapts to light/dark mode
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with post: Post) {
        titleLabel.text = post.title
        descriptionLabel.text = post.body
    }
}
