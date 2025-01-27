//
//  DropDownView.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//

import UIKit

class DropdownView: UIView {
    init(options: [(String, UIImage?)], action: @escaping (String) -> Void) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        var previousStackView: UIStackView?
        
        for (text, image) in options {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            
            if let image = image {
                let imageView = UIImageView(image: image)
                imageView.tintColor = .label
                imageView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 20),
                    imageView.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
            
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .label
            stackView.addArrangedSubview(label)
            
            stackView.isUserInteractionEnabled = true
            stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                stackView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let previous = previousStackView {
                stackView.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
            }
            
            previousStackView = stackView
        }
        
        previousStackView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView,
              let label = stackView.arrangedSubviews.compactMap({ $0 as? UILabel }).first else { return }
        print("Option selected: \(label.text ?? "")")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
