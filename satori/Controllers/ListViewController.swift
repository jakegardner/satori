//
//  ListViewController.swift
//  affirm
//
//  Created by Jake on 5/20/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController, AddItemControllerDelegate {

    let realm = try! Realm()
    var items: Results<Affirmation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(Affirmation.self)
        tableView.reloadData()
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
        } catch {
            print("error saving context")
        }
        tableView.reloadData()
    }

    // MARK - datasource methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        cell.label?.text = items?[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

}
