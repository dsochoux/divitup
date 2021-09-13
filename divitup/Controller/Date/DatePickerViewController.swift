//
//  DatePickerViewController.swift
//  divitup
//
//  Created by danny sochoux on 9/12/21.
//

import UIKit

class DatePickerViewController: UIViewController {

    //reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var receipt:Receipt?
    var receiptVC:ReceiptViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = (receipt?.date)!

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        receipt?.date = sender.date
        do {
            try context.save()
            receiptVC?.fetchReceipt()
            self.dismiss(animated: true, completion: nil)
        } catch {
            fatalError("could not change date")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
