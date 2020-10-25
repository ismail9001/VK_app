//
//  Likes.swift
//  VK_app
//
//  Created by macbook on 22.10.2020.
//
import UIKit

class LikeHeart: UIControl {
    // MARK: - Views
    var likeCount = UILabel()
    var button = UIButton(type: UIButton.ButtonType.custom)
    
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
        likeCount.frame = bounds
        button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [likeCount, button])
        stackView.spacing = 1
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.frame = bounds
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        stackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(stackView)
        backgroundColor = .white
    }
    
    @objc private func likeTap(_ sender: UIView) {
        //обрабатываю нажатие без изменения самих данных - ЗДЕСЬ СОСТОИТ САМА ПРОБЛЕМА
        if (self.likeCount.text == "0") {
            self.likeCount.textColor = .red
            self.likeCount.text = "1"
            self.button.setImage( UIImage(systemName: "heart.fill"), for: .normal)
            self.button.tintColor = .red
        } else {
            self.likeCount.textColor = .gray
            self.likeCount.text = "0"
            self.button.setImage( UIImage(systemName: "heart"), for: .normal)
            self.button.tintColor = .gray
        }
        print(#function)
    }
}
