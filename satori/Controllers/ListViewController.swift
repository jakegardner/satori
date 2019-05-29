//
//  ListViewController.swift
//  affirm
//
//  Created by Jake on 5/20/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, AddItemControllerDelegate {

    var items: [Affirmation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAddItem" {
            let viewController = segue.destination as! AddItemController
            viewController.addItemDelegate = self
        }
    }
    
    func onSaveItem(itemText: String) {
        items.append(Affirmation(text: itemText))
        tableView.reloadData()
    }

    // MARK - datasource methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        cell.label.text = items[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

}
