//
//  ListHeroesUIMock.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 02-05-25.
//

import Foundation
@testable import WallaMarvel

final class ListHeroesUIMock: ListHeroesUI {
    private(set) var showPaginationLoadingCallCount = 0
    private(set) var hidePaginationLoadingCallCount = 0
    private(set) var showInitialLoadingCallCount = 0
    private(set) var hideInitialLoadingCallCount = 0
    private(set) var showErrorCallCount = 0
    private(set) var showErrorPaginationCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var updateFromSearchCallCount = 0
    private(set) var resetResultsCallCount = 0
    private(set) var errorMessage = ""
    
    private(set) var heroes = [CharacterDataModel]()
    
    var updateHeroesCompletion: (() -> Void)?
    var updateFromSearchCompletion: (() -> Void)?
    var showErrorPaginationCompletion: (() -> Void)?
    var showErrorCompletion: (() -> Void)?

    func showPaginationLoading() {
        showPaginationLoadingCallCount += 1
    }
    
    func hidePaginationLoading() {
        hidePaginationLoadingCallCount += 1
    }
    
    func showInitialLoading() {
        showInitialLoadingCallCount += 1
    }
    
    func hideInitialLoading() {
        hideInitialLoadingCallCount += 1
    }
    
    func showError(_ error: String) {
        defer { showErrorCompletion?() }
        errorMessage = error
        showErrorCallCount += 1
    }
    
    func showErrorPagination(_ error: String) {
        defer { showErrorPaginationCompletion?() }
        errorMessage = error
        showErrorPaginationCallCount += 1
    }
    
    func update(heroes: [CharacterDataModel]) {
        defer { updateHeroesCompletion?() }
        self.heroes = heroes
        updateCallCount += 1
    }
    
    func updateFromSearch(heroes: [WallaMarvel.CharacterDataModel]) {
        defer { updateFromSearchCompletion?() }
        updateFromSearchCallCount += 1
        self.heroes = heroes
    }
    
    func resetResults() {
        resetResultsCallCount += 1
    }
}
