//
//  Likes.swift
//  VK_app
//
//  Created by macbook on 22.10.2020.
//
import UIKit

@IBDesignable
class LikeHeart: UIControl {
    
    private var color: UIColor = .gray {
        didSet{
            likeCountLabel.textColor = color
            likeButton.tintColor = color
        }
    }
    
    var liked: Bool = false {
        didSet {
            updateLike()
        }
    }
    
    var likeCount: Int = 0 {
        didSet {
            UIView.transition(with: likeCountLabel, duration: 0.25, options: [.curveEaseInOut, .transitionFlipFromLeft], animations: {
                self.likeCountLabel.text = "\(self.likeCount)"
            }, completion: nil)
        }
    }
    
    // MARK: - Views
    var likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "0"
        return label
    }()
    var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        return button
    }()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        return  stackView
    }()
    
    // MARK: - Delegates
    weak var delegate: LikeUpdatingProtocol?
    
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
        addSubview(stackView)
        stackView.addArrangedSubview(getGroupedViews([likeCountLabel, likeButton]))
        backgroundColor = .white
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateLike() {
        color = liked ? .red : .gray
        likeButton.setImage(liked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeCount = liked ? likeCount + 1 : likeCount - 1
    }
    //ВОПРОС - как иначе вытащить порядок ячейки? передавать ее изначально в этот вью?
    private func getIndexPath() -> IndexPath? {
        guard let superView = self.superview?.superview?.superview as? UICollectionView else {
            print("superview is not a cell")
            return nil
        }
        let indexPath = superView.indexPath(for: self.superview?.superview as! UICollectionViewCell )
        return indexPath
    }
    
    func getGroupedViews (_ views: [UIView])-> UIView{
        let stackView = UIStackView()
        stackView.spacing = 4
        for uiview in views {
            stackView.addArrangedSubview(uiview)
        }
        return stackView
    }
    //MARK: - Actions
    @objc private func likeTap(_ sender: UIView) {
        liked.toggle()
        if let indexPath = getIndexPath()
        {
            delegate?.likeUnlikeFunc(indexPath: indexPath)
        }
    }
    
    //MARK: - Animation

}
