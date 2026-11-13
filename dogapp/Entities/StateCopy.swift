//
//  StateCopy.swift
//
//

import Foundation

struct StateCopy {
    let iconName: String?
    let title: String
    let subtitle: String?
    let buttonTitle: String?
    
    init(
        title: String,
        iconName: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
    }
}

extension StateCopy {
    static let genericError = StateCopy(
        title: String(localized: .somethingWentWrong),
        iconName: Symbols.genericWarning,
        subtitle: String(localized: .pleaseTryAgain),
        buttonTitle: String(localized: .tryAgain)
    )
    
    static let emptyBreedList = StateCopy(
        title: String(localized: .noBreedsAvailable),
        iconName: Symbols.genericEmpty
    )

    static let breedListError = StateCopy(
        title: String(localized: .breedsFetchFailed),
        iconName: Symbols.genericWarning,
        buttonTitle: String(localized: .tryAgain)
    )
    
    static let imageLoadError = StateCopy(
        title: String(localized: .imageLoadFailed),
        iconName: Symbols.genericWarning,
        buttonTitle: String(localized: .tapToTryAgain)
    )
    
    static let emptyHistory = StateCopy(
        title: String(localized: .noRecentSearchHistory),
        iconName: Symbols.noResult,
        subtitle: String(localized: .recentSearchHistoryHint)
    )
    
    static func noResults(query: String) -> StateCopy {
        StateCopy(
            title: String(localized: .noResults),
            iconName: Symbols.noResult,
            subtitle: String(localized: .noBreedsMatch(query))
        )
    }
    
    static let emptyFavourites = StateCopy(
        title: String(localized: .noFavourites),
        iconName: Symbols.genericEmpty
    )
    
    static let favouriteFetchError = StateCopy(
        title: String(localized: .favouritesFetchFailed),
        iconName: Symbols.genericWarning,
        buttonTitle: String(localized: .tryAgain)
    )
    
    static let emptyBreedsImages = StateCopy(
        title: String(localized: .noPicturesForBreed),
        iconName: Symbols.genericEmpty
    )
    
    static let breedImagesFetchError = StateCopy(
        title: String(localized: .picturesFetchFailed),
        iconName: Symbols.genericWarning,
        buttonTitle: String(localized: .tryAgain)
    )
}
