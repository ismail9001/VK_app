//
//  FriendPhotosViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

protocol LikeUpdatingProtocol {
    func likeUnlikeFunc(indexPath: IndexPath)
}

class FriendPhotosViewController: UICollectionViewController, LikeUpdatingProtocol {
    
    var photos : [Photo] = []
    var user : User?
    var userIndexPath: IndexPath = [0,0]
    var delegate : UserUpdatingProtocol?
    func likeUnlikeFunc(indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendPhotosViewCell
        print(delegate)
        photos[indexPath.row].likes = photos[indexPath.row].liked ? photos[indexPath.row].likes - 1 : photos[indexPath.row].likes + 1
        photos[indexPath.row].liked.toggle()
        delegate?.updateUser(photos: photos, userIndexPath: userIndexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Guard сделать
        self.title = user!.name
        photos = user!.photos
        // Uncomment the following line to preserve selection between presentations
        
        // Do any additional setup after loading the view.
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
    
}

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
