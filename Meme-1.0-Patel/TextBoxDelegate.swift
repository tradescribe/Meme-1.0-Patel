//
//  TextBoxDelegate.swift
//  Meme-1.0-Patel
//
//  Created by Harshal Patel on 4/24/16.
//  Copyright © 2016 Harshal Patel. All rights reserved.
//

import Foundation
import UIKit

class TextBoxDelegate : NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
