//
//  ItemsHeaderView.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//

import UIKit
import CoreData

class ItemsHeaderView: UIView {
    
    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemsHeaderLabel: UILabel!
    var receipt: Receipt?
    var receiptVC: ReceiptViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("ItemsHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

    @IBAction func addItemTapped(_ sender: UIButton) {
        print("user wants to add an item")
        //create an alert which takes in the item name, the price, and the quantity
        var nameTextField = UITextField()
        var priceTextField = UITextField()
        var quantityTextField = UITextField()
        
        let alert = UIAlertController(title: "New item", message: "Enter item name, price, and quantity", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            //create the new item only if valid data was given
            if (nameTextField.text != "" && priceTextField.text != "") {
                let newItem = Item(context: self.context)
                newItem.name = nameTextField.text
                if let price = Double(priceTextField.text!) {
                    newItem.price = price
                } else {
                    fatalError("could not convert price into double")
                }
                if (quantityTextField.text == "") {
                    newItem.quantity = 1
                } else {
                    if let quantity = Int(quantityTextField.text!) {
                        print("item should have quantity of \(quantity)")
                        newItem.quantity = Int64(quantity)
                    } else {
                        fatalError("could not convert quantity to int")
                    }
                }
                newItem.id = self.receiptVC?.generateId()
                newItem.addToBuyers(self.receipt?.people ?? [])
                //new item has been made. time to save it.
                self.receipt?.addToItems(newItem)
                do {
                    try self.context.save()
                    self.receiptVC?.fetchReceipt()
                    print("item should be added")
                } catch {
                    fatalError("could not save the new item")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "name"
            nameTextField = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "price"
            alertTextField.keyboardType = .decimalPad
            priceTextField = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "quantity (optional, 1 by default)"
            alertTextField.keyboardType = .numberPad
            quantityTextField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        receiptVC?.present(alert, animated: true, completion: nil)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
