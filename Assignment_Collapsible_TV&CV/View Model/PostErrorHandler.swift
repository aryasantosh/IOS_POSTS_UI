//
//  PostErrorHandler.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//

import UIKit

struct PostErrorHandler {
    static func showError(_ message: String) {
        // Implement a universal UI for error display (e.g., Toasts, Snackbars, Alerts)
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            let toastLabel = UILabel(frame: CGRect(x: 20, y: window.frame.height - 100, width: window.frame.width - 40, height: 50))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.alpha = 0.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            
            window.addSubview(toastLabel)
            
            UIView.animate(withDuration: 0.5, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            }
        }
    }
}
