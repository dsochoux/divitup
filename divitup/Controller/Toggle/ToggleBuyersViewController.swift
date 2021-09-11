//
//  ToggleBuyersViewController.swift
//  divitup
//
//  Created by danny sochoux on 9/11/21.
//

import UIKit

class ToggleBuyersViewController: UIViewController {

    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var item:Item?
    var people:[Person]?
    var receiptVC:ReceiptViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToggleTableViewCell", bundle: nil), forCellReuseIdentifier: "toggleCell")
        
        let totalPriceForItem = Double(item!.quantity) * item!.price
        itemLabel.text = "\(item?.name ?? "ERROR"): \(item?.quantity ?? 0) x \(String(format: "%.2f", item?.price ?? 0)) = \(String(format: "%.2f", totalPriceForItem))"

        // Do any additional setup after loading the view.
    }
}

extension ToggleBuyersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toggleCell = tableView.dequeueReusableCell(withIdentifier: "toggleCell") as! ToggleTableViewCell
        toggleCell.nameLabel.text = people![indexPath.row].name
        toggleCell.person = people![indexPath.row]
        toggleCell.item = item
        toggleCell.receiptVC = receiptVC
        //determine if the user is currently purchasing or not purchasing the item and set the toggle switch accordingly. just saying true for now
        let itemBuyers = item?.buyers?.allObjects as? [Person]
        print("the number of people buying \(item!.name!) is \(itemBuyers?.count ?? 0)")
        var personIsBuyingItem = false
        itemBuyers?.forEach({ person in
            if person.id == people?[indexPath.row].id {
                personIsBuyingItem = true
            }
        })
        toggleCell.buySwitch.isOn = personIsBuyingItem
        return toggleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
