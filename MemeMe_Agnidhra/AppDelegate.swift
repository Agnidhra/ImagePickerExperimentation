//
//  AppDelegate.swift
//  ImagePickerExperimentation
//
//  Created by Agnidhra Gangopadhyay on 2/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var meme = [Meme]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
}

