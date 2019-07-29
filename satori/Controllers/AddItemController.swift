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
    @IBOutlet weak var createBtn: UIButton!
    
    var addItemDelegate: AddItemControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemText.delegate = self
        itemText.becomeFirstResponder()
        
        createBtn.isEnabled = false
    }

    func saveNewItem(itemText: String) {
        if (itemText.count > 0) {
            addItemDelegate?.onSaveItem(itemText: itemText)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCreateItem(_ sender: Any) {
        saveNewItem(itemText: itemText.text!)
    }
    
    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemText.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        createBtn.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.itemText.hasText {
            createBtn.isEnabled = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemText.resignFirstResponder()
        saveNewItem(itemText: self.itemText.text!)
        return true
    }
}

