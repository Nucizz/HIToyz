//
//  HomeViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddProductDelegate, UpdateProductDelegate, PurchaseViewDelegate, CartViewDelegate {
    
    var productList: [Product] = []
    
    var cartDelegate: CartViewDelegate?
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var greetingsLabel: UILabel!
    @IBOutlet weak private var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if(CustomLogic.CURRENT_USER!.isAdmin) {
            view.addSubview(floatingAddButton)
            floatingAddButton.addTarget(self, action: #selector(didTapFloatingAddButton), for: .touchUpInside)
        } else if(!CustomLogic.CART_ITEM.isEmpty) {
            view.addSubview(floatingCartButton)
            floatingCartButton.addTarget(self, action: #selector(didTapFloatingCartButton), for: .touchUpInside)
        }
        
        greetingsLabel.text = CustomLogic.getGreetings()
        usernameLabel.text = CustomLogic.CURRENT_USER!.username
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.delegate = self
        
        if let fetchedProductList = fetchProduct() {
            productList = fetchedProductList
            tableView.reloadData()
        }
    }
    
    func didAddCartItem() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !CustomLogic.CART_ITEM.isEmpty {
                self.view.addSubview(self.floatingCartButton)
                self.floatingCartButton.addTarget(self, action: #selector(self.didTapFloatingCartButton), for: .touchUpInside)
            }
        }
    }
    
    func didCheckout() {
        DispatchQueue.main.async { [weak self] in
            self?.floatingCartButton.removeFromSuperview()
        }
        cartDelegate?.didCheckout()
    }
    
    private let floatingAddButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: 50, height: 50))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(named: "AccentColor")
        
        let icon = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let floatingCartButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: 50, height: 50))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(named: "AccentColor")
        
        let icon = UIImage(systemName: "bag", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    public func didAddProduct() {
        if let fetchedProductList = fetchProduct() {
            productList = fetchedProductList
            tableView.reloadData()
        }
    }
    
    public func didChangeProduct(product: Product?) {
        print("Product updated: \(product?.name ?? "Unknown Name")")
        if let fetchedProductList = fetchProduct() {
            productList = fetchedProductList
            tableView.reloadData()
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductTableViewCell
        
        let product = productList[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productCategoryLabel.text = product.category
        cell.productPriceLabel.text = (product.price == 0) ? "Free" : "Rp\(product.price)"
        cell.productImageView.image = CustomLogic.loadImageFromDocumentDirectory(fileName: product.imageUrl!)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if !deleteProduct(at: indexPath) {
                let alert = UIAlertController(title: "Sorry!", message: "Something went wrong while deleting the data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "I Understand", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return CustomLogic.CURRENT_USER!.isAdmin
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            productDetailVC.delegatePurchase = self
            productDetailVC.delegateUpdate = self
            productDetailVC.product = productList[indexPath.row]
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingAddButton.frame = CGRect(
            x: view.frame.size.width - 50 - 15,
            y: view.frame.size.height - 50 - 100,
            width: 50,
            height: 50
        )
        
        floatingCartButton.frame = CGRect(
            x: view.frame.size.width - 50 - 15,
            y: view.frame.size.height - 50 - 100,
            width: 50,
            height: 50
        )
    }

    @objc private func didTapFloatingAddButton() {
        if let addProductVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            addProductVC.delegate = self
            self.navigationController?.pushViewController(addProductVC, animated: true)
        }
    }
    
    @objc private func didTapFloatingCartButton() {
        if let cartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    private func fetchProduct() -> [Product]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    private func deleteProduct(at indexPath: IndexPath) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let productToDelete = productList[indexPath.row]
            context.delete(productToDelete)
            do {
                try context.save()
                productList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                return true
            } catch {
                return false
            }
        }

}
