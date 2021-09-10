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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.register(UINib(nibName: "TotalTableViewCell", bundle: nil), forCellReuseIdentifier: "totalCell")
        tableView.reloadData()
    }
}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            let header = TaxesFeesHeaderView()
            header.receipt = receipt
            header.taxesfeesHeaderLabel.text = "Taxes / Fees"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return receipt?.items?.count ?? 0
        case 1:
            return receipt?.people?.count ?? 0
        case 2:
            return 0
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            //create item cell
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
            //get list of all of the items
            let items = receipt?.items?.allObjects as! [Item]
            //select the correct item for the cell
            var quantityLabel = "(\(items[indexPath.row].quantity) x \(String(format: "%.2f", items[indexPath.row].price)))"
            if ((items[indexPath.row].quantity) == 1) {
                quantityLabel = ""
            }
            itemCell.itemNameLabel.text = "\(items[indexPath.row].name ?? "ERROR") \(quantityLabel)"
            itemCell.itemPriceLabel.text = String(format: "%.2f", (items[indexPath.row].price * Double(items[indexPath.row].quantity)))
            return itemCell
        case 1:
            let people = receipt?.people?.allObjects as! [Person]
            cell.textLabel?.text = people[indexPath.row].name
            return cell
        case 3:
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "totalCell") as! TotalTableViewCell
            totalCell.totalLabel.text = String(format: "%.2f", receipt?.total ?? 0)
            return totalCell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - extra functions
extension ReceiptViewController {
    
    func generateId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
    }
    
    func calculateTotal() {
        print("this function is getting called")
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
    
    func fetchReceipt() {
        do {
            let request = Receipt.fetchRequest() as NSFetchRequest<Receipt>
            let pred = NSPredicate(format: "id CONTAINS %@", receipt!.id!)
            request.predicate = pred
            self.receipt = try context.fetch(request)[0]
            calculateTotal()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("could not fetch specific receipt")
        }
        
    }

}
