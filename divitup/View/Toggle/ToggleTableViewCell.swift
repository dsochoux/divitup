//
//  ToggleTableViewCell.swift
//  divitup
//
//  Created by danny sochoux on 9/11/21.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {

    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buySwitch: UISwitch!
    var item:Item?
    var person:Person?
    var receiptVC:ReceiptViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        if sender.isOn {
            //the switch was turned on, add the person to the buyers
            print("adding \(item?.name ?? "ERROR") to \(person?.name ?? "ERROR")")
            item?.addToBuyers(person!)
            person?.addToItems(item!)
        } else {
            //the switch was turned off, remove the person from the buyers
            print("removing \(item?.name ?? "ERROR") from \(person?.name ?? "ERROR")")

            item?.removeFromBuyers(person!)
            person?.removeFromItems(item!)
        }
        //save changes
        do {
            try context.save()
            receiptVC?.fetchReceipt()
        } catch {
            fatalError("could not save the toggled change")
        }
    }
}
