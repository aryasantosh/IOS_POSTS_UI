//
//  Constants.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//

import UIKit

struct Constants {
    // Random Texts
    static let randomTexts = [
        "Amazing Post", "Interesting", "Breaking News", "Trending Now",
        "Hot Topic", "Latest Buzz", "Spotlight", "Viral Now", "Big Reveal"
    ]
    
    static let heartFilled = "heart.fill"
    static let heartEmpty = "heart"
    
    
    // Card Colors
    static let cardColors: [UIColor] = [
        UIColor(red: 255/255, green: 239/255, blue: 239/255, alpha: 1.0),
        UIColor(red: 245/255, green: 243/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 241/255, green: 255/255, blue: 246/255, alpha: 1.0),
        UIColor(red: 255/255, green: 252/255, blue: 240/255, alpha: 1.0),
        UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 250/255, green: 240/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 245/255, green: 255/255, blue: 245/255, alpha: 1.0),
        UIColor(red: 255/255, green: 234/255, blue: 214/255, alpha: 1.0),
        UIColor(red: 230/255, green: 249/255, blue: 254/255, alpha: 1.0),
        UIColor(red: 245/255, green: 230/255, blue: 255/255, alpha: 1.0)
    ]
    
    // Fonts
    static let titleLabelFont = UIFont.boldSystemFont(ofSize: 14)
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 12)
    static let randomTextLabelFont = UIFont.systemFont(ofSize: 14)
    
    // Spacing and Padding
    static let stackViewPadding: CGFloat = 16
    static let randomTextLabelWidthMultiplier: CGFloat = 0.4
    static let randomTextLabelHeightMultiplier: CGFloat = 0.1
    static let stackViewSpacing: CGFloat = 8
    static let randomTextLabelCornerRadius: CGFloat = 5
    static let randomTextLabelAlpha: CGFloat = 0.5
    static let contentViewCornerRadius: CGFloat = 12
    static let shadowOpacity: Float = 0.1
    static let shadowRadius: CGFloat = 6
}

