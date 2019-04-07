//
//  AppDelegate.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 04/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import UIKit
import PDMovieKit_tvOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let main = FreeMoviesMain()
    func applicationDidFinishLaunching(_ application: UIApplication) {
        main.start()
    }
}
