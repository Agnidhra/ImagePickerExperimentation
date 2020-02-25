//
//  DetailsViewController.swift
//  MemeMe_Agnidhra
//
//  Created by Agnidhra Gangopadhyay on 2/23/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: Instance Properties
    var imageCV: UIImage? = nil
    var meme: Meme?

    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editMeme: UIButton!
    
    //MARK: Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = self.meme?.memedImage
    
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Navigation Functions
    @IBAction func tappedEdit(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "EditOrCaptureImageViewContoller") as! EditOrCaptureImageViewContoller
        viewController.meme = meme
        present(viewController, animated: true, completion: nil)
    }
}
