//
//  ReceiptsViewController.swift
//  divitup
//
//  Created by danny sochoux on 9/7/21.
//

import UIKit

class ReceiptsViewController: UIViewController {
    
    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var receipts:[Receipt]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "receiptCell")
        tableView.separatorStyle = .singleLine
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //get receipts from core data
        fetchReceipts()
    }
    
    @objc func refresh() {
        fetchReceipts()
        tableView.refreshControl?.endRefreshing()
    }
    
    func fetchReceipts() {
        do {
            self.receipts = try context.fetch(Receipt.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            fatalError("could not fetch receipts")
        }
    }
    
    @IBAction func newReceiptPressed(_ sender: UIBarButtonItem) {
        //Ask for name of the receipt
        //create global textField
        var textField = UITextField()
        
        //create the alert
        let alert = UIAlertController(title: "New receipt", message: "Enter a name for this new receipt", preferredStyle: .alert)
        
        //create the main action
        let action = UIAlertAction(title: "Create", style: .default) { action in
            //create the new receipt object and direct the user to a new page for the receipt
            
            //if a name has been entered, create a receipt with that name
            if (textField.text != "") {
                //create new receipt object
                let newReceipt = Receipt(context: self.context)
                newReceipt.name = textField.text
                newReceipt.date = Date()
                newReceipt.id = self.generateId()
                
                //save the data
                do {
                    try self.context.save()
                    print("new receipt created with id of \(newReceipt.id ?? "no id")")
                }
                catch {
                    fatalError("could not save the new receipt to the context")
                }
                
                //refetch the receipts
                self.fetchReceipts()
                
                //after the receipt is created, take them to the page of that receipt
                self.performSegue(withIdentifier: "receiptSegue", sender: newReceipt)
            }
        }
        
        //create the cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        //add the text field
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "e.g \"Costco\""
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        
        //add actions to the alert
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "receiptSegue") {
            //passing the receipt pressed via the sender object, unwrapping it here
            let receipt = sender as! Receipt
            let stringDate = dateToString(receipt: receipt)
            let destination = segue.destination as! ReceiptViewController
            //setting the title of the new screen
            destination.title = "\(receipt.name!) - \(stringDate)"
            destination.receipt = receipt
        }
    }

}

extension ReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell") as! ReceiptTableViewCell
        
        //set the name of the receipt
        cell.nameLabel.text = receipts![indexPath.row].name!
        
        //set the details of the receipt
        //get the number of items
        let numberOfItems = receipts![indexPath.row].items?.count
        //get the date in string format
        let stringDate = dateToString(receipt: receipts![indexPath.row])
        cell.detailsLabel.text = "\(numberOfItems ?? 0) items on \(stringDate)"
        cell.totalLabel.text = String(format: "%.2f", receipts![indexPath.row].total)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "receiptSegue", sender: receipts![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in
            //delete the recipt
            self.context.delete(self.receipts![indexPath.row])
            do {
                try self.context.save()
                self.fetchReceipts()
            } catch {
                fatalError("could not save reciept deletion")
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension ReceiptsViewController {
    func dateToString(receipt: Receipt) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let stringDate = dateFormatter.string(from: receipt.date!)
        return stringDate
    }
    
    func generateId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
    }
}