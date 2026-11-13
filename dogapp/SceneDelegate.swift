//
//  SceneDelegate.swift
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let dependencies = AppDependencies()
    private lazy var factory = AppFactory(dependencies: self.dependencies)

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        Task { [weak self] in
            await self?.dependencies.favouriteStore.loadIfNeeded()
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController(tabs: [
            .init(
                title: String(localized: .breedsTitle),
                image: UIImage.init(systemName: "pawprint"),
                identifier: "breeds",
                viewControllerProvider: { [unowned self] _ in
                    UINavigationController(rootViewController: self.factory.makeBreedList())
                }
            ),
            .init(
                title: String(localized: .favouritesTitle),
                image: UIImage.init(systemName: "heart"),
                identifier: "favourites",
                viewControllerProvider: { [unowned self] _ in
                    UINavigationController(
                        rootViewController: self.factory.makeFavouritesGrid()
                    )
                }
            ),
            UISearchTab { [unowned self] _ in
                UINavigationController(
                    rootViewController: self.factory.makeBreedSearch()
                )
            }
        ])
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.window = window
    }

}
