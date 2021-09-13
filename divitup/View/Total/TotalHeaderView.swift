//
//  TotalHeaderView.swift
//  divitup
//
//  Created by danny sochoux on 9/12/21.
//

import UIKit

class TotalHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    var receiptVC:ReceiptViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("TotalHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    
    @IBAction func copyTapped(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = "test!!"
    }
    
}
