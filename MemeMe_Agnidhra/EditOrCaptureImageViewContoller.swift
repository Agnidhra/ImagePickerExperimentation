//
//  ViewController.swift
//  ImagePickerExperimentation
//
//  Created by Agnidhra Gangopadhyay on 2/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class EditOrCaptureImageViewContoller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: Instance properties
    var meme: Meme? = nil
    let textFieldDelegate = TextFieldsDelegates()
    
    //MARK: Outlets
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var captureView: UIView!
    
    
    
    //MARK: Text Attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.green /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 7.00 /* TODO: fill in appropriate Float */
    ]
    
    //MARK: View Setup Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if(meme == nil) {
            setupInitialEditOrCaptureImageViewContoller()
        }else {
            setupEditModeImageViewContoller()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyBoardNotifications()
    }
    
    func setupInitialEditOrCaptureImageViewContoller() {
        updateFieldStates()
        updateDefaultState()
    }
    
    func setupEditModeImageViewContoller(){
        updateFieldStates()
        updateEditableState(meme: meme!)
    }

   
    //MARK: Delegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImageView.image = image
        }
        self.saveButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Notification Functions
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
        (UIApplication.shared.delegate as! AppDelegate).meme.append(meme)
    }
    
    func genereateMemedImage() -> UIImage {
        hideUnhideToolBars(topToolBar: true, bottomToolBar: true)
        UIGraphicsBeginImageContextWithOptions(self.captureView.frame.size, true, 0.0)
        self.captureView.drawHierarchy(in: self.captureView.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideUnhideToolBars(topToolBar: false, bottomToolBar: false)
        return memedImage
    }
    
    //MARK: Button tap functions
    @IBAction func tappedSaveButton(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: [genereateMemedImage()], applicationActivities: nil)
        present(controller, animated: true)
        controller.completionWithItemsHandler = {
                 (activity, success, items, error) in
                   if(success && error == nil){
                    self.save()
                    self.dismiss(animated: true, completion: nil);
                    self.launchTabbedViewController()
                   }
                   else if (error != nil){
                   }
               };
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        updateDefaultState()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedPickButton(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    
    //MARK: Reusable Functions
    func hideUnhideToolBars(topToolBar: Bool, bottomToolBar: Bool){
        self.topToolBar.isHidden = topToolBar
        self.bottomToolBar.isHidden = bottomToolBar
    }
    
    func updateDefaultState(){
        firstTextField.text = "TOP"
        secondTextField.text = "BOTTOM"
        saveButton.isEnabled = false
        pickedImageView.image = nil
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
    }
    
    func updateEditableState(meme: Meme){
        firstTextField.text = meme.topText
        secondTextField.text = meme.bottomText
        pickedImageView.image = meme.originalImage
        saveButton.isEnabled = true
    }
    
    func updateFieldStates(){
        pickedImageView.contentMode = UIView.ContentMode(rawValue: 1)!
        firstTextField.delegate = textFieldDelegate
        secondTextField.delegate = textFieldDelegate
        firstTextField.defaultTextAttributes = memeTextAttributes
        firstTextField.textAlignment = .center
        firstTextField.backgroundColor = UIColor.clear
        secondTextField.defaultTextAttributes = memeTextAttributes
        secondTextField.textAlignment = .center
        secondTextField.backgroundColor = UIColor.clear
    }

    //MARK: Navigation Functions
    func launchTabbedViewController(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarToViewSent") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = viewController;
        present(viewController, animated: true, completion: nil)
    }
}

