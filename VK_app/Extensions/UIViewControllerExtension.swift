//
//  UIViewControllerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func imageFromUrl (url: String) -> UIImage {
        guard let defaultImage = UIImage(named: "deactivated_100") else { return UIImage()}
        guard let imageUrl = URL(string: url) else { return defaultImage}
        guard let data = try? Data(contentsOf: imageUrl) else { return defaultImage }
        guard let image = UIImage(data: data) else { return defaultImage}
        return image
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
