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
            
            XCTAssertNotNil(weather.coreInformation.first?.type, "Unable to parse a core weather type")
            
            XCTAssertEqual(weather.coreInformation.first?.type, WeatherType.Rain)
            XCTAssertEqual(weather.coreInformation.first?.description, "moderate rain")
            XCTAssertEqual(weather.mainDetails.currentTemperature, 298.48)
            XCTAssertEqual(weather.mainDetails.minimumTemperature, 297.56)
            XCTAssertEqual(weather.mainDetails.maximumTemperature, 300.05)
            XCTAssertEqual(weather.mainDetails.humidity, 64)
            XCTAssertEqual(weather.rainDetails.chanceOfRain, 3.16)
        } catch {
            XCTFail("Test failed with bubbled up error of: " + String(describing: error))
        }
    }
}
