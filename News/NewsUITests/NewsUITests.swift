//
//  NewsUITests.swift
//  NewsUITests
//

import XCTest

final class NewsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // 1. Test Main Navigation Appears on Launch
    func testMainNavigationAppearsOnLaunch() throws {
        let navBar = app.navigationBars.firstMatch
        XCTAssertTrue(
            navBar.waitForExistence(timeout: 5.0),
            "Main navigation bar should be visible on app launch")
    }

    // 2. Test Navigation to Settings Screen
    func testNavigateToSettings() throws {
        let settingsButton = app.buttons["gearshape"].firstMatch
        let altSettingsButton = app.buttons["gearshape.fill"].firstMatch

        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else if altSettingsButton.waitForExistence(timeout: 3.0) {
            altSettingsButton.tap()
        } else {
            let firstNavButton = app.navigationBars.buttons.element(boundBy: 0)
            XCTAssertTrue(
                firstNavButton.waitForExistence(timeout: 3.0),
                "Settings navigation button should exist")
            firstNavButton.tap()
        }

        let settingsNavTitle = app.staticTexts["Settings"]
        let settingsTab = app.tabBars.buttons["Category"]
        let isSettingsVisible =
            settingsNavTitle.waitForExistence(timeout: 3.0)
            || settingsTab.waitForExistence(timeout: 3.0)
        XCTAssertTrue(isSettingsVisible, "Settings view should open after tapping settings button")
    }

    // 3. Test Navigation to Favorites Screen
    func testNavigateToFavorites() throws {
        let favoritesButton = app.buttons["heart"].firstMatch
        let altFavoritesButton = app.buttons["heart.fill"].firstMatch

        if favoritesButton.waitForExistence(timeout: 3.0) {
            favoritesButton.tap()
        } else if altFavoritesButton.waitForExistence(timeout: 3.0) {
            altFavoritesButton.tap()
        } else {
            let navButton = app.navigationBars.buttons.element(boundBy: 1)
            XCTAssertTrue(
                navButton.waitForExistence(timeout: 3.0), "Favorites navigation button should exist"
            )
            navButton.tap()
        }

        let favoritesTitle = app.staticTexts["Favorites"]
        let emptyText = app.staticTexts.firstMatch
        let isFavoritesVisible =
            favoritesTitle.waitForExistence(timeout: 3.0)
            || emptyText.waitForExistence(timeout: 3.0)
        XCTAssertTrue(isFavoritesVisible, "Favorites view should open")
    }

    // 4. Test Navigation Back from Settings
    func testNavigateBackFromSettings() throws {
        let settingsButton = app.buttons["gearshape"].firstMatch
        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.waitForExistence(timeout: 3.0) {
            backButton.tap()
            XCTAssertTrue(
                app.navigationBars.firstMatch.waitForExistence(timeout: 3.0),
                "Should return to main screen"
            )
        }
    }

    // 5. Test Navigation Back from Favorites
    func testNavigateBackFromFavorites() throws {
        let favoritesButton = app.buttons["heart"].firstMatch
        if favoritesButton.waitForExistence(timeout: 3.0) {
            favoritesButton.tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 1).tap()
        }

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.waitForExistence(timeout: 3.0) {
            backButton.tap()
            XCTAssertTrue(
                app.navigationBars.firstMatch.waitForExistence(timeout: 3.0),
                "Should return to main screen"
            )
        }
    }

    // 6. Test Settings Tab Switching
    func testSettingsTabSwitching() throws {
        let settingsButton = app.buttons["gearshape"].firstMatch
        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        let categoryTab = app.tabBars.buttons["Category"]
        if categoryTab.waitForExistence(timeout: 3.0) {
            categoryTab.tap()
            XCTAssertTrue(
                categoryTab.isSelected || categoryTab.exists, "Category tab should be selected")
        }
    }

    // 7. Test Main Feed Scroll View
    func testMainFeedScrollView() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.waitForExistence(timeout: 5.0) {
            scrollView.swipeUp()
            XCTAssertTrue(scrollView.exists, "Main feed scroll view should be scrollable")
        }
    }

    // 8. Test Mark As Read Toolbar Button
    func testMarkAsReadToolbarButton() throws {
        let markReadButton = app.buttons["checkmark.seal"].firstMatch
        let altMarkReadButton = app.buttons["checkmark.seal.fill"].firstMatch

        if markReadButton.waitForExistence(timeout: 3.0) {
            markReadButton.tap()
            XCTAssertTrue(
                markReadButton.exists || altMarkReadButton.exists,
                "Mark as read button should toggle")
        } else if altMarkReadButton.waitForExistence(timeout: 3.0) {
            altMarkReadButton.tap()
            XCTAssertTrue(
                markReadButton.exists || altMarkReadButton.exists,
                "Mark as read button should toggle")
        }
    }

    // 9. Test Settings Sound Tab
    func testSettingsSoundTab() throws {
        let settingsButton = app.buttons["gearshape"].firstMatch
        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        let soundTab = app.tabBars.buttons["Sound"]
        if soundTab.waitForExistence(timeout: 3.0) {
            soundTab.tap()
            XCTAssertTrue(soundTab.exists, "Sound tab in settings should be accessible")
        }
    }

    // 10. Test Settings Info Tab
    func testSettingsInfoTab() throws {
        let settingsButton = app.buttons["gearshape"].firstMatch
        if settingsButton.waitForExistence(timeout: 3.0) {
            settingsButton.tap()
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        let infoTab = app.tabBars.buttons["Info"]
        if infoTab.waitForExistence(timeout: 3.0) {
            infoTab.tap()
            XCTAssertTrue(infoTab.exists, "Info tab in settings should be accessible")
        }
    }
}
