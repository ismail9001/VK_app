//
//  GroupsViewController.swift
//  VK_app
//
//  Created by macbook on 17.10.2020.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    var groups:[Group] = []
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupsViewCell
        let group = groups[indexPath.row]
        cell.groupName.text = group.title
        cell.groupPhoto.image = UIImage(named: group.photo)
        cell.groupPhoto.layer.cornerRadius = cell.groupPhoto.frame.size.width / 2
        cell.groupPhoto.clipsToBounds = true
        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let groupSearchController = segue.source as! GroupsSearchViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = groupSearchController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = groupSearchController.groups[indexPath.row]
                // Добавляем группу в список выбранных  сообществ
                if !groups.contains(group) {
                    groups.append(group)
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
        // Удаляем группу из массива
            groups.remove(at: indexPath.row)
        // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       guard let controller = segue.destination as? GroupsSearchViewController
       else { return }
       
        controller.groups = groups
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}
