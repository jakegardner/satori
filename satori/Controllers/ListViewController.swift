//
//  ListViewController.swift
//  affirm
//
//  Created by Jake on 5/20/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import UserNotifications

class CustomSwipeTableCell: SwipeTableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
}

class ListViewController: UITableViewController, AddItemControllerDelegate, UNUserNotificationCenterDelegate {

    let realm = try! Realm()
    var items: Results<Affirmation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(Affirmation.self)
        tableView.reloadData()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAddItem" {
            let viewController = segue.destination as! AddItemController
            viewController.addItemDelegate = self
        }
    }
    
    func onSaveItem(itemText: String) {
        do {
            let newItem = Affirmation()
            newItem.text = itemText
            try realm.write {
                realm.add(newItem)
            }
            self.updateUserNotifications()
        } catch {
            print("error saving context")
        }
        tableView.reloadData()
    }

    // MARK - datasource methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! CustomSwipeTableCell
        cell.delegate = self
        cell.cellLabel.text = items?[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    func updateUserNotifications() {
        NotificationHelper.app.removeNotifications()
        let notifications = NotificationHelper.app.createScheduleForItems(items: Array(items!))
        NotificationHelper.app.createNotifications(items: notifications)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }
}

extension ListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let item = self.items?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                    self.updateUserNotifications()
                } catch {
                    print("error deleting item")
                }
            }
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
