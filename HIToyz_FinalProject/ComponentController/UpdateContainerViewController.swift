//
//  UpdateContainerViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 07/12/23.
//

import UIKit
import CoreData

class UpdateContainerViewController: UIViewController, UpdateProductDelegate {

    public var product: Product?
    @IBOutlet weak private var productPriceLabel: UILabel!
    weak var delegate: UpdateProductDelegate?
    private var productStock: Int = 1
    @IBOutlet weak var productStockField: UITextField!
    @IBOutlet weak var productStockStepper: UIStepper!
    @IBAction func productStepperButton(_ sender: Any) {
        let value = Int(productStockStepper.value)
        productStockField.text = "\(value)"
        productStock = value
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteProduct(productName: self.product!.name!)
            self.delegate?.didChangeProduct(product: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {
        if let updateProductVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProductViewController") as? UpdateProductViewController {
            updateProductVC.delegate = self
            updateProductVC.product = product
            self.navigationController?.pushViewController(updateProductVC, animated: true)
        }
    }
    
    func didChangeProduct(product: Product?) {
        self.product = product!
        productStock = Int(product!.stock)
        productStockField.text = "\(productStock)"
        productStockStepper.value = Double(productStock)
        productPriceLabel.text = "Priced at Rp\(product!.price)"
        
        delegate?.didChangeProduct(product: product)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productStock = Int(product!.stock)
        productStockField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Current Stock")
        productStockField.text = "\(productStock)"
        productStockStepper.value = Double(productStock)
        productStockField.addTarget(self, action: #selector(updateStockFromText), for: .editingChanged)
        
        productPriceLabel.text = "Priced at Rp\(product!.price)"
    }
    
    @objc private func updateStockFromText(_ textField: UITextField) {
        if textField == productStockField {
            productStock = Int(productStockField.text!) ?? 0
            productStockStepper.value = Double(productStock)
            if !updateStock(newStock: productStock, name: product!.name!) {
                let alert = UIAlertController(title: "Error", message: "Something went wrong while updating stock.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "I Understand", style: .default))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    private func updateStock(newStock: Int, name: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            if let existingProduct = try context.fetch(fetchRequest).first {
                existingProduct.stock = Int32(newStock)
                try context.save()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    private func deleteProduct(productName: String) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", productName)

            do {
                if let productToDelete = try context.fetch(fetchRequest).first {
                    context.delete(productToDelete)
                    try context.save()
                }
            } catch {}
        }

}
