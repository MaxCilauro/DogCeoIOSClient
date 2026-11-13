//
//  BreedSearchViewController.swift
//
//

import UIKit
import SwiftUI
import Foundation

final class BreedSearchViewController: UIHostingController<BreedSearch>, UISearchResultsUpdating, UISearchControllerDelegate {
    private let viewModel: BreedSearchViewModel
    private lazy var searchController = {
        let controller = UISearchController()
        controller.delegate = self
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        
        return controller
    }()
    
    private let navigateTo: NavigateTo

    init(
        viewModel: BreedSearchViewModel,
        imageCacheManager: ImageCacheManager,
        navigateTo: @escaping NavigateTo
    ) {
        self.viewModel = viewModel
        self.navigateTo = navigateTo

        super.init(rootView: BreedSearch(viewModel: viewModel, imageCacheManager: imageCacheManager))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView.navigateTo = { [weak self] destination in
            guard let self else { return }

            self.navigateTo(destination, self)
        }

        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.searchController = self.searchController
        self.navigationItem.largeTitleDisplayMode = .inline
        self.navigationItem.title = String(localized: .searchTitle)
        self.navigationItem.subtitle = String(localized: .searchSubtitle)
    }

    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.results.query = searchController.searchBar.text ?? ""
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.viewModel.isSearchActive = true
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.viewModel.isSearchActive = false
        }
    }
}
