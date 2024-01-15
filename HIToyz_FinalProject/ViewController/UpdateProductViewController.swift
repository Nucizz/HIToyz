//
//  UpdateProductViewController.swift
//  HIToyz_FinalProject
//
//  Created by prk on 07/12/23.
//

import UIKit
import CoreData

class UpdateProductViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: UpdateProductDelegate?
    var product: Product?
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var productNameField: UITextField!
    @IBOutlet weak private var productPriceField: UITextField!
    @IBOutlet weak private var productCategoryField: UITextField!
    @IBOutlet weak private var productDescriptionText: UITextView!
    
    @IBAction private func saveButton(_ sender: Any) {
        var errorMessage = ""
        let image = imageView.image
        let name = productNameField.text!
        let price = productPriceField.text!
        let category = productCategoryField.text!
        let description = productDescriptionText.text!
        
        if(name.isEmpty || price.isEmpty || category.isEmpty || description.isEmpty || (image == nil)) {
            errorMessage = "Please fill in the forms and change the image."
        } else if let nameRes = validateName(str: name) {
            errorMessage = nameRes
        } else if let priceRes = validatePrice(str: price) {
            errorMessage = priceRes
        } else if let descRes = validateDescription(str: description) {
            errorMessage = descRes
        } else if let newProduct = updateProduct(name: name, price: price, category: category, description: description, image: image!) {
            delegate?.didChangeProduct(product: newProduct)
            navigationController?.popViewController(animated: true)
        } else {
            errorMessage = "Something went wrong!"
        }
        
        if(!errorMessage.isEmpty) {
            let alert = UIAlertController(title: "Sorry!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I Understand", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func validateName(str: String) -> String? {
        let len = str.count
        if(len < 3 || len > 32) {
            return "Name must be 3 - 32 characters."
        }
        return nil
    }
    
    private func validatePrice(str: String) -> String? {
        let REGEX = "^[0-9]+$"
        let test = NSPredicate(format: "SELF MATCHES %@", REGEX)
        if (!test.evaluate(with: str)) {
            return "Price must only contain numbers"
        }
        return nil
    }
    
    private func validateDescription(str: String) -> String? {
        let len = str.count
        if(len < 16 || len > 256) {
            return "Description  must be 16 - 256 characters."
        }
        return nil
    }
    
    private let toyCategories = ["Action Figure", "Puzzle", "Soft Doll", "Hard Doll", "Automotive", "Remote Control"]
    
    private lazy var categoryPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toyCategories.count
    }

    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toyCategories[row]
    }

    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productCategoryField.text = toyCategories[row]
    }
    
    @objc private func onImageChangeTapped(){
        let alert = UIAlertController(title: "Source", message: "Pick your image source.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.onImageChange(source: "camera")}))
        alert.addAction(UIAlertAction(title: "Photos Library", style: .default, handler: { _ in self.onImageChange(source: "photo")}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        self.present(alert, animated: true)
    }
    
    private func onImageChange(source: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case "camera":
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        case "photo":
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        default:
            return
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Product"
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "AccentColor") as Any]

        productNameField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Product Name")
        productPriceField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Product Price")
        productCategoryField.attributedPlaceholder = CustomKit.stylePlaceholder(placeholder: "Product Category")
        
        imageView.image = CustomLogic.loadImageFromDocumentDirectory(fileName: product!.imageUrl!)
        productNameField.text = product!.name
        productPriceField.text = "\(product!.price)"
        productCategoryField.text = product!.category
        productDescriptionText.text = product!.desc
        
        productCategoryField.inputView = categoryPicker
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageChangeTapped)))
    }
    
    private func updateProduct(name: String, price: String, category: String, description: String, image: UIImage) -> Product? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", product!.name!)
        
        do {
            if let existingProduct = try context.fetch(fetchRequest).first {
                existingProduct.name = name
                existingProduct.price = Float(price)!
                existingProduct.category = category
                existingProduct.desc = description
                
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = documentsDirectory.appendingPathComponent(existingProduct.imageUrl!)
                        do {
                            try imageData.write(to: fileURL)
                            try context.save()
                            return existingProduct
                        } catch {
                            return nil
                        }
                    }
                }
            } else {
                return nil
            }
        } catch {
            return nil
        }
        return nil
    }
}

protocol UpdateProductDelegate: AnyObject {
    func didChangeProduct(product: Product?)
}
