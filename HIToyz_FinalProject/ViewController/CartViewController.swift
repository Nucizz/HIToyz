//
//  CartViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartTableCellDelegate {
    
    private var items: Int = 0
    
    var delegate: CartViewDelegate?
    private var total: Float = 0
    @IBOutlet weak private var cartTableView: UITableView!
    @IBOutlet weak private var totalLabel: UILabel!
    @IBOutlet weak private var itemLabel: UILabel!
    
    @IBAction private func checkoutButton(_ sender: Any) {
        if !checkoutCart() {
            let alert = UIAlertController(title: "Error", message: "Checkout failed. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
    
            self.present(alert, animated: true)
        } else {
            delegate?.didCheckout()
            CustomLogic.CART_ITEM = []
            navigationController?.popViewController(animated: true)
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomLogic.CART_ITEM.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartTableViewCell
        
        var cartItem = CustomLogic.CART_ITEM[indexPath.row]
        cell.cartItem = cartItem
        cell.delegate = self
        cell.indexPath = indexPath.row
        cell.productNameLabel.text = cartItem.product.name
        cell.productPriceLabel.text = (cartItem.product.price == 0) ? "Free" : "IDR\(cartItem.product.price)"
        cell.productImageview.image = CustomLogic.loadImageFromDocumentDirectory(fileName: cartItem.product.imageUrl!)
        
        if let liveStock = fetchProductStock(cartItem.product.name!) {
            if(cartItem.qty > liveStock) {
                let alert = UIAlertController(title: "Out of stock", message: "Do you want buy the remaining or remove item from cart?", preferredStyle: .alert)
                if liveStock > 0 {
                    alert.addAction(UIAlertAction(title: "Buy Remaining", style: .default, handler: {_ in
                        cartItem.qty = liveStock
                        CustomLogic.CART_ITEM[indexPath.row].qty = liveStock
                        cell.productQuantityStepper.value = Double(cartItem.qty)
                        cell.productQuantityField.text = "\(cartItem.qty)"
                        cell.productSubtotalLabel.text = "Rp\(Float(cartItem.qty) * cartItem.product.price)"
                    }))
                }
                alert.addAction(UIAlertAction(title: "Remove Item", style: .destructive, handler: {_ in
                    CustomLogic.CART_ITEM.remove(at: indexPath.row)
                    tableView.reloadData()
                }))
                
                self.present(alert, animated: true)
            } else {
                cell.productQuantityStepper.value = Double(cartItem.qty)
                cell.productQuantityField.text = "\(cartItem.qty)"
                cell.productSubtotalLabel.text = Float(cartItem.qty) * cartItem.product.price > 0 ? "Rp\(Float(cartItem.qty) * cartItem.product.price)" : "Free"
            }
        }
        
        items += Int(cartItem.qty)
        total += Float(cartItem.qty) * cartItem.product.price
        
        totalLabel.text = total > 0 ? "Rp\(total)" : "Free"
        itemLabel.text = "\(items) items"
        
        return cell
    }
    
    func didUpdateCartItem() {
        items = 0
        total = 0
        totalLabel.text = total > 0 ? "Rp\(total)" : "Free"
        itemLabel.text = "\(items) items"
        cartTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Cart"
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "AccentColor") as Any]
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
        
        totalLabel.text = "Rp\(total)"
        itemLabel.text = "\(items) items"
    }
    
    private func checkoutCart() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transaction = Transaction(context: context)
        var total: Float = 0
        
        for item in CustomLogic.CART_ITEM {
            let productItem = ProductItem(context: context)
            productItem.productName = item.product.name
            productItem.qty = item.qty
            productItem.subtotal = Float(item.qty) * item.product.price
            total += Float(item.qty) * item.product.price
            productItem.transaction = transaction
            if updateProductStock(name: item.product.name!, quantity: item.qty) {
                transaction.addToProductItems(productItem)
            } else {
                return false
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy (HH:mm)"
        transaction.date = dateFormatter.string(from: Date())
        transaction.total = total

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    private func fetchProductStock(_ name: String) -> Int32? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let products = try context.fetch(fetchRequest)
            return products.first!.stock
        } catch {
            print("Error fetching product by name: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func updateProductStock(name: String, quantity: Int32) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if let existingProduct = try context.fetch(fetchRequest).first {
                existingProduct.stock -= quantity
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }

}

protocol CartViewDelegate: AnyObject {
    func didCheckout()
}
