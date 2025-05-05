//
//  ListHeroesPresenterTestCase.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 02-05-25.
//

import XCTest
@testable import WallaMarvel

final class ListHeroesPresenterTestCase: XCTestCase {

    // MARK: - Private Properties

    private var sut: ListHeroesPresenter!
    private var listHeroesHandlerMock: ListHeroesHandlerMock!
    private var listHeroesUIMock: ListHeroesUIMock!
    
    // MARK: - Setup

    override func setUp() {
        super.setUp()
        
        listHeroesUIMock = ListHeroesUIMock()
        listHeroesHandlerMock = ListHeroesHandlerMock()
        sut = ListHeroesPresenter(listHeroeHandler: listHeroesHandlerMock)
        sut.ui = listHeroesUIMock
    }

    override func tearDown() {
        listHeroesHandlerMock = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Show Screen Title

    func testScreenTitle() throws {
        // When
        let title = sut.screenTitle()
        
        // Then
        XCTAssertEqual(title, "List of Heroes")
    }
    
    // MARK: - Show Hero

    func testShowHeroDetail() {
        // Given
        let expectation = expectation(description: "Should receive hero")
        let hero = CharacterDataModel(id: 1234,
                                      name: "Orlando",
                                      thumbnail: Thumbnail(path: "path",
                                                           extension: "extension"))
        
        var receivedHero: CharacterDataModel?
        
        sut.showHeroDetail = { hero in
            receivedHero = hero
            expectation.fulfill()
        }

        // When
        sut.showHeroDetail(forHero: hero)
        
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(receivedHero, hero)
    }
    
    // MARK: - Get Heroes

    func testGetHeroes_whenIsSearching_shouldNotMakeCall() {
        // Given
        sut.setupSearchMode(isSearching: true)
        
        // When
        sut.getHeroes(initialHeroes: true, forceRefresh: false)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getDataCallCount, 0)
    }
    
    func testGetHeroes_whenIsSuccessful_shouldReturnHeroes() {
        // Given
        let expectation = expectation(description: "Should receive heroes")
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)
        
        listHeroesUIMock.updateHeroesCompletion = {
            expectation.fulfill()
        }

        // When
        sut.getHeroes(initialHeroes: true, forceRefresh: false)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(listHeroesHandlerMock.getDataCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.updateCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.hideInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.heroes, heroes)
    }
    
    func testGetHeroes_whenIsFailureAndInitialHeroes_shouldNotReturnHeroes() {
        // Given
        let expectation = expectation(description: "Should receive error")
        
        listHeroesHandlerMock.result = .failure(PaginationError.noMoreData)
        
        listHeroesUIMock.showErrorCompletion = {
            expectation.fulfill()
        }

        // When
        sut.getHeroes(initialHeroes: true, forceRefresh: false)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(listHeroesHandlerMock.getDataCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.hideInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showErrorCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.errorMessage, "There is no more data")
    }

    func testGetHeroes_whenIsFailureAndNoInitialHeroes_shouldNotReturnHeroes() {
        // Given
        let expectation = expectation(description: "Should receive error")
        
        listHeroesHandlerMock.result = .failure(PaginationError.noMoreData)
        
        listHeroesUIMock.showErrorPaginationCompletion = {
            expectation.fulfill()
        }

        // When
        sut.getHeroes(initialHeroes: false, forceRefresh: false)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(listHeroesHandlerMock.getDataCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showPaginationLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.hidePaginationLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showErrorPaginationCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.errorMessage, "There is no more data")
    }
    
    func testGetHeroes_whenIsFetching_shouldCallJustOnce() {
        // Given
        let expectation = expectation(description: "Should receive heroes")
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)
        
        listHeroesUIMock.updateHeroesCompletion = {
            expectation.fulfill()
        }

        // When
        sut.getHeroes(initialHeroes: true, forceRefresh: false)
        sut.getHeroes(initialHeroes: true, forceRefresh: false)

        waitForExpectations(timeout: 1)

        // Then
        XCTAssertEqual(listHeroesHandlerMock.getDataCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.updateCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.hideInitialLoadingCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.heroes, heroes)
    }
    
    // MARK: - Search Heroes
    
    func testSearchHero_whenSuccess_shouldReturnRequestedHeroes() {
        // Given
        let expectation = expectation(description: "Should receive requested heroes")
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)
        listHeroesUIMock.updateFromSearchCompletion = {
            expectation.fulfill()
        }

        // When
        sut.searchHero(withText: "Orlando")
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.updateFromSearchCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.heroes, heroes)
    }
    
    func testSearchHero_whenSuccessButEmptyHeroes_shouldShowError() {
        // Given
        let expectation = expectation(description: "Should show error")
        let heroes = [CharacterDataModel]()
        listHeroesHandlerMock.result = .success(heroes)
        listHeroesUIMock.showErrorCompletion = {
            expectation.fulfill()
        }

        // When
        sut.searchHero(withText: "Orlando")
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.showErrorCallCount, 1)
    }
    
    func testSearchHero_whenSuccessAndDebounce_shouldReturnRequestedHeroesOnce() {
        // Given
        let expectation = expectation(description: "Should receive requested heroes")
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)
        listHeroesUIMock.updateFromSearchCompletion = {
            expectation.fulfill()
        }

        // When
        sut.searchHero(withText: "Orl")
        sut.searchHero(withText: "Orlan")
        
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 1)
        XCTAssertEqual(listHeroesHandlerMock.searchText, "Orlan")
        XCTAssertEqual(listHeroesUIMock.updateFromSearchCallCount, 1)
        XCTAssertEqual(listHeroesUIMock.heroes, heroes)
    }
    
    func testSearchHero_whenEmptyString_shouldResetHeroes() {
        // Given
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)

        // When
        sut.searchHero(withText: "")
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 0)
        XCTAssertEqual(listHeroesUIMock.resetResultsCallCount, 1)
    }
    
    func testSearchHero_whenStringNil_shouldResetHeroes() {
        // Given
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)

        // When
        sut.searchHero(withText: nil)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 0)
        XCTAssertEqual(listHeroesUIMock.resetResultsCallCount, 1)
    }
    
    func testSearchHero_whenSearchingAndDeleting_shouldNot() {
        // Given
        let heroes = [CharacterDataModel(id: 1234,
                                         name: "Orlando",
                                         thumbnail: Thumbnail(path: "",
                                                              extension: ""))]
        listHeroesHandlerMock.result = .success(heroes)

        // When
        sut.searchHero(withText: nil)
        
        // Then
        XCTAssertEqual(listHeroesHandlerMock.getRequestedHeroesCallCount, 0)
        XCTAssertEqual(listHeroesUIMock.resetResultsCallCount, 1)
    }
}
