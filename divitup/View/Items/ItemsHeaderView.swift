//
//  ItemsHeaderView.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//

import UIKit

class ItemsHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemsHeaderLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("ItemsHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

    @IBAction func addItemTapped(_ sender: UIButton) {
        print("user wants to add an item")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
