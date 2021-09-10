//
//  ReceiptViewController.swift
//  divitup
//
//  Created by danny sochoux on 9/8/21.
//

import UIKit

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
        tableView.reloadData()
    }
}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
//        case 0:
//            return "Items"
//        case 1:
//            return "People"
//        case 2:
//            return "Taxes / fees"
        case 3:
            return "Total"
        default:
            return "Error!"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = ItemsHeaderView()
            header.itemsHeaderLabel.text = "Items (\(receipt?.items?.count ?? 0))"
            return header
        case 1:
            let header = PeopleHeaderView()
            header.peopleHeaderLabel.text = "People (\(receipt?.people?.count ?? 0))"
            return header
        case 2:
            let header = TaxesFeesHeaderView()
            header.taxesfeesHeaderLabel.text = "Taxes / Fees"
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
