//
//  TaxesFeesHeaderView.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//

import UIKit

class TaxesFeesHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taxesfeesHeaderLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("TaxesFeesHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    @IBAction func addTaxfeeTapped(_ sender: UIButton) {
        print("user wants to add a tax / fee")
    }
    
}