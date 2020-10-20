//
//  GroupSearchViewCell.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupSearchViewCell: UITableViewCell {
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
