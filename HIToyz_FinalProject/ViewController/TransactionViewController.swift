//
//  ToysViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//

import UIKit
import CoreData

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckoutDelegate {
    
    var transactionList: [Transaction] = []
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        
        let transaction = transactionList[indexPath.row]
        cell.dateLabel.text = transaction.date
        cell.totalLabel.text = transaction.total > 0 ? "Rp\(transaction.total)" : "Free"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trasactionDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailViewController") as? TransactionDetailViewController {
            trasactionDetailVC.transaction = transactionList[indexPath.row]

            self.navigationController?.pushViewController(trasactionDetailVC, animated: true)
        }
    }
    
    func didCheckoutCompleted() {
        if let fetchTransactionList = fetchTransaction() {
            transactionList = fetchTransactionList
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let fetchTransactionList = fetchTransaction() {
            transactionList = fetchTransactionList
            tableView.reloadData()
        }
    }
    
    private func fetchTransaction() -> [Transaction]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

}
