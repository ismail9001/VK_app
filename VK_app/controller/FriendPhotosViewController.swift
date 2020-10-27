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
    var delegate : UserUpdatingProtocol?
    func likeUnlikeFunc(indexPath: IndexPath) {
        //Оптимизировать
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendPhotosViewCell
        delegate?.printtext(text: "kkj")
        
        photos[indexPath.row].likes = photos[indexPath.row].liked ? photos[indexPath.row].likes - 1 : photos[indexPath.row].likes + 1
        photos[indexPath.row].liked.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        delegate?.printtext(text: "8888")
        guard let controller = segue.destination as? FriendsViewController
        else {
            delegate?.printtext(text: "0000")
            return }
        delegate?.printtext(text: "9999")
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
        //cell.photoLike.delegate = self
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
