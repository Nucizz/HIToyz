 //
//  MainViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//

import UIKit

class MainViewController: UITabBarController, CartViewDelegate {
    
    weak var transactionViewController: TransactionViewController?
    
    func didCheckout() {
        transactionViewController?.didCheckoutCompleted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        var viewControllers: [UIViewController] = []
        for viewController in self.viewControllers ?? [] {
            if CustomLogic.CURRENT_USER!.isAdmin && viewController.title == "Transaction" {
                continue
            }
            transactionViewController = viewController as? TransactionViewController
            viewControllers.append(viewController)
        }

        self.setViewControllers(viewControllers, animated: false)
    }
    
    
    
}

protocol CheckoutDelegate: AnyObject {
    func didCheckoutCompleted()
}
