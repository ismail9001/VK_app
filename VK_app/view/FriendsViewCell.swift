//
//  FriendsViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class FriendsViewCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    
    
    var photoImage: UIImageView!
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowColor: CGColor = UIColor.black.cgColor
    @IBInspectable var shadowRadius: CGFloat = 5
    override func awakeFromNib() {
        
        friendPhoto.clipsToBounds = false
        if (self.backgroundColor != .clear) {
            friendPhoto.layer.shadowColor = shadowColor
            friendPhoto.layer.shadowOpacity = shadowOpacity
            friendPhoto.layer.shadowOffset = CGSize.zero
            friendPhoto.layer.shadowRadius = shadowRadius
            friendPhoto.layer.shadowPath = UIBezierPath(roundedRect: friendPhoto.bounds, cornerRadius: friendPhoto.frame.size.width / 2).cgPath
        }
        
        photoImage = UIImageView(frame: friendPhoto.bounds)
        photoImage.layer.cornerRadius = friendPhoto.frame.size.width / 2
        photoImage.clipsToBounds = true
        photoImage.contentMode = .scaleAspectFill
        friendPhoto.addSubview(photoImage)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
