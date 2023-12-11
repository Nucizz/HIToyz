//
//  ProductTableViewCell.swift
//  HIToyz_FinalProject
//
//  Created by prk on 30/11/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
