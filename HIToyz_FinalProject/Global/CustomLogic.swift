//
//  CustomLogic.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//

import Foundation
import CommonCrypto
import UIKit

class CustomLogic {
    
    public static var CURRENT_USER: User?
    
    public static var CART_ITEM: [CartItem] = []
    
    public static func hashPassword(str: String) -> String {
        if let data = str.data(using: .utf8) {
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes { buffer in
                _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
            }
            return hash.map { String(format: "%02hhx", $0) }.joined()
        }
        return str
    }
    
    public static func getGreetings() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
            case 0..<11:
                return "Good Morning,"
            case 11..<15:
                return "Good Day,"
            case 15..<19:
                return "Good Evening,"
            default:
                return "Good Night,"
            }
    }
    
    public static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
}
