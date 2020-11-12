//
//  FriendPhotosViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

protocol LikeUpdatingProtocol: class {
    func likeUnlikeFunc(indexPath: IndexPath)
}

class FriendPhotosViewController: UICollectionViewController, LikeUpdatingProtocol {
    
    var photos : [Photo] = []
    var user : User?
    var delegate : UserUpdatingProtocol?
    let screenSize: CGRect = UIScreen.main.bounds
    
    var sliderCenterImage: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderLeftImage: UIImageView = {
        let image = UIImageView()
        let view = UIView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderRightImage: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderLeftView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = -1 * view.frame.maxX
        return view
    }()
    
    var sliderRightView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = view.frame.maxX
        return view
    }()
    
    var animator: UIViewPropertyAnimator!
    
    func likeUnlikeFunc(indexPath: IndexPath) {
        photos[indexPath.row].likes = photos[indexPath.row].liked ? photos[indexPath.row].likes - 1 : photos[indexPath.row].likes + 1
        photos[indexPath.row].liked.toggle()
        delegate?.updateUser(photos: photos, id: user?.id ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Guard сделать
        self.title = user!.name
        photos = user!.photos
    }
    
    // MARK: - Navigation
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendPhotosViewCell
        cell.friendPhoto.image = UIImage(named: photos[indexPath.row].photo)
        cell.photoLike.liked = photos[indexPath.row].liked
        cell.photoLike.likeCount = photos[indexPath.row].likes
        cell.photoLike.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
        self.imageTapped(image: cell.friendPhoto.image!, indexPath.row)
    }
    
    //MARK: -SLIDER
    func imageTapped(image:UIImage, _ index: Int){
        
        sliderCenterImage.image = image
        sliderCenterImage.tag = index
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        sliderCenterImage.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panSlider(_:)))
        sliderCenterImage.addGestureRecognizer(pan)
        sliderRightView.addSubview(sliderRightImage)
        sliderLeftView.addSubview(sliderLeftImage)
        
        self.view.addSubview(sliderLeftView)
        self.view.addSubview(sliderRightView)
        self.view.addSubview(sliderCenterImage)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func panSlider(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        switch gesture.horizontalDirection(sliderCenterImage) {
        case .Left:
            let positions = nearElements(index: sliderCenterImage.tag)
            sliderRightImage.image = UIImage(named: photos[positions[2]].photo)
            sliderLeftImage.image = UIImage(named: photos[positions[0]].photo)
        case .Right:
            let positions = nearElements(index: sliderCenterImage.tag)
            sliderRightImage.image = UIImage(named: photos[positions[2]].photo)
            sliderLeftImage.image = UIImage(named: photos[positions[0]].photo)
        default:
            return
        }
        switch gesture.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
            if gesture.horizontalDirection(sliderCenterImage) == .Left{
                animator.addAnimations {
                    self.sliderCenterImage.center.x -= self.sliderCenterImage.frame.size.width
                    self.sliderRightView.center.x -= self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterImage.center.x += self.sliderCenterImage.frame.size.width
                    self.sliderRightView.center.x += self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.sliderCenterImage.image = self.sliderRightImage.image
                }
            }
            if gesture.horizontalDirection(sliderCenterImage) == .Right{
                animator.addAnimations {
                    self.sliderCenterImage.center.x += self.sliderCenterImage.frame.size.width
                    self.sliderLeftView.center.x += self.sliderLeftView.frame.size.width
                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterImage.center.x -= self.sliderCenterImage.frame.size.width
                    self.sliderLeftView.center.x -= self.sliderLeftView.frame.size.width
                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.sliderCenterImage.image = self.sliderLeftImage.image
                }
            }
            animator.pauseAnimation()
        case .changed:
            animator.fractionComplete =  abs(translation.x / self.view.frame.width)
        case .ended:
            if animator.fractionComplete > 0.5 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                if gesture.horizontalDirection(sliderCenterImage) == .Left{
                    if sliderCenterImage.tag == photos.count - 1{
                        sliderCenterImage.tag = 0
                    } else  {
                        sliderCenterImage.tag += 1
                    }
                }
                if gesture.horizontalDirection(sliderCenterImage) == .Right{
                    if sliderCenterImage.tag == 0{
                        sliderCenterImage.tag = photos.count - 1
                    } else  {
                        sliderCenterImage.tag -= 1
                    }
                }
            }
            else {
                animator.stopAnimation(true)
                if (translation.x < 0){
                    UIView.animateKeyframes(withDuration: 1,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderCenterImage.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5 ,
                                                                   animations: {
                                                                    self.sliderRightView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                                                   })
                                            })
                } else {
                    UIView.animateKeyframes(withDuration: 1,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderCenterImage.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5 ,
                                                                   animations: {
                                                                    self.sliderLeftView.center.x -= translation.x
                                                                   })
                                                UIView.addKeyframe(withRelativeStartTime: 0,
                                                                   relativeDuration: 0.5,
                                                                   animations: {
                                                                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                                                   })
                                            })
                }
            }
        default:
            return
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func nearElements (index: Int) -> [Int]{
        let array = photos
        if array.count == 1 {return [0, 0, 0]}
        if array.count == 2 {
            if index == 0 {
                return [1, index, 1]
            }
            return [0, index, 0]
        }
        if (array.count >= 3) {
            if index == 0 {
                return [array.count - 1, index, 1]
            } else if (index == array.count - 1) {
                return [array.count - 2, index, 0]
            } else {
                return [index - 1, index, index + 1]
            }
        }
        return []
    }
    
    func updateImageSlider(_ image: UIImage) {
        sliderCenterImage.image = image
        sliderCenterImage.frame.origin.x = 0
    }
    
    //MARK: - Animation
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellAnimationCalculate(cell)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let arr = self.collectionView.indexPathsForVisibleItems
        for indexPath in arr{
            guard let cell = self.collectionView.cellForItem(at: indexPath) else {return}
            cellAnimationCalculate(cell)
        }
    }
    
    func cellAnimationCalculate (_ cell: UICollectionViewCell) {
        let pos = self.collectionView.convert(cell.frame, to: self.view)
        let screenSize: CGRect = UIScreen.main.bounds
        var alpha: CGFloat = 0
        if (pos.origin.y < cell.frame.height) {
            alpha = pos.origin.y / cell.frame.height
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        } else
        if (pos.origin.y > screenSize.maxY - 2 * cell.frame.height) {
            alpha = 1 - ((pos.origin.y - (screenSize.maxY - 2 * cell.frame.height)) / cell.frame.height)
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        }
    }
}

//MARK: - Extensions

extension FriendPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    // Get current vertical direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func verticalDirection(_ target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    // Get current horizontal direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func horizontalDirection(_ target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    // Get a tuple for current horizontal/vertical direction
    //
    // - Parameter target: view target
    // - Returns: current direction
    func versus(_ target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(_: target), self.verticalDirection(_: target))
    }
}
