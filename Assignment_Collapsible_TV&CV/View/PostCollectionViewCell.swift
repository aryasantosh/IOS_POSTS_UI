import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private var assignedColor: UIColor?
    private var assignedRandomText: String? // Stores assigned text to prevent unwanted changes
       
    // Title Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelFont
        label.numberOfLines = 4
        label.textAlignment = .justified
        label.textColor = .black
        label.accessibilityLabel = "Post Title"
        return label
    }()
    
    // Description Label
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.descriptionLabelFont
        label.numberOfLines = 6
        label.textColor = .systemGray
        label.textAlignment = .justified
        label.accessibilityLabel = "Post Description"
        return label
    }()
    
    // Random Text Label
    private lazy var randomTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.randomTextLabelFont
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(Constants.randomTextLabelAlpha)
        label.semanticContentAttribute = .forceRightToLeft
        label.layer.cornerRadius = Constants.randomTextLabelCornerRadius
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.accessibilityLabel = "Random Text"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Setup the content view
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = Constants.shadowOpacity
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = Constants.shadowRadius
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        contentView.addSubview(randomTextLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        randomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            randomTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            randomTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.stackViewPadding),
            randomTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.randomTextLabelWidthMultiplier),
            randomTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.randomTextLabelHeightMultiplier)
        ])
    }
    
    func configure(with title: String, description: String, index: Int, randomText: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        setupCardColor(for: index)
        randomTextLabel.text = randomText
        // Animate the randomTextLabel
        slideInRandomTextLabel()
    }
    
    func setRandomText(_ text: String) {
        randomTextLabel.text = text
        randomTextLabel.alpha = 1.0
        randomTextLabel.transform = .identity
    }
    
    // Assign color based on index
    private func setupCardColor(for index: Int) {
        assignedColor = Constants.cardColors[index % Constants.cardColors.count]
        contentView.backgroundColor = assignedColor
    }
    
    private func slideInRandomTextLabel() {
        // Ensure randomTextLabel starts off-screen or hidden
        randomTextLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        randomTextLabel.alpha = 0.0
        
        // Animate in the text label smoothly
        UIView.animate(withDuration: 0.5) {
            self.randomTextLabel.transform = .identity
            self.randomTextLabel.alpha = 1.0
        }
    }

    
    override func prepareForReuse() {  //reset the cell's properties before it's reused.
        super.prepareForReuse() //so it doesn’t show any old data from a previous cell.
        titleLabel.text = nil
        descriptionLabel.text = nil
        contentView.backgroundColor = .clear
        randomTextLabel.transform = .identity
        randomTextLabel.alpha = 0.0
        randomTextLabel.text = nil
    }
}


