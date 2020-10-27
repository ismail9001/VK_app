//
//  Likes.swift
//  VK_app
//
//  Created by macbook on 22.10.2020.
//
import UIKit

class LikeHeart: UIControl {
    
    // MARK: - Views
    var likeCount: UILabel = {
        let label = UILabel()
        return label
    }()
    var likeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Delegates
    var delegate: LikeUpdatingProtocol?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        likeCount.frame = bounds
        likeButton.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [likeCount, likeButton])
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
    //вопрос преподавателю - как иначе вытащить порядок ячейки
    private func getIndexPath() -> IndexPath? {
        guard let superView = self.superview?.superview?.superview as? UICollectionView else {
            print("superview is not a cell")
            return nil
        }
        let indexPath = superView.indexPath(for: self.superview?.superview as! UICollectionViewCell )
        return indexPath
    }
    @objc private func likeTap(_ sender: UIView) {
        if let indexPath = getIndexPath()
        {
            delegate?.likeUnlikeFunc(indexPath: indexPath)
        }
    }
}
