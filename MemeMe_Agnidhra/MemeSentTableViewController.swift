//
//  MemeSentTableViewController.swift
//  MemeMe_Agnidhra
//
//  Created by Agnidhra Gangopadhyay on 2/23/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class MemeSentTableViewController: UITableViewController {
    
    //MARK: Instance properties
    let meme = (UIApplication.shared.delegate as! AppDelegate).meme
    
    //MARK: View Setup Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 200.0
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeSentTableCellID", for: indexPath) as! MemeSentTableViewCell
        cell.memeImage = setborder(imgView: cell.memeImage)
        cell.memeImage.image = meme[indexPath.row].memedImage
        cell.topText.text = meme[indexPath.row].topText
        cell.bottomText.text = meme[indexPath.row].bottomText
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
