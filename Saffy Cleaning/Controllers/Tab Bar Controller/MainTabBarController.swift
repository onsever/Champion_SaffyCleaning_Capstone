//
//  MainTabBarController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
}

extension MainTabBarController {
    
    private func configure() {
        
        UITabBar.appearance().tintColor = .brandGem
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 14)!], for: .normal)
        UITabBar.appearance().unselectedItemTintColor = .brandLake
        view.backgroundColor = .white
        
        let homeVC = HomeViewController()
        let chatVC = ChatViewController()
        let historyVC = HistoryViewController()
        let settingsVC = SettingsViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "text.bubble"), tag: 1)
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "gobackward"), tag: 2)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let chatNC = UINavigationController(rootViewController: chatVC)
        chatNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let historyNC = UINavigationController(rootViewController: historyVC)
        historyNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let settingsNC = UINavigationController(rootViewController: settingsVC)
        settingsNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]

        viewControllers = [homeNC, chatNC, historyNC, settingsNC, profileNC]
    }
    
}