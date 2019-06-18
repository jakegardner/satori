//
//  AddItemController.swift
//  satori
//
//  Created by Jake on 5/29/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import UIKit

protocol AddItemControllerDelegate
{
    func onSaveItem(itemText: String)
}

class AddItemController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var saveItemButton: UIButton!
    var addItemDelegate: AddItemControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemText.delegate = self
        itemText.becomeFirstResponder()
        
        saveItemButton.isEnabled = false
    }

    func saveNewItem(itemText: String) {
        if (itemText.count > 0) {
            addItemDelegate?.onSaveItem(itemText: itemText)
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onSaveButtonClick(_ sender: Any) {
        saveNewItem(itemText: self.itemText.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemText.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveItemButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.itemText.hasText {
            saveItemButton.isEnabled = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemText.resignFirstResponder()
        saveNewItem(itemText: self.itemText.text!)
        return true
    }
}

