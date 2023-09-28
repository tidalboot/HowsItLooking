//
//  Weather.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation

enum WeatherType: String, Decodable {
    case Thunderstorm
    case Drizzle
    case Rain
    case Snow
    case Clear
    case Clouds
}

struct CoreInformation: Decodable {
    let type: WeatherType?
    let description: String
    
    enum CodingKeys: CodingKey {
        case main
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try? values.decode(WeatherType.self, forKey: .main)
        description = try values.decode(String.self, forKey: .description)
    }
}

struct MainDetails: Decodable {
    let currentTemperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let humidity: Double
    
    enum CodingKeys: CodingKey {
        case temp
        case temp_min
        case temp_max
        case humidity
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentTemperature = try values.decode(Double.self, forKey: .temp)
        minimumTemperature = try values.decode(Double.self, forKey: .temp_min)
        maximumTemperature = try values.decode(Double.self, forKey: .temp_max)
        humidity = try values.decode(Double.self, forKey: .humidity)
    }
}

struct WindDetails: Decodable {
    let speed: Double
    let gust: Double
}

struct RainDetails: Decodable {
    let chanceOfRain: Double
    
    private enum CodingKeys: String, CodingKey {
        case chanceOfRain = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chanceOfRain = try values.decode(Double.self, forKey: .chanceOfRain)
    }
}

struct Weather: Decodable {
    
    let coreInformation: [CoreInformation]
    let mainDetails: MainDetails
    let windDetails: WindDetails
    let rainDetails: RainDetails
    
    enum CodingKeys: CodingKey {
        case weather
        case main
        case wind
        case rain
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coreInformation = try values.decode([CoreInformation].self, forKey: .weather)
        mainDetails = try values.decode(MainDetails.self, forKey: .main)
        windDetails = try values.decode(WindDetails.self, forKey: .wind)
        rainDetails = try values.decode(RainDetails.self, forKey: .rain)
    }
}