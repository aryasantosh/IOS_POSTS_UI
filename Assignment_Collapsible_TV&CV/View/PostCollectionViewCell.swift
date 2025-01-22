import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    // Static property to track used random texts
    private static var usedRandomTexts: Set<String> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 6
        label.textColor = .darkGray
        label.textAlignment = .justified
        return label
    }()
    
    private let randomTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8 // Adjusted for proper spacing
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        contentView.addSubview(randomTextLabel) // Add random text label
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        randomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40), // Moved down for better alignment
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            randomTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            randomTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            randomTextLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100), // Dynamic width
            randomTextLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        // Generate unique random text for each card
        let allRandomTexts = ["Amazing Post", "Interesting", "Breaking News", "Trending Now",
                              "Hot Topic", "Latest Buzz", "Spotlight", "Viral Now", "Big Reveal"]
        
        var availableTexts = allRandomTexts.filter { !Self.usedRandomTexts.contains($0) }
        
        // Reset used texts if exhausted
        if availableTexts.isEmpty {
            Self.usedRandomTexts.removeAll()
            availableTexts = allRandomTexts
        }
        
        let randomText = availableTexts.randomElement() ?? "Random Text"
        Self.usedRandomTexts.insert(randomText)
        randomTextLabel.text = randomText
        
        // Animate the randomTextLabel
        slideInRandomTextLabel()
    }
    
    private func slideInRandomTextLabel() {
            // Initially position the randomTextLabel off-screen to the right and make it invisible
            randomTextLabel.transform = CGAffineTransform(translationX: 300, y: 0)
            randomTextLabel.alpha = 0.0

            // Animate it to its original position with a slight delay for smooth sliding
            UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut, animations: {
                // Apply transformation only to the randomTextLabel
                self.randomTextLabel.transform = .identity
                self.randomTextLabel.alpha = 1.0
            }, completion: { _ in
                print("Animation completed") // Debugging check
            })
        }
}
