//
//  ProductItemTableViewCell.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//

import UIKit

class ProductItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var itemSubtotal: UILabel!
    @IBOutlet weak var itemQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
