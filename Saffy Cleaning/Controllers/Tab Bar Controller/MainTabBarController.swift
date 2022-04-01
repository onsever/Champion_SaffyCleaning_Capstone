//
//  MainTabBarController.swift
//  Saffy Cleaning
//
//  Created by Onurcan Sever on 2022-03-09.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    private var user: User?  = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        fetchUserData()
    }
    
    private func fetchUserData() {
        FirebaseDBService.service.retrieveUser { [weak self] user in
            if let user = user {
                self?.configure(user: user)
            }
        }
    }
}

extension MainTabBarController {
    
    private func configure(user: User) {
        let homeVC = HomeViewController(currentUser: user)
        let chatVC = ChatListViewController(currentUser: user)
        let historyVC = HistoryViewController()
        let noticeVC = NoticeViewController()
        let profileVC = ProfileViewController()
        
        profileVC.delegate = homeVC
    
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "text.bubble"), tag: 1)
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "gobackward"), tag: 2)
        noticeVC.tabBarItem = UITabBarItem(title: "Notice", image: UIImage(systemName: "bell"), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let chatNC = UINavigationController(rootViewController: chatVC)
        chatNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let historyNC = UINavigationController(rootViewController: historyVC)
        historyNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let noticeNC = UINavigationController(rootViewController: noticeVC)
        noticeNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandDark, NSAttributedString.Key.font: UIFont.urbanistMedium(size: 16)!]

        viewControllers = [homeNC, chatNC, noticeNC, historyNC, profileNC]
    }
    
    private func configureLayout() {
        UITabBar.appearance().tintColor = .brandGem
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.urbanistRegular(size: 14)!], for: .normal)
        UITabBar.appearance().unselectedItemTintColor = .brandLake
        view.backgroundColor = .white
    }
}
