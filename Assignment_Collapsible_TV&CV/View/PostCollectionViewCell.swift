import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    //TODO: No need to be static, please refer the medibuddy project
    // Static property to track used random texts and colors
    private static var usedRandomTexts: Set<String> = []
    private static var usedColors: Set<UIColor> = []
    
    private var assignedColor: UIColor?
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    lazy private var descriptionLabel: UILabel = {
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
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true //TODO: Know before you use
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //TODO: seperate functions for respective responsibilities
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        contentView.addSubview(randomTextLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        randomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            randomTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            randomTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            randomTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4), // 50% of contentView's width
            randomTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1) // 10% of contentView's height
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String,
                   description: String,
                   index: Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        // Generate unique random text for each card
        let allRandomTexts = ["Amazing Post", "Interesting", "Breaking News", "Trending Now",
                              "Hot Topic", "Latest Buzz", "Spotlight", "Viral Now", "Big Reveal"] //TODO: Get this from View model, insert it as data source. Always try to create UI Model over API model.
        
        var availableTexts = allRandomTexts.filter { !Self.usedRandomTexts.contains($0) }
        
        // Reset used texts if exhausted
        if availableTexts.isEmpty {
            Self.usedRandomTexts.removeAll()
            availableTexts = allRandomTexts
        }
        
        let randomText = availableTexts.randomElement() ?? "Random Text"
        Self.usedRandomTexts.insert(randomText)
        randomTextLabel.text = randomText
        
        //TODO: Constants for Colors, or you can add in assets all colors.
        // Assign a unique soft color to each card
        let allColors: [UIColor] = [
            UIColor(red: 255/255, green: 239/255, blue: 239/255, alpha: 1.0), // Soft Red
            UIColor(red: 245/255, green: 243/255, blue: 255/255, alpha: 1.0), // Soft Lavender
            UIColor(red: 241/255, green: 255/255, blue: 246/255, alpha: 1.0), // Soft Mint Green
            UIColor(red: 255/255, green: 252/255, blue: 240/255, alpha: 1.0), // Soft Yellow
            UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1.0), // Soft Blue
            UIColor(red: 250/255, green: 240/255, blue: 255/255, alpha: 1.0), // Soft Pink
            UIColor(red: 245/255, green: 255/255, blue: 245/255, alpha: 1.0),  // Soft Light Green
            UIColor(red: 255/255, green: 234/255, blue: 214/255, alpha: 1.0), // Soft Peach
            UIColor(red: 230/255, green: 249/255, blue: 254/255, alpha: 1.0), // Soft Sky Blue
            UIColor(red: 245/255, green: 230/255, blue: 255/255, alpha: 1.0), // Soft Lilac
            UIColor(red: 236/255, green: 255/255, blue: 236/255, alpha: 1.0), // Soft Mint
            UIColor(red: 255/255, green: 250/255, blue: 255/255, alpha: 1.0), // Soft Lavender Blush
            UIColor(red: 255/255, green: 255/255, blue: 210/255, alpha: 1.0), // Soft Butter Yellow
            UIColor(red: 235/255, green: 245/255, blue: 255/255, alpha: 1.0), // Soft Powder Blue
            UIColor(red: 240/255, green: 240/255, blue: 255/255, alpha: 1.0), // Soft Periwinkle
            UIColor(red: 255/255, green: 239/255, blue: 227/255, alpha: 1.0), // Soft Coral
        ]
        
        // Ensure each color is unique per card
        let randomColor = allColors[index % allColors.count]
        contentView.backgroundColor = randomColor
        
        // Animate the randomTextLabel
        slideInRandomTextLabel()
    }
    
    private func slideInRandomTextLabel() {
        randomTextLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        randomTextLabel.alpha = 0.0

        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut, animations: {
            self.randomTextLabel.transform = .identity
            self.randomTextLabel.alpha = 1.0
        }, completion: { _ in
            print("Animation completed") // Debugging check
        })
    }
}


//import UIKit
//
//class PostCollectionViewCell: UICollectionViewCell {
//    static let identifier = "PostCollectionViewCell"
//    
//    // Static property to track used random texts and colors
//    private static var usedRandomTexts: Set<String> = []
//    private static var usedColors: Set<UIColor> = []
//    
//    lazy private var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.numberOfLines = 3
//        label.textAlignment = .left
//        label.textColor = .black
//        return label
//    }()
//    
//    lazy private var descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.numberOfLines = 6
//        label.textColor = .darkGray
//        label.textAlignment = .justified
//        return label
//    }()
//    
//    private let randomTextLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .white
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        label.layer.cornerRadius = 5
//        label.layer.masksToBounds = true
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        contentView.layer.cornerRadius = 12
//        contentView.layer.masksToBounds = true
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 0.1
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        contentView.layer.shadowRadius = 6
//        
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        stackView.alignment = .leading
//        
//        contentView.addSubview(stackView)
//        contentView.addSubview(randomTextLabel) // Add random text label
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        randomTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
//            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
//            
//            randomTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            randomTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            randomTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5), // 50% of contentView's width
//            randomTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1) // 10% of contentView's height
//
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with title: String, description: String) {
//        titleLabel.text = title
//        descriptionLabel.text = description
//        
//        // Generate unique random text for each card
//        let allRandomTexts = ["Amazing Post", "Interesting", "Breaking News", "Trending Now",
//                              "Hot Topic", "Latest Buzz", "Spotlight", "Viral Now", "Big Reveal"]
//        
//        var availableTexts = allRandomTexts.filter { !Self.usedRandomTexts.contains($0) }
//        
//        // Reset used texts if exhausted
//        if availableTexts.isEmpty {
//            Self.usedRandomTexts.removeAll()
//            availableTexts = allRandomTexts
//        }
//        
//        let randomText = availableTexts.randomElement() ?? "Random Text"
//        Self.usedRandomTexts.insert(randomText)
//        randomTextLabel.text = randomText
//        
//        // Assign unique soft color to each card
//        let allColors: [UIColor] = [
//            UIColor(red: 255/255, green: 239/255, blue: 239/255, alpha: 1.0), // Soft Red
//            UIColor(red: 245/255, green: 243/255, blue: 255/255, alpha: 1.0), // Soft Lavender
//            UIColor(red: 241/255, green: 255/255, blue: 246/255, alpha: 1.0), // Soft Mint Green
//            UIColor(red: 255/255, green: 252/255, blue: 240/255, alpha: 1.0), // Soft Yellow
//            UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1.0), // Soft Blue
//            UIColor(red: 250/255, green: 240/255, blue: 255/255, alpha: 1.0), // Soft Pink
//            UIColor(red: 245/255, green: 255/255, blue: 245/255, alpha: 1.0)  // Soft Light Green
//        ]
//        
//        var availableColors = allColors.filter { !Self.usedColors.contains($0) }
//        
//        // Reset used colors if exhausted
//        if availableColors.isEmpty {
//            Self.usedColors.removeAll()
//            availableColors = allColors
//        }
//        
//        let randomColor = availableColors.randomElement() ?? UIColor.systemGray
//        Self.usedColors.insert(randomColor)
//        contentView.backgroundColor = randomColor
//        
//        // Animate the randomTextLabel
//        slideInRandomTextLabel()
//    }
//    
//    private func slideInRandomTextLabel() {
//        randomTextLabel.transform = CGAffineTransform(translationX: 300, y: 0)
//        randomTextLabel.alpha = 0.0
//
//        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut, animations: {
//            self.randomTextLabel.transform = .identity
//            self.randomTextLabel.alpha = 1.0
//        }, completion: { _ in
//            print("Animation completed") // Debugging check
//        })
//    }
//}
