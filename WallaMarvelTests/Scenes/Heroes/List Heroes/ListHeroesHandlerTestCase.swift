//
//  ListHeroesHandlerTestCase.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 03-05-25.
//

import XCTest
@testable import WallaMarvel

final class ListHeroesHandlerTestCase: XCTestCase {

    private var sut: ListHeroesHandler!
    private var getHeroesUseCaseMock: GetHeroesUseCaseMock!
    override func setUp() {
        super.setUp()
        getHeroesUseCaseMock = GetHeroesUseCaseMock()
        sut = ListHeroesHandler(getHeroesUseCase: getHeroesUseCaseMock)
    }

    override func tearDown() {
        getHeroesUseCaseMock = nil
        sut = nil
        super.tearDown()
    }

    func testData_whenSuccess_shouldReturnData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(characters: receivedData))

        // When
        let data = try await sut.getData(initialHeroes: true)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
    }
    
    func testData_whenSuccessAndPaginated_shouldReturnData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 100,
                                                     characters: receivedData))

        // When
        // Make first call to get initial data
        _ = try await sut.getData(initialHeroes: true)
        // Make second call that should add data to existing list
        let data = try await sut.getData(initialHeroes: false)
        
        // Then
        XCTAssertEqual(data, [CharacterDataModel.make(), CharacterDataModel.make()])
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 2)
    }
    
    func testData_whenSuccessAndInitialDataTrue_shouldReturnInitialData() async throws {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 100,
                                                     characters: receivedData))

        // When
        // Make first call to get initial data
        _ = try await sut.getData(initialHeroes: true)
        // Make second call that should add data to existing list
        _ = try await sut.getData(initialHeroes: false)
        // Make third call with initialHeroes true to reset data
        let data = try await sut.getData(initialHeroes: true)
        
        // Then
        XCTAssertEqual(data, receivedData)
        XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 3)
    }
    
    func testData_whenSuccessAndHasMoreDataFalse_shouldNotCallExecute() async {
        // Given
        let receivedData = [CharacterDataModel.make()]
        getHeroesUseCaseMock.result = .success(.make(count: 10,
                                                     total: 10,
                                                     characters: receivedData))

        // When
        do {
            // Make first call to get initial data and set HasMoreData
            _ = try await sut.getData(initialHeroes: true)
            // Make second call but should return error
            _ = try await sut.getData(initialHeroes: false)
        } catch {
            // Then
            XCTAssertTrue(error is PaginationError)
            XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        }
    }

    func testData_whenFailure_shouldReturnError() async {
        // Given
        getHeroesUseCaseMock.result = .failure(NetworkError.invalidResponse)

        // When
        do {
            _ = try await sut.getData(initialHeroes: true)
        } catch {
            // Then
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(getHeroesUseCaseMock.executeCallCount, 1)
        }
    }
}
