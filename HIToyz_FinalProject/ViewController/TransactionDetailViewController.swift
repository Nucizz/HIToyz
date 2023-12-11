//
//  TransactionDetailViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//

import UIKit
import CoreData

class TransactionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var transaction: Transaction?
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction!.productItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductItemCell") as! ProductItemTableViewCell
        
        if let productItems = transaction!.productItems, let productItem = productItems.allObjects[indexPath.row] as? ProductItem {
            let product = fetchProduct(name: productItem.productName!)
            cell.productName.text = product!.name
            cell.productCategory.text = product!.category
            cell.productPrice.text = (product!.price == 0) ? "Free" : "Rp\(product!.price )"
            cell.productImageView.image = CustomLogic.loadImageFromDocumentDirectory(fileName: product!.imageUrl ?? "")
            
            cell.itemQty.text = "\(productItem.qty) items"
            cell.itemSubtotal.text = "Rp\(Float(productItem.qty) * product!.price)"
       }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        dateLabel.text = transaction!.date
        totalLabel.text = "Rp\(transaction!.total)"
    }
    
    private func fetchProduct(name: String) -> Product? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1

        do {
            let products = try context.fetch(fetchRequest)
            return products.first
        } catch {
            return nil
        }
    }

}
