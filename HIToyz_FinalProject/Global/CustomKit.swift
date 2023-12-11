//
//  CustomKit.swift
//  HIToyz_FinalProject
//
//  Created by prk on 10/30/23.
//

import UIKit
import Foundation

class CustomKit {
    
    public static func stylePlaceholder(placeholder:String) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes:  [NSAttributedString.Key.foregroundColor:UIColor(named: "ForegroundRaisedColor")!])
    }
}
