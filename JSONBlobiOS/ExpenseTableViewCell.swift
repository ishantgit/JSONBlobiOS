//
//  ExpenseTableViewCell.swift
//  JSONBlobiOS
//
//  Created by ishant on 24/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var buttonTwo: UIButton!
    
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var onButtonOneTapped: (() -> Void)? = nil
    var onButtonTwoTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func onButtonOneTapped(sender: AnyObject) {
        if let onButtonOneTapped = self.onButtonOneTapped{
            onButtonOneTapped()
        }
    }
    
    @IBAction func onButtonTwoTapped(sender: AnyObject) {
        if let onButtonTwoTapped = self.onButtonTwoTapped{
            onButtonTwoTapped()
        }
    }

}
