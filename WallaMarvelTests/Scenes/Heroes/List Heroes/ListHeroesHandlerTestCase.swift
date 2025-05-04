//
//  ListHeroesHandlerTestCase.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 03-05-25.
//

import XCTest
@testable import WallaMarvel

final class ListHeroesHandlerTestCase: XCTestCase {

    // MARK: - Private Properties

    private var sut: ListHeroesHandler!
    private var getHeroesUseCaseMock: GetHeroesUseCaseMock!
    private var persistencyManagerMock: PersistencyManagerMock!
    
    // MARK: - Setup

    override func setUp() {
        super.setUp()
        getHeroesUseCaseMock = GetHeroesUseCaseMock()
        persistencyManagerMock = PersistencyManagerMock()
        sut = ListHeroesHandler(getHeroesUseCase: getHeroesUseCaseMock,
                                persistencyManager: persistencyManagerMock)
    }

    override func tearDown() {
        getHeroesUseCaseMock = nil
        persistencyManagerMock = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - GetData
    func testGetData_whenSuccess_shouldReturnData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(characters: receivedData))

        // When
        let data = try await sut.getData(initialHeroes: true, forceRefresh: false)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(persistencyManagerMock.saveHeroesDataCallCount, 1)
    }
    
    func testGetData_whenSuccessAndPaginated_shouldReturnData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 100,
                                                     characters: receivedData))

        // When
        // Make first call to get initial data
        _ = try await sut.getData(initialHeroes: true, forceRefresh: false)
        // Make second call that should add data to existing list
        let data = try await sut.getData(initialHeroes: false, forceRefresh: false)
        
        // Then
        XCTAssertEqual(data, [CharacterDataModel.make(), CharacterDataModel.make()])
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 2)
    }
    
    func testGetData_whenSuccessAndInitialDataTrue_shouldReturnInitialData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 100,
                                                     characters: receivedData))

        // When
        // Make first call to get initial data
        _ = try await sut.getData(initialHeroes: true, forceRefresh: false)
        // Make second call that should add data to existing list
        _ = try await sut.getData(initialHeroes: false, forceRefresh: false)
        // Make third call with initialHeroes true to reset data
        let data = try await sut.getData(initialHeroes: true, forceRefresh: false)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 3)
    }
    
    func testGetData_whenSuccessAndHasMoreDataFalse_shouldNotCallExecute() async {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 10,
                                                     characters: receivedData))

        // When
        do {
            // Make first call to get initial data and set HasMoreData
            _ = try await sut.getData(initialHeroes: true, forceRefresh: false)
            // Make second call but should return error
            _ = try await sut.getData(initialHeroes: false, forceRefresh: false)
        } catch {
            // Then
            XCTAssertTrue(error is PaginationError)
            XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        }
    }

    func testGetData_whenFailure_shouldReturnError() async {
        // Given
        getHeroesUseCaseMock.result = .failure(NetworkError.invalidResponse)

        // When
        do {
            _ = try await sut.getData(initialHeroes: true, forceRefresh: false)
        } catch {
            // Then
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        }
    }
    
    // MARK: - Persistency
    
    func testGetData_whenThereIsCachedDataAndNoForceRefresh_shouldReturnCachedData() async throws {
        // Given
        let heroes = [CharacterDataModel.make(name: "Orlando Man")]
        let cachedData = PaginationModel(offset: 1,
                                         total: 1,
                                         hasMoreData: true,
                                         heroes: heroes)
        persistencyManagerMock.paginationModel = cachedData

        // When
        let data = try await sut.getData(initialHeroes: true, forceRefresh: false)
        
        // Then
        XCTAssertEqual(data, heroes)
        XCTAssertEqual(persistencyManagerMock.loadHeroesDataCallCount, 1)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 0)
    }
    
    func testGetData_whenThereIsNoCachedDataAndNoForceRefresh_shouldReturnRequestData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(characters: receivedData))
        persistencyManagerMock.paginationModel = nil

        // When
        let data = try await sut.getData(initialHeroes: true, forceRefresh: false)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(persistencyManagerMock.loadHeroesDataCallCount, 1)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
    }

    func testGetData_whenThereCachedDataAndForceRefresh_shouldReturnRequestData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(characters: receivedData))
        let heroes = [CharacterDataModel.make(name: "Orlando Man")]
        let cachedData = PaginationModel(offset: 1,
                                         total: 1,
                                         hasMoreData: true,
                                         heroes: heroes)
        persistencyManagerMock.paginationModel = cachedData

        // When
        let data = try await sut.getData(initialHeroes: true, forceRefresh: true)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(persistencyManagerMock.clearCacheCallCount, 1)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        XCTAssertNil(persistencyManagerMock.paginationModel)
    }
}
