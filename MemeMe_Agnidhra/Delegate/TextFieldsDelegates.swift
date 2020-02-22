//
//  textFieldsDelegates.swift
//  ImagePickerExperimentation
//
//  Created by Agnidhra Gangopadhyay on 2/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

class TextFieldsDelegates: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if((textField.text?.elementsEqual("TOP"))! || (textField.text?.elementsEqual("BOTTOM"))!) {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string.count>0){
            textField.text = textField.text! + string.uppercased()
            return false
        } else {
            return true
        }
        
    }

}


