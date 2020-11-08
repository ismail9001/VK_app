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
    var currentImage = 0
    
    var imagesSliderCenterView: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var imagesSliderLeftView: UIImageView = {
        let image = UIImageView()
        let view = UIView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var imagesSliderRightView: UIImageView = {
        let image = UIImageView()
        image.frame = UIScreen.main.bounds
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var leftView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = -1 * view.frame.maxX
        return view
    }()

    var rightView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black
        view.frame.origin.x = view.frame.maxX
        return view
    }()
    
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
        
        imagesSliderCenterView.image = image
        imagesSliderCenterView.tag = index
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        imagesSliderCenterView.addGestureRecognizer(tap)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        imagesSliderCenterView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        imagesSliderCenterView.addGestureRecognizer(swipeLeft)
        
        rightView.addSubview(imagesSliderRightView)
        leftView.addSubview(imagesSliderLeftView)
        
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        self.view.addSubview(imagesSliderCenterView)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {

        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            if imagesSliderCenterView.tag == photos.count - 1 {
                imagesSliderCenterView.tag = 0
                let positions = nearElements(index: imagesSliderCenterView.tag)
                imagesSliderRightView.image = UIImage(named: photos[positions[2]].photo)
                imagesSliderLeftView.image = UIImage(named: photos[positions[0]].photo)
                UIView.animateKeyframes(withDuration: 1,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderCenterView.center.x -= self.imagesSliderCenterView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5 ,
                                                               animations: {
                                                                self.rightView.center.x -= self.rightView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderRightView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                               })
                                        
                                        },
                                        completion: {_ in
                                            self.imagesSliderCenterView.center.x += self.imagesSliderCenterView.frame.size.width
                                            self.rightView.center.x += self.rightView.frame.size.width
                                            self.imagesSliderRightView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                            self.updateImageSlider(self.imagesSliderRightView.image!)
                                        })
            }else{
                let positions = nearElements(index: imagesSliderCenterView.tag)
                imagesSliderRightView.image = UIImage(named: photos[positions[2]].photo)
                imagesSliderLeftView.image = UIImage(named: photos[positions[0]].photo)
                UIView.animateKeyframes(withDuration: 1,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderCenterView.center.x -= self.imagesSliderCenterView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.rightView.center.x -= self.rightView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderRightView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                               })
                                        },
                                        completion: {_ in
                                            self.imagesSliderCenterView.center.x += self.imagesSliderCenterView.frame.size.width
                                            self.rightView.center.x += self.rightView.frame.size.width
                                            self.imagesSliderRightView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                            self.updateImageSlider(self.imagesSliderRightView.image!)
                                        })
                imagesSliderCenterView.tag += 1
            }
            
        case UISwipeGestureRecognizer.Direction.right:
            if imagesSliderCenterView.tag == 0 {
                imagesSliderCenterView.tag = photos.count - 1
                let positions = nearElements(index: imagesSliderCenterView.tag)
                imagesSliderRightView.image = UIImage(named: photos[positions[2]].photo)
                imagesSliderLeftView.image = UIImage(named: photos[positions[0]].photo)
                UIView.animateKeyframes(withDuration: 1,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderCenterView.center.x += self.imagesSliderCenterView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.leftView.center.x += self.leftView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderLeftView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                               })
                                        },
                                        completion: {_ in
                                            self.imagesSliderCenterView.center.x -= self.imagesSliderCenterView.frame.size.width
                                            self.leftView.center.x -= self.leftView.frame.size.width
                                            self.imagesSliderLeftView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                            self.updateImageSlider(self.imagesSliderLeftView.image!)
                                        })
            }else{
                let positions = nearElements(index: imagesSliderCenterView.tag)
                imagesSliderRightView.image = UIImage(named: photos[positions[2]].photo)
                imagesSliderLeftView.image = UIImage(named: photos[positions[0]].photo)
                UIView.animateKeyframes(withDuration: 1,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderCenterView.center.x += self.imagesSliderCenterView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.leftView.center.x += self.leftView.frame.size.width
                                                               })
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 0.5,
                                                               animations: {
                                                                self.imagesSliderLeftView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                               })
                                        },
                                        completion: {_ in
                                            self.imagesSliderCenterView.center.x -= self.imagesSliderCenterView.frame.size.width
                                            self.leftView.center.x -= self.leftView.frame.size.width
                                            self.imagesSliderLeftView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                            self.updateImageSlider(self.imagesSliderLeftView.image!)
                                        })
                imagesSliderCenterView.tag -= 1
            }
        default:
            break
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
        imagesSliderCenterView.image = image
        imagesSliderCenterView.frame.origin.x = 0
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
