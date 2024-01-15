//
//  ViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 27/10/23.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak private var unameField: UITextField!
    @IBOutlet weak private var pwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        var errorMessage = ""
        let username = unameField.text ?? ""
        let password = pwordField.text ?? ""
        
        if(username.isEmpty || password.isEmpty) {
            errorMessage = "Please fill in the forms."
        } else if let response = getUser(uname: username, pword: password) {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(CustomLogic.hashPassword(str: password), forKey: "hashedPassword")
            CustomLogic.CURRENT_USER = response
            performSegue(withIdentifier: "LoginToMain", sender: self)
        } else {
            errorMessage = "Wrong username or password."
        }
        
        if(!errorMessage.isEmpty) {
            let alert = UIAlertController(title: "Sorry!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I Understand", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keepLogIn()
        
        unameField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Username")
        pwordField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Password")
    }

    private func getUser(uname: String, pword: String) -> User? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", uname.lowercased(), CustomLogic.hashPassword(str: pword))

        do {
            let users = try context.fetch(fetchRequest)
            return users.first ?? nil
        } catch {
            return nil
        }
    }
    
    private func keepLogIn() {
        guard let savedUsername = UserDefaults.standard.string(forKey: "username"), let savedHashedPassword = UserDefaults.standard.string(forKey: "hashedPassword") else {
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", savedUsername, savedHashedPassword)
            
        do {
            let users = try context.fetch(fetchRequest)
            if let res = users.first {
                CustomLogic.CURRENT_USER = res
                performSegue(withIdentifier: "LoginToMain", sender: self)
            } else {
                return
            }
        } catch {
            return
        }
    }
    
}

