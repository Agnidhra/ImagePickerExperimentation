//
//  MemeSentItemCollectionViewController.swift
//  MemeMe_Agnidhra
//
//  Created by Agnidhra Gangopadhyay on 2/23/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeSentCollectionViewCellID"

class MemeSentItemCollectionViewController: UICollectionViewController {

    //MARK: Instance properties
    let meme = (UIApplication.shared.delegate as! AppDelegate).meme
    let screenSize: CGRect = UIScreen.main.bounds
    
    //MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: View Setup Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 3
        flowLayout.itemSize = CGSize(width: CGFloat(self.screenSize.width/3 - 10), height: CGFloat(self.screenSize.width/3 - 10))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meme.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeSentItemCollectionViewCell
        cell.sentItemImage = setborder(imgView: cell.sentItemImage)
        cell.sentItemImage.image = meme[indexPath.row].memedImage
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller  = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        controller.meme = meme[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func setborder(imgView: UIImageView) -> UIImageView{
        imgView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
}
