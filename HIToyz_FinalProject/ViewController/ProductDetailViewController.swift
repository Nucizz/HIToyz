//
//  ProductDetailViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 05/12/23.
//

import UIKit

class ProductDetailViewController: UIViewController, UpdateProductDelegate, PurchaseViewDelegate {
    var product: Product?
    weak var delegatePurchase: PurchaseViewDelegate?
    weak var delegateUpdate: UpdateProductDelegate?
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productCategoryLabel: UILabel!
    @IBOutlet weak private var productDescriptionLabel: UILabel!
    @IBOutlet weak private var controlContainerView: UIView!
    
    func didChangeProduct(product: Product?) {
        if(product != nil) {
            self.product = product!
            imageView.image = CustomLogic.loadImageFromDocumentDirectory(fileName: product!.imageUrl!)
            productNameLabel.text = product!.name
            productCategoryLabel.text = product!.category
            productDescriptionLabel.text = product!.desc
        }
        
        delegateUpdate?.didChangeProduct(product: product)
    }
    
    func didAddCartItem() {
        delegatePurchase?.didAddCartItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = CustomLogic.loadImageFromDocumentDirectory(fileName: product!.imageUrl!)
        
        productNameLabel.text = product!.name
        productCategoryLabel.text = product!.category
        productDescriptionLabel.text = product!.desc
        
        if(CustomLogic.CURRENT_USER!.isAdmin) {
            if let updateController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateControllerContainer") as? UpdateContainerViewController {
                updateController.delegate = self
                updateController.product = product
                self.addChild(updateController)
                controlContainerView.addSubview(updateController.view)
                updateController.didMove(toParent: self)
            }
        } else if let purchaseController = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseControllerContainer") as? PurchaseContainerViewController {
            purchaseController.delegate = self
            purchaseController.product = product
            self.addChild(purchaseController)
            controlContainerView.addSubview(purchaseController.view)
            purchaseController.didMove(toParent: self)
        }
        
    }
    
}
