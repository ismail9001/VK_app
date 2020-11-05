//
//  FriendsViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class FriendsViewCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: Avatar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
