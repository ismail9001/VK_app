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
    @IBOutlet weak var cloud: UIView!
    @IBAction func testAction(_ sender: Any) {
    }
    
    @IBAction func scrollTapped(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    private var shapeLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()

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
        setupStrokePath()
        startAnimation()
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
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    //MARK: - Animations
    
    private func closeLoadingScreen() {
        UIView.animate(withDuration: 0.5, delay: 30, options: .curveEaseOut, animations: {
            self.loadingScreen.alpha = 0
        }, completion: nil)
        //loadingScreen.layer.removeAllAnimations()
    }
    
    func createBezierPath() -> UIBezierPath {
        // create a new path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 7, y: 23))
        path.addLine(to: CGPoint(x: 29, y: 23))
        path.addArc(withCenter: CGPoint(x: 29, y: 16), // center point of circle
                    radius: 7, // this will make it meet our path line
                    startAngle: CGFloat(Double.pi / 2), // 90
                    endAngle: CGFloat(29 * Double.pi  / 18), // 290 degrees = straight up
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        // segment 2: curve
        path.addArc(withCenter: CGPoint(x: 26, y: 10), // center point of circle
                    radius: 5, // this will make it meet our path line
                    startAngle: CGFloat(35 * Double.pi  / 18), // 350π radians = 0 degrees = straight left
                    endAngle: CGFloat(23 * Double.pi  / 18), // 230 radians = 270 degrees = straight up
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        path.addArc(withCenter: CGPoint(x: 15, y: 9), // center point of circle
                    radius: 8, // this will make it meet our path line
                    startAngle: CGFloat(17 * Double.pi / 9), // 340
                    endAngle: CGFloat(17 * Double.pi  / 18), // 170
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        
        path.addArc(withCenter: CGPoint(x: 7, y: 17), // center point of circle
                    radius: 6, // this will make it meet our path line
                    startAngle: CGFloat(3 * Double.pi / 2), //270  degrees = straight left
                    endAngle: CGFloat(Double.pi / 2), // 90 radians = 270 degrees = straight up
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        
        path.close()
        return path
    }
    
    func setupStrokePath() {
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 4.0
        cloud.layer.addSublayer(shapeLayer)
        let path = createBezierPath()
        let scale = CGAffineTransform(scaleX: 2, y: 2)
        path.apply(scale)
        shapeLayer.path = path.cgPath
        
        shapeLayer.position = CGPoint(x: 0, y: 10)
        
    }
    
    func startAnimation() {
        shapeLayer.strokeEnd = 1
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = 2
        strokeStartAnimation.repeatCount = 10
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.3
        strokeEndAnimation.duration = 2
        strokeEndAnimation.repeatCount = 10
        
        shapeLayer.add(strokeStartAnimation, forKey: nil)
        shapeLayer.add(strokeEndAnimation, forKey: nil)
    }
}
