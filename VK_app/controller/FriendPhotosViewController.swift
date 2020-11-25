//
//  FriendPhotosViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

protocol LikeUpdatingDelegate: class {
    func likeUnlikeFunc(indexPath: IndexPath)
}

class FriendPhotosViewController: UICollectionViewController, LikeUpdatingDelegate {
    
    let cellIndent: CGFloat = 20
    var photos : [Photo] = []
    var user : User?
    weak var delegate : UserUpdatingDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    
    var sliderCenterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var sliderCenterView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    var sliderLeftImage: UIImageView = {
        let image = UIImageView()
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
    
    let friendsPhotosService = FriendsPhotosService()
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProperty = user else { return }
        self.title = userProperty.name
        photos = userProperty.photos
        friendsPhotosService.getFriendsPhotosList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        sliderLeftView.removeFromSuperview()
        sliderRightView.removeFromSuperview()
    }
    
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
        self.imageTapped(cell, indexPath)
    }
    
    //MARK: - Slider
    
    func imageTapped( _ cell: FriendPhotosViewCell, _ indexPath: IndexPath){
        
        guard let rectOfCellInTableView = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let rectOfCellInSuperview = collectionView.convert(rectOfCellInTableView.frame, to: collectionView.superview)
        sliderCenterImage.image = cell.friendPhoto.image
        sliderCenterView.tag = indexPath.row
        sliderCenterView.frame = CGRect(x: rectOfCellInSuperview.minX, y: rectOfCellInSuperview.minY, width: rectOfCellInSuperview.width, height: rectOfCellInSuperview.height)
        sliderCenterView.addSubview(sliderCenterImage)
        sliderCenterView.layer.masksToBounds = true

        
        sliderCenterImage.frame = imageRectPos(rectOfCellInTableView, rectOfCellInSuperview)
        sliderCenterView.alpha = cell.alpha
        cell.alpha = 0
        
        //переделать на swipe вниз
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        sliderCenterView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panSlider(_:)))
        sliderCenterView.addGestureRecognizer(pan)
        self.view.addSubview(sliderCenterView)
        //UIApplication.shared.windows.first?.layer.speed = 0.1
        UIView.animateKeyframes(withDuration: 0.4,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.sliderCenterView.alpha = 1
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4 ,
                                                       animations: { [self] in
                                                        sliderCenterView.frame = screenSize
                                                        sliderCenterImage.frame = screenSize
                                                        sliderCenterView.backgroundColor = .black
                                                       })
                                })
        sliderRightView.addSubview(sliderRightImage)
        sliderLeftView.addSubview(sliderLeftImage)
        
        self.view.addSubview(sliderLeftView)
        self.view.addSubview(sliderRightView)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func panSlider(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        let positions = nearElements(index: sliderCenterView.tag)
        sliderRightImage.image = UIImage(named: photos[positions[2]].photo)
        sliderLeftImage.image = UIImage(named: photos[positions[0]].photo)
        
        switch gesture.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
            if gesture.horizontalDirection(sliderCenterView) == .Left{
                animator.addAnimations {
                    self.sliderCenterView.center.x -= self.sliderCenterView.frame.size.width
                    self.sliderRightView.center.x -= self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterView.center.x += self.sliderCenterView.frame.size.width
                    self.sliderRightView.center.x += self.sliderRightView.frame.size.width
                    self.sliderRightImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.sliderCenterImage.image = self.sliderRightImage.image
                }
            }
            if gesture.horizontalDirection(sliderCenterView) == .Right{
                animator.addAnimations {
                    self.sliderCenterView.center.x += self.sliderCenterView.frame.size.width
                    self.sliderLeftView.center.x += self.sliderLeftView.frame.size.width
                    self.sliderLeftImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                animator.addCompletion { _ in
                    self.sliderCenterView.center.x -= self.sliderCenterView.frame.size.width
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
                let indexPath = IndexPath(row: sliderCenterView.tag, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
                cellAnimationCalculate(cell)
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                if gesture.horizontalDirection(sliderCenterView) == .Left{
                    if sliderCenterView.tag == photos.count - 1{
                        sliderCenterView.tag = 0
                    } else  {
                        sliderCenterView.tag += 1
                    }
                }
                if gesture.horizontalDirection(sliderCenterView) == .Right{
                    if sliderCenterView.tag == 0{
                        sliderCenterView.tag = photos.count - 1
                    } else  {
                        sliderCenterView.tag -= 1
                    }
                }
                collectionView.scrollToItem(at: IndexPath(row: sliderCenterView.tag, section: 0), at: .centeredVertically, animated: true)
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
                                                                    self.sliderCenterView.center.x -= translation.x
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
                                                                    self.sliderCenterView.center.x -= translation.x
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
        
        guard let centerView = sender.view else { return }
        let indexPath = IndexPath(row: centerView.tag, section: 0)
        guard let rectOfCellInTableView = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let rectOfCellInSuperview = collectionView.convert(rectOfCellInTableView.frame, to: collectionView.superview)
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotosViewCell
        cellAnimationCalculate(cell)
        UIView.animateKeyframes(withDuration: 0.4,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.sliderCenterView.alpha = 0
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.4 ,
                                                       animations: { [self] in
                                                        sliderCenterView.frame = rectOfCellInSuperview
                                                        sliderCenterImage.frame = imageRectPos(rectOfCellInTableView, rectOfCellInSuperview)
                                                        sliderCenterImage.backgroundColor = .clear
                                                       })
                                }, completion: { _ in
                                    sender.view?.removeFromSuperview()
                                })
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
    
    //MARK: - Functions
    
    //расчет области отображения ImageView на месте расположения ячейки
    func imageRectPos(_ cellRect: UICollectionViewLayoutAttributes, _ frameRect: CGRect) -> CGRect {
        
        var width: CGFloat = frameRect.width
        var height: CGFloat = frameRect.height
        var x: CGFloat = 0
        var y: CGFloat = 0
        guard let image = sliderCenterImage.image else { return CGRect(x: x, y: y, width: width, height: height)}
        
        if image.size.height / image.size.width > 1 {
            height = (frameRect.width / image.size.width) * image.size.height
            y = (frameRect.height - height) / 2
        } else if image.size.height / image.size.width != 1 {
            width = (frameRect.height / image.size.height)  * image.size.width
            x = (frameRect.width - width) / 2
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    //расчет альфа канала в зависимости от положения ячейки на экране
    func cellAnimationCalculate (_ cell: UICollectionViewCell) {
        let pos = self.collectionView.convert(cell.frame, to: self.view)
        var alpha: CGFloat = 0
        if (pos.origin.y < cell.frame.height) {
            alpha = pos.origin.y / cell.frame.height
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        } else if (pos.origin.y > screenSize.maxY - 2 * cell.frame.height) {
            alpha = 1 - ((pos.origin.y - (screenSize.maxY - 2 * cell.frame.height)) / cell.frame.height)
            alpha = alpha < 0 ? 0 : alpha
            cell.alpha = alpha
        } else {
            cell.alpha = 1
        }
    }
    //расчет поведения лайка
    func likeUnlikeFunc(indexPath: IndexPath) {
        photos[indexPath.row].likes = photos[indexPath.row].liked ? photos[indexPath.row].likes - 1 : photos[indexPath.row].likes + 1
        photos[indexPath.row].liked.toggle()
        delegate?.updateUser(photos: photos, id: user?.id ?? 0)
    }
    //расчет изображений слайдера
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
    
    //обновляем свойства центрального экрана слайдера
    func updateImageSlider(_ image: UIImage) {
        sliderCenterImage.image = image
        sliderCenterView.frame.origin.x = 0
    }
}
//MARK: - Extensions

extension FriendPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = cellIndent * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellIndent, left: cellIndent, bottom: cellIndent, right: cellIndent)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellIndent
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
