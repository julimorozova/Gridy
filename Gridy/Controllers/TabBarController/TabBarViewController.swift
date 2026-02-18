//
//  TabBarViewController.swift
//  Gridy
//
//  Created by Julia Morozova on 16. 2. 2026..
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let homeVC = createNav(with: HomeViewController(),
                               title: "Обзор",
                               image: "chart.bar",
                               tag: 0)

        let boardVC = createNav(with: BoardViewController(),
                                title: "Доска",
                                image: "square.grid.2x2",
                                tag: 1)

        let settingsVC = createNav(with: SettingsViewController(),
                                   title: "Настройки",
                                   image: "gearshape",
                                   tag: 2)

        viewControllers = [homeVC, boardVC, settingsVC]
    }

    private func createNav(with rootVC: UIViewController, title: String, image: String, tag: Int) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)

        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)


        return nav
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.greyApp,
            .font: UIFont.systemFont(ofSize: 12)
        ]

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .greyApp
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

    }

}
