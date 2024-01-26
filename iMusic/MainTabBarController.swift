//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Max on 25.01.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabBar.barTintColor = .lightGray
        view.backgroundColor = .cyan
        
        tabBar.tintColor = .red
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: "search", title: "Search"),
            generateViewController(rootViewController: ViewController(), image: "library", title: "Library")
        ]
    }
    
    
    private func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
        
    }
    
}
