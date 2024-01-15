//
//  CartTableViewCell.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    var delegate: CartTableCellDelegate?
    var cartItem: CartItem?
    var indexPath: Int?
    
    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productSubtotalLabel: UILabel!
    
    private var previousQuantity: Double = 1.0
    var productQuantity: Int = 0
    @IBOutlet weak var productQuantityField: UITextField!
    @IBOutlet weak var productQuantityStepper: UIStepper!
    @IBAction private func productQuantityButton(_ sender: Any) {
        let currentQuantity = productQuantityStepper.value
        if currentQuantity == 1 && currentQuantity < previousQuantity {
            CustomLogic.CART_ITEM.remove(at: indexPath!)
        } else {
            handleQty(qtyRaw: Int(currentQuantity))
        }
        delegate?.didUpdateCartItem()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productQuantityField.addTarget(self, action: #selector(updateQtyFromText), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc private func updateQtyFromText(_ textField: UITextField) {
        if textField == productQuantityField {
            if Int(productQuantityField.text!) == 0 {
                CustomLogic.CART_ITEM.remove(at: indexPath!)
                delegate?.didUpdateCartItem()
            } else {
                handleQty(qtyRaw: Int(productQuantityField.text!) ?? 0)
                productQuantityStepper.value = Double(productQuantity)
            }
        }
    }
    
    private func handleQty(qtyRaw: Int) {
        var qty: Int = qtyRaw
        if (qty < 0) {
            qty = 0
        }
        
        productSubtotalLabel.text = (Float(qty) * cartItem!.product.price) > 0 ? "Rp\(Float(qty) * cartItem!.product.price)" : "Free"
        productQuantityField.text = "\(qty)"
        productQuantity = qty
        
        CustomLogic.CART_ITEM[indexPath!].qty = Int32(qty)
        
    }

}

protocol CartTableCellDelegate: AnyObject {
    func didUpdateCartItem()
}
