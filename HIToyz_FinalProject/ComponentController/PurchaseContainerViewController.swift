//
//  ProductDetailsCustomerViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 07/12/23.
//

import UIKit

class PurchaseContainerViewController: UIViewController {

    var delegate: PurchaseViewDelegate?
    public var product: Product?
    @IBOutlet weak private var productStockLabel: UILabel!
    
    private var lastQty: Int = 1
    private var productQty: Int = 1
    @IBOutlet weak private var productQuantityStepper: UIStepper!
    @IBOutlet weak private var productQuantityField: UITextField!
    @IBAction private func productQuantityButton(_ sender: Any) {
        handleQty(qtyRaw: Int(productQuantityStepper.value))
    }
    
    @IBOutlet weak private var purchaseButtonValue: UIButton!
    @IBAction private func purhaseButton(_ sender: Any) {
        addProductItem(product: product!, qty: Int32(productQty))
    }
    
    private func handleQty(qtyRaw: Int) {
        var qty: Int = qtyRaw
        if (qty < 0) {
            qty = 0
        } else if(qty > product!.stock) {
            qty = lastQty
        }
        
        lastQty = qty
        productQuantityField.text = "\(qty)"
        purchaseButtonValue.setTitle(product!.price * Float(qty) > 0 ? "Rp\(product!.price * Float(qty))" : "Free", for: .normal)
        productQty = qty
    }
    
    @objc private func updateQtyFromText(_ textField: UITextField) {
        if textField == productQuantityField {
            handleQty(qtyRaw: Int(productQuantityField.text!) ?? 0)
            productQuantityStepper.value = Double(productQty)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productQuantityField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Quantity")
        
        productStockLabel.text = product!.stock > 0 ? "Only \(product!.stock) items left!" : "Out of stock!"
        purchaseButtonValue.setTitle(product!.price > 0 ? "Rp\(product!.price)" : "Free", for: .normal)
        
        lastQty = product!.stock > 0 ? 1 : 0
        productQuantityField.text = product!.stock > 0 ? "\(productQty)" : "0"
        productQuantityStepper.value = product!.stock > 0 ? Double(productQty) : 0
        productQuantityField.addTarget(self, action: #selector(updateQtyFromText), for: .editingChanged)
    }
    
    private func addProductItem(product: Product, qty: Int32) {
        if qty > 0 {
            let productItem = CartItem(product: product, qty: qty)
            CustomLogic.CART_ITEM.append(productItem)
            delegate?.didAddCartItem()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid Quantity", message: "You can't purchase an empty product.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I understand!", style: .default))
            self.present(alert, animated: true)
        }
    }
}

protocol PurchaseViewDelegate: AnyObject {
    func didAddCartItem()
}
