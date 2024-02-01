//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Max on 25.01.2024.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailControler()
}

class MainTabBarController: UITabBarController {
    
    private var minimazedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabBar.barTintColor = .lightGray
        tabBar.backgroundColor = .lightGray
        
        tabBar.tintColor = .red
        
        setupTrackDetailView()
        
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
    
    private func setupTrackDetailView() {
        
        print("Setup -------- track detail view")
        
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.backgroundColor = .green
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minimazedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        maximizedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    
    func minimizeTrackDetailControler() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimazedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
        },
                       completion: nil)

    }
    
}
