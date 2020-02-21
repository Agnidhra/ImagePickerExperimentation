//
//  textFieldsDelegates.swift
//  ImagePickerExperimentation
//
//  Created by Agnidhra Gangopadhyay on 2/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

class textFieldsDelegates: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
