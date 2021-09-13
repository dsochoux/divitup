//
//  ReceiptViewController.swift
//  divitup
//
//  Created by danny sochoux on 9/8/21.
//

import UIKit
import CoreData

class ReceiptViewController: UIViewController {
    
    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //reference to the table view
    @IBOutlet weak var tableView: UITableView!
    
    //the receipt that the screen is presenting
    var receipt:Receipt?
    var people:[Person]?
    var items:[Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "personCell")
        tableView.register(UINib(nibName: "TotalTableViewCell", bundle: nil), forCellReuseIdentifier: "totalCell")
        fetchReceipt()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toggleBuyers") {
            let destinationVC = segue.destination as! ToggleBuyersViewController
            if let item = sender as? Item {
                destinationVC.item = item
                destinationVC.people = people
                destinationVC.receiptVC = self
//                destinationVC.itemLabel.text = "\(item.quantity) x \(item.name) for \(String(format: "%.2f", item.price))"
            } else {
                fatalError("could not convert sender to item")
            }

        } else if (segue.identifier == "pickDateSegue") {
            let destinationVC = segue.destination as! DatePickerViewController
            destinationVC.receipt = receipt
            destinationVC.receiptVC = self
        }
    }
}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        //items
        case 0:
            return receipt?.items?.count ?? 0
        //people
        case 1:
            return receipt?.people?.count ?? 0
        //total
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = ItemsHeaderView()
            header.receipt = receipt
            header.itemsHeaderLabel.text = "Items (\(receipt?.items?.count ?? 0))"
            header.receiptVC = self
            return header
        case 1:
            let header = PeopleHeaderView()
            header.receipt = receipt
            header.peopleHeaderLabel.text = "People (\(receipt?.people?.count ?? 0))"
            header.receiptVC = self
            return header
        case 2:
            let header = TotalHeaderView()
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            //create item cell
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
            //get list of all of the items
            //select the correct item for the cell
            var quantityLabel = "(\(items![indexPath.row].quantity) x \(String(format: "%.2f", items![indexPath.row].price)))"
            if ((items![indexPath.row].quantity) == 1) {
                quantityLabel = ""
            }
            itemCell.itemNameLabel.text = "\(items![indexPath.row].name ?? "ERROR") \(quantityLabel)"
            itemCell.itemPriceLabel.text = String(format: "%.2f", (items![indexPath.row].price * Double(items![indexPath.row].quantity)))
            return itemCell
        case 1:
            let personCell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonTableViewCell
            personCell.nameLabel.text = people![indexPath.row].name
            personCell.totalLabel.text = String(format: "%.2f", people![indexPath.row].total)
            return personCell
        case 2:
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "totalCell") as! TotalTableViewCell
            totalCell.totalLabel.text = String(format: "%.2f", receipt?.total ?? 0)
            return totalCell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return true
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            performSegue(withIdentifier: "toggleBuyers", sender: items![indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in
                //delete the item
                let itemToRemove = self.items![indexPath.row]
                self.receipt?.removeFromItems(itemToRemove)
                self.people?.forEach({ person in
                    person.removeFromItems(itemToRemove)
                })
                
                //save the changes
                do {
                    try self.context.save()
                    self.fetchReceipt()
                } catch {
                    fatalError("could not save deletion of item")
                }
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualAction, view, boolValue in
                //create uialert, with prefilled text boxes.
                var nameTextField = UITextField()
                var priceTextField = UITextField()
                var quantityTextField = UITextField()
                
                let alert = UIAlertController(title: "Edit item", message: nil, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Save", style: .default) { alertAction in
                    //save the changes made
                    self.items![indexPath.row].name = nameTextField.text
                    self.items![indexPath.row].price = Double(priceTextField.text!) ?? 0
                    self.items![indexPath.row].quantity = Int64(quantityTextField.text!) ?? 1
                    
                    do {
                        try self.context.save()
                        self.fetchReceipt()
                    } catch {
                        fatalError("could not save the updated item")
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
                    self.tableView.reloadData()
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.text = self.items![indexPath.row].name
                    nameTextField = alertTextField
                }
                alert.addTextField { alertTextField in
                    alertTextField.text = String(self.items![indexPath.row].price)
                    alertTextField.keyboardType = .decimalPad
                    priceTextField = alertTextField
                }
                alert.addTextField { alertTextField in
                    alertTextField.text = String(self.items![indexPath.row].quantity)
                    alertTextField.keyboardType = .numberPad
                    quantityTextField = alertTextField
                }
                
                alert.addAction(action)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                print("the user wants do edit an item")
            }
            editAction.backgroundColor = .systemBlue
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return swipeActions
        case 1:
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in
                //delete the item
                let personToRemove = self.people![indexPath.row]
                self.receipt?.removeFromPeople(personToRemove)
                self.items?.forEach({ item in
                    item.removeFromBuyers(personToRemove)
                })
                //save the changes
                do {
                    try self.context.save()
                    self.fetchReceipt()
                } catch {
                    fatalError("could not save deletion of item")
                }
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeActions
        default:
            return nil
        }
    }
}

//MARK: - extra functions
extension ReceiptViewController {
    
    func generateId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
    }
    
    func calculateTotal() {
        //print("this function is getting called")
        var total:Double = 0
        let items = receipt?.items?.allObjects as! [Item]
        for item in items {
            total += (item.price * Double(item.quantity))
        }
        receipt?.total = total
        //save the data
        do {
            try context.save()
        } catch {
            fatalError("could not update the total")
        }
    }
    
    func sortPeople() {
        let sortedPeople = (receipt?.people?.allObjects as! [Person]).sorted { p1, p2 in
            return p1.name!.lowercased() < p2.name!.lowercased()
        }
        people = sortedPeople
    }
    func sortItems() {
        let sortedItems = (receipt?.items?.allObjects as! [Item]).sorted { i1, i2 in
            return i1.name!.lowercased() < i2.name!.lowercased()
        }
        items = sortedItems
    }
    
    func calculatePeopleTotals() {
        let people = receipt?.people?.allObjects as! [Person]
        people.forEach { person in
            person.total = 0
            person.items?.forEach({ i in
                let item = i as! Item
                person.total += ((item.price * Double(item.quantity)) / Double(item.buyers!.count))
            })
        }
    }
    
    func fetchReceipt() {
        do {
            let request = Receipt.fetchRequest() as NSFetchRequest<Receipt>
            let pred = NSPredicate(format: "id CONTAINS %@", receipt!.id!)
            request.predicate = pred
            self.receipt = try context.fetch(request)[0]
            calculateTotal()
            sortPeople()
            sortItems()
            calculatePeopleTotals()
            let stringDate = dateToString(receipt: receipt!)
            DispatchQueue.main.async {
                self.title = "\(self.receipt!.name!) - \(stringDate)"
                self.tableView.reloadData()
            }
        } catch {
            fatalError("could not fetch specific receipt")
        }
        
    }
    
    func dateToString(receipt: Receipt) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let stringDate = dateFormatter.string(from: receipt.date!)
        return stringDate
    }

}
