//
//  ViewController.swift
//  ImagePickerExperimentation
//
//  Created by Agnidhra Gangopadhyay on 2/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var captureView: UIView!
    
    let textFieldDelegate = textFieldsDelegates()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.green /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.blue/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 5.00 /* TODO: fill in appropriate Float */
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickedImageView.contentMode = UIView.ContentMode(rawValue: 1)!
        firstTextField.delegate = textFieldDelegate
        secondTextField.delegate = textFieldDelegate
        firstTextField.defaultTextAttributes = memeTextAttributes
        firstTextField.textAlignment = .center
        firstTextField.backgroundColor = UIColor.clear
        secondTextField.defaultTextAttributes = memeTextAttributes
        secondTextField.textAlignment = .center
        secondTextField.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyBoardNotifications()
    }

    @IBAction func tappedPickButton(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Understand Notifications
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if(secondTextField.isEditing) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstTextField.endEditing(true)
        secondTextField.endEditing(true)
    }
    
    
    //MARK: Saving Functions and Generating Meme object
    
    func save() {
        let meme = Meme(topText: firstTextField.text!, bottomText: secondTextField.text!, originalImage: pickedImageView.image!, memedImage: self.genereateMemedImage() )
    }
    
    func genereateMemedImage() -> UIImage {
        //UIGraphicsBeginImageContext(self.view.frame.size)
        UIGraphicsBeginImageContextWithOptions(self.captureView.frame.size, true, 0.0)
        //UIGraphicsBeginImageContext(self.captureView.frame.size)
        //view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        view.drawHierarchy(in: self.captureView.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
        
    @IBAction func tappedSaveButton(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: [genereateMemedImage()], applicationActivities: nil)
        present(controller, animated: true)
        controller.completionWithItemsHandler = {
                 (activity, success, items, error) in
                   if(success && error == nil){
                    self.save()
                    self.dismiss(animated: true, completion: nil);
                   }
                   else if (error != nil){
                       //log the error
                   }
               };

    }
}

