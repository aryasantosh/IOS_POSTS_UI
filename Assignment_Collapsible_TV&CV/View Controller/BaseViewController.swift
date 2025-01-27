//
//  BaseViewController.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//

import UIKit

class BaseViewController: UIViewController {
    func setupNavigationBar(withTitle title: String, withDropdown: Bool = false, dropdownAction: Selector? = nil) {
        let titleButton = UIButton(type: .system)
        titleButton.setTitle(title, for: .normal)
        if withDropdown {
            titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            titleButton.semanticContentAttribute = .forceRightToLeft
            titleButton.addTarget(self, action: dropdownAction ?? #selector(didTapDropdown), for: .touchUpInside)
        }
        titleButton.tintColor = .label
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        navigationItem.titleView = titleButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func didTapDropdown() {
        print("Override this method in child view controllers to handle dropdown action.")
    }
}

//import UIKit
//
//class BaseViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigationBar()
//        view.backgroundColor = .systemBackground // Support for light and dark themes
//    }
//
//    private func setupNavigationBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.tintColor = .systemBlue
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .systemBackground
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    }
//}
