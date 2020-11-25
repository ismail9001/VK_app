//
//  FriendsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

protocol UserUpdatingDelegate: class {
    func updateUser(photos: [Photo], id: Int)
}
protocol LetterPickerDelegate: class {
    func letterPicked(_ letter: String)
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UserUpdatingDelegate, LetterPickerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchBar: UISearchBar!
    var users = User.manyUsers.sorted{ $0.name.lowercased() < $1.name.lowercased() } {
        didSet {
            tableView.reloadData()
        }
    }
    var unfilteredUsers: [User] = []
    var friendsService = FriendService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterPicker.delegate = self
        letterPicker.letters = uniqueLettersCount()
        let headerSection = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        tableView.register(headerSection, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        unfilteredUsers = users
        searchBar.placeholder = "Find a friend"
        searchBar.delegate = self
        friendsService.getFriendsList()
    }
    
// MARK: - Functions
    
    func rowCounting(_ indexPath: IndexPath) -> Int{
        var i = 0
        var rowCount = 0
        while i < indexPath.section {
            rowCount += tableView.numberOfRows(inSection: i)
            i += 1
        }
        rowCount += indexPath.row
        return rowCount
    }
    
    func uniqueLettersCount () -> [String]{
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        letterPicker.letters = Array(Set(allLetters)).sorted()
        return letterPicker.letters
    }
    
// MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return uniqueLettersCount().count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        headerView.sectionLabel.text = letterPicker.letters[section]
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        for user in users {
            if ( String(user.name.first ?? Character("")) == letterPicker.letters[section]) {
                countOfRows += 1
            }
        }
        return countOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsViewCell
        let rowCount = rowCounting(indexPath)
        let user = users[rowCount]
        cell.friendName.text = user.name
        cell.friendPhoto.avatarPhoto.image = UIImage(named: user.photo)
        return cell
    }
    
// MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? FriendPhotosViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        let rowCount = rowCounting(indexPath)
        controller.user = users[rowCount]
        controller.delegate = self
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
// MARK: - LetterPickerDelegate
    
    func letterPicked(_ letter: String) {
        guard let index = letterPicker.letters.firstIndex(where: {$0.lowercased().prefix(1) == letter.lowercased()}) else { return }
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
// MARK: - UserUpdateDelegate
    
    func updateUser(photos: [Photo], id: Int) {
        if let row = users.firstIndex(where: {$0.id == id}) {
            users[row].photos = photos
        }
        if let row = unfilteredUsers.firstIndex(where: {$0.id == id}) {
            unfilteredUsers[row].photos = photos
        }
    }
}

// MARK: - Extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText ==  "") {
            users = unfilteredUsers
            return
        }
        users = unfilteredUsers.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
        let allLetters = users.map { String($0.name.uppercased().prefix(1))}
        letterPicker.letters = Array(Set(allLetters)).sorted()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        users = unfilteredUsers
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
     {
        self.dismissKeyboard()
     }
}
