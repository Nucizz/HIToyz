//
//  ProfileViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {_ in self.authenticateLogout()}))
        alert.addAction(UIAlertAction(title: "Stay Logged in", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }

    private func authenticateLogout() {
        CustomLogic.CURRENT_USER = nil
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "hashedPassword")
        navigationController?.popToRootViewController(animated: true)
    }
    
}

class ProfileViewContainerController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    var tapCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = CustomLogic.CURRENT_USER!.username
        emailLabel.text = CustomLogic.CURRENT_USER!.email
        statusLabel.text = CustomLogic.CURRENT_USER!.isAdmin ? "Admin" : "Customer"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapCounter += 1
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tapCounter == 8 {
            tapCounter = 0

            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username == %@", CustomLogic.CURRENT_USER!.username!)

            do {
                if let user = try context.fetch(fetchRequest).first {
                    user.isAdmin = !CustomLogic.CURRENT_USER!.isAdmin
                    try context.save()
                    
                    CustomLogic.CURRENT_USER = nil
                    UserDefaults.standard.set(nil, forKey: "username")
                    UserDefaults.standard.set(nil, forKey: "hashedPassword")
                    navigationController?.popToRootViewController(animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
}
