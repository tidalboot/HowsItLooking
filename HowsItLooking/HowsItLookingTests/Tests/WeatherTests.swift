//
//  WeatherTests.swift
//  HowsItLookingTests
//
//  Created by Nick Jones on 28/09/2023.
//

import XCTest
@testable import HowsItLooking

final class WeatherTests: XCTestCase {

    func testThatWeCanParseAWeatherObjectFromValidWeatherJSON() throws {
        do {
            let weatherData = try getData(fromJSON: "weatherResults")
            let weather = try JSONDecoder().decode(Weather.self, from: weatherData)
            
            XCTAssertEqual(weather.type, .rain)
            XCTAssertEqual(weather.description, "moderate rain")
            XCTAssertEqual(weather.currentTemperature, 298.48)
            XCTAssertEqual(weather.minumumTemperature, 297.56)
            XCTAssertEqual(weather.maximumTemperature, 300.05)
            XCTAssertEqual(weather.humidity, 64)
            XCTAssertEqual(weather.chanceOfRain, 3.16)
        } catch {
            XCTFail("Test failed with bubbled up error of: " + String(describing: error))
        }
    }
}
