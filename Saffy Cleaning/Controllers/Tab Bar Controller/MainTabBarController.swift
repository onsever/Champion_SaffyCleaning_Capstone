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
        let chatNC = UINavigationController(rootViewController: chatVC)
        let historyNC = UINavigationController(rootViewController: historyVC)
        let settingsNC = UINavigationController(rootViewController: settingsVC)
        let profileNC = UINavigationController(rootViewController: profileVC)

        viewControllers = [homeNC, chatNC, historyNC, settingsNC, profileNC]
    }
    
}
