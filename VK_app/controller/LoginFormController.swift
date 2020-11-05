//
//  LoginFormController.swift
//  VK_app
//
//  Created by macbook on 11.10.2020.
//

import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var circle3: UIImageView!
    
    @IBAction func testAction(_ sender: Any) {
    }
    
    @IBAction func scrollTapped(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    // MARK: - Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if loginCheck() == false {
            showError("Ошибка", "Неверные данные пользователя")
            return false
        } else {
            return true
        }
    }
    func loginCheck() -> Bool{
        //let login = usernameInput.text!
        //let password = passwordInput.text!
        
        let login = "admin"
        let password = "123456"
        
        return login == "admin" && password == "123456"
    }
    
    func showError(_ errorTitle: String, _ errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeLoadingScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - keyboard events
    // Когда клавиатура появляется
    @objc func keyboardWillShow(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillHide(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }

    //MARK: - Animations
    
    private func closeLoadingScreen() {
        UIView.animate(withDuration: 0.9, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.circle1.alpha = 0.1
        })
        UIView.animate(withDuration: 0.9, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            self.circle2.alpha = 0.1
        })
        UIView.animate(withDuration: 0.9, delay: 0.6, options: [.repeat, .autoreverse], animations: {
            self.circle3.alpha = 0.1
        })
       UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseOut, animations: {
            self.loadingScreen.alpha = 0
        }, completion: nil)
        //loadingScreen.layer.removeAllAnimations()
    }
}
