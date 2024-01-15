//
//  RegisterViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 27/10/23.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    @IBOutlet weak private var unameField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var pwordField: UITextField!
    @IBOutlet weak private var conpwField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        var errorMessage = ""
        let username = unameField.text ?? ""
        let email = emailField.text ?? ""
        let password = pwordField.text ?? ""
        let confirmPassword = conpwField.text ?? ""
        
        if(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            errorMessage = "Please fill in the forms."
        } else if let unameRes = validateUsername(str: username) {
            errorMessage = unameRes
        } else if let emailRes = validateEmail(str: email) {
            errorMessage = emailRes
        } else if let pwordRes = validatePassword(str: password) {
            errorMessage = pwordRes
        } else if (password != confirmPassword) {
            errorMessage = "Password does not match."
        } else if (checkDuplication(uname: username, email: email)) {
            errorMessage = "Username/Email already in use."
        } else if let res = addUser(uname: username, email: email, pword: password) {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(CustomLogic.hashPassword(str: password), forKey: "hashedPassword")
            CustomLogic.CURRENT_USER = res
            performSegue(withIdentifier: "RegisterToMain", sender: self)
        } else {
            errorMessage = "Something went wrong."
        }
        
        if(!errorMessage.isEmpty) {
            let alert = UIAlertController(title: "Sorry!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I Understand", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        unameField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Username")
        emailField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Email")
        pwordField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Password")
        conpwField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Confirm Password")
    }
    
    private func validateUsername(str: String) -> String? {
        let len = str.count
        if(len < 5 || len > 16) {
            return "Username must be 5 - 16 characters."
        }
        return nil
    }
    
    private func validateEmail(str: String) -> String? {
        let REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let test = NSPredicate(format:"SELF MATCHES %@", REGEX)
        
        if(!test.evaluate(with: str)) {
            return "Invalid email address."
        }
        return nil
    }
    
    private func validatePassword(str: String) -> String? {
        let REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#_])[A-Za-z\\d$@$!%*?&#_]{8,16}"
        let test = NSPredicate(format:"SELF MATCHES %@", REGEX)
        let len = str.count
        
        if(len < 8 || len > 16) {
            return "Password must be 8 - 16 characters."
        } else if(!test.evaluate(with: str)) {
            return "Password must contain at least a symbol, an uppercase, an lowercase, and a number."
        }
        return nil
    }

    private func checkDuplication(uname: String, email: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ OR email == %@", uname, email)
        return ((try? context.count(for: fetchRequest)) ?? 0) > 0
    }
    
    private func addUser(uname: String, email: String, pword: String, isAdmin: Bool = false) -> User? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        user.username = uname.lowercased()
        user.email = email.lowercased()
        user.password = CustomLogic.hashPassword(str: pword)
        user.isAdmin = isAdmin
        
        do {
            try context.save()
            return user
        } catch {
            return nil
        }
    }
    
}
