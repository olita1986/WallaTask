//
//  PersistencyManagerTestCase.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 04-05-25.
//

import XCTest
@testable import WallaMarvel

final class PersistencyManagerTestCase: XCTestCase {

    // MARK: - Private Properties

    private var sut: PersistencyManager!
    private var userDefaultsMock: UserDefaultsMock!
    
    // MARK: - Setup

    override func setUp() {
        super.setUp()
        userDefaultsMock = UserDefaultsMock(suiteName: "Test")
        sut = PersistencyManager(userDefaults: userDefaultsMock)
    }

    override func tearDown() {
        userDefaultsMock.removePersistentDomain(forName: "Test")
        userDefaultsMock = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - SaveHeroes

    func testSaveHeroesData() {
        // Given
        let data = PaginationModel(offset: 1,
                                   hasMoreData: true,
                                   heroes: [.make()])
        
        // When
        sut.saveHeroesData(heroesData: data)
        
        // Then
        XCTAssertEqual(userDefaultsMock.setCallCount, 1)
    }

    // MARK: - Load Heroes

    func testLoadHeroesData_whenThereIsData_shouldReturnData() {
        // Given
        let data = PaginationModel(offset: 1,
                                   hasMoreData: true,
                                   heroes: [.make()])
        
        // When
        sut.saveHeroesData(heroesData: data)
        let chachedData = sut.loadHeroesData()
        
        // Then
        XCTAssertEqual(userDefaultsMock.setCallCount, 1)
        XCTAssertEqual(userDefaultsMock.dataCallCount, 1)
        XCTAssertEqual(chachedData, data)
    }
    
    func testLoadHeroesData_whenThereIsNoData_shouldReturnNil() {
        // When
        let chachedData = sut.loadHeroesData()
        
        // Then
        XCTAssertEqual(userDefaultsMock.dataCallCount, 1)
        XCTAssertNil(chachedData)
    }
    
    // MARK: - Clear Cache

    func testClearCache_whenThereIsData_shoulRemoveData() {
        // Given
        let data = PaginationModel(offset: 1,
                                   hasMoreData: true,
                                   heroes: [.make()])
        
        // When
        sut.saveHeroesData(heroesData: data)
        let chachedData = sut.loadHeroesData()
        
        // Then
        XCTAssertEqual(userDefaultsMock.setCallCount, 1)
        XCTAssertEqual(userDefaultsMock.dataCallCount, 1)
        XCTAssertEqual(chachedData, data)
        
        // When
        sut.clearCache()
        let chachedData2 = sut.loadHeroesData()
        
        // Then
        XCTAssertEqual(userDefaultsMock.removeObjectCallCount, 1)
        XCTAssertEqual(userDefaultsMock.dataCallCount, 2)
        XCTAssertNil(chachedData2)
    }
}
