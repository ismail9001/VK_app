//
//  Likes.swift
//  VK_app
//
//  Created by macbook on 22.10.2020.
//
import UIKit

@IBDesignable
class Avatar: UIView {
    
    // MARK: - Views
    @IBInspectable
    var shadowRadius: CGFloat = 5 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.5 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    var avatarPhoto: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var avatarShadow: UIView = {
        let shadow = UIView()
        shadow.clipsToBounds = false
        shadow.translatesAutoresizingMaskIntoConstraints = false
        return shadow
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        self.addSubview(avatarShadow)
        self.addSubview(avatarPhoto)
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            avatarShadow.topAnchor.constraint(equalTo: topAnchor),
            avatarShadow.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarShadow.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarShadow.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarPhoto.topAnchor.constraint(equalTo: topAnchor),
            avatarPhoto.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarPhoto.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarPhoto.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    //запускается после инициализации констрейтов
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarShadow.layer.shadowPath = UIBezierPath(roundedRect: avatarPhoto.bounds, cornerRadius: avatarPhoto.frame.size.width / 2).cgPath
        avatarShadow.layer.shadowOffset = CGSize.zero
        avatarPhoto.layer.cornerRadius = avatarPhoto.frame.width / 2
    }
    
    private func updateShadow(){
        avatarShadow.layer.shadowRadius = shadowRadius
        avatarShadow.layer.shadowColor = shadowColor
        avatarShadow.layer.shadowOpacity = shadowOpacity
    }
    
    private func updateImage(){
        avatarPhoto.image = image
        setNeedsDisplay()
    }
}
