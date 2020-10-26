//
//  FriendsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

protocol UserUpdatingProtocol {
    func printtext(text: String)
}
class FriendsViewController: UITableViewController, UserUpdatingProtocol {
    
    let users = User.manyUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func printtext(text: String) {
        print("text")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsViewCell
        let user = users[indexPath.row]
        cell.friendName.text = user.name
        cell.photoImage.image = UIImage(named: user.photo)
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendPhotosViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        controller.title = users[indexPath.row].name
        controller.photos = users[indexPath.row].photos
        controller.delegate = self
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func updateUser(segue: UIStoryboardSegue) {
        print("77777")
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "updateUser" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let friendPhotosViewController = segue.source as! FriendPhotosViewController
            print("777")
        }
    }
}
