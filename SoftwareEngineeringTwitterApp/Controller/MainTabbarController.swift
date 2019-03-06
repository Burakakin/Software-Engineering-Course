//
//  MainTabbarController.swift
//  SoftwareEngineeringTwitterApp
//
//  Created by Burak Akin on 26.02.2019.
//  Copyright © 2019 Burak Akin. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeFeedVC = storyboard.instantiateViewController(withIdentifier: "HomeFeedVC") as? HomeFeedVC else {
            print("Couldn' instantiate HomeFeedVC")
            return
        }
        guard let SearchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC else {
            print("Couldn' instantiate SearchVC")
            return
        }
        guard let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else {
            print("Couldn' instantiate ProfileVC")
            return
        }
        
        let homeFeed = createController(title: "Home", VC: homeFeedVC)
        let search = createController(title: "Search", VC: SearchVC)
        let profile = createController(title: "Profile", VC: ProfileVC)
        
        viewControllers = [homeFeed, search, profile]
        // Do any additional setup after loading the view.
    }
    

}



extension MainTabbarController {
    
    private func createController(title: String, VC: UIViewController) -> UINavigationController {
        
        let recentVC = UINavigationController(rootViewController: VC)
        //recentVC.setNavigationBarHidden(true, animated: false)
       
        recentVC.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        recentVC.navigationBar.shadowImage = UIImage()
        recentVC.navigationBar.isTranslucent = true
        recentVC.view.backgroundColor = UIColor.clear
       
        
        recentVC.tabBarItem.title = title
        //recentVC.tabBarItem.image = UIImage(named: imageName)
        
        return recentVC
        
    }
}
