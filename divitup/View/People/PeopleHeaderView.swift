//
//  PeopleHeaderView.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//

import UIKit

class PeopleHeaderView: UIView {
    
    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var peopleHeaderLabel: UILabel!
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
        Bundle.main.loadNibNamed("PeopleHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

    @IBAction func addPersonTapped(_ sender: UIButton) {
        print("user wants to add a person to the receipt with id \(receipt?.id ?? "NIL")")
        
        //present an alert and ask for the person's name
        var textField = UITextField()
        let alert = UIAlertController(title: "New person", message: "Enter the name of the new person you would like to add to this receipt.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if (textField.text! != "") {
                print(textField.text!)
                //create new person and add them to the receipt
                let newPerson = Person(context: self.context)
                newPerson.name = textField.text
                newPerson.id = self.generateId()
                self.receipt?.addToPeople(newPerson)
                do {
                    try self.context.save()
                    //call a function of the receipt view controller that refetches the data. have not written that yet.
                    self.receiptVC?.fetchReceipt()
                } catch {
                    fatalError("could not save new person")
                }
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField { alertTextField in
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
            
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        receiptVC?.present(alert, animated: true, completion: nil)
    }
}

extension PeopleHeaderView {
    func generateId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
    }
}
