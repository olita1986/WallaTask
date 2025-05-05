import XCTest
@testable import WallaMarvel

class WallaMarvelUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp()  {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["REMOVE_PERSISTENCY"]
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testLoadHeroes_whenSuccess_shouldShowHeroes() {
        app.launchArguments += ["ENABLE_STUBS"]
        app.launch()
        let tableView = app.tables[AccessibilityIdentifiers.HeroList.heroeTableView]
        
        XCTAssertTrue(tableView.waitForExistence(timeout: 2), "TableView should exist")
        
        let cells = tableView.cells
        
        XCTAssertEqual(cells.count, 1, "Should show one hero")
        
        let cell = tableView.cells.element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 1), "Cell should exist")
        
        XCTAssertEqual(cells.staticTexts.element.label, "Spider-Man")
    }

    func testLoadHeroes_whenTapOnHero_shouldShowDetailView() {
        app.launchArguments += ["ENABLE_STUBS"]
        app.launch()
        let tableView = app.tables[AccessibilityIdentifiers.HeroList.heroeTableView]
        
        XCTAssertTrue(tableView.waitForExistence(timeout: 2), "TableView should exist")
        
        let cells = tableView.cells
        
        XCTAssertEqual(cells.count, 1, "Should show one hero")
        
        let cell = tableView.cells.element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 1), "Cell should exist")
        
        XCTAssertEqual(cells.staticTexts.element.label, "Spider-Man")
        
        cell.tap()
        
        let comicLabel = app.staticTexts[AccessibilityIdentifiers.HeroDetail.heroDetailComicLabel]
        
        XCTAssertTrue(comicLabel.waitForExistence(timeout: 1), "Comic Label should exist")
        
    }
    
    func testLoadHeroes_whenError_shouldShowAlert() {
        app.launchArguments += ["ENABLE_STUBS_ERROR"]
        app.launch()
        
        let alertView = app.alerts[AccessibilityIdentifiers.General.alert]
        
        XCTAssertTrue(alertView.waitForExistence(timeout: 1), "Alert should exist")
        
        alertView.buttons["OK"].tap()
        
        XCTAssertFalse(alertView.exists, "Alert should not exist")
    }
}
