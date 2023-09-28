//
//  LocalWeatherViewModel.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation

@MainActor
class LocalWeatherViewModel: ObservableObject {
    
    @Published var loadedWeather: Bool = false
    @Published var weather: Weather?
    
    func loadWeather() async throws {
        let weather = try await WeatherAPIHandler.shared.requestCurrentWeather(forLongitude: -122.406417, andLatitude: 37.785834)
        self.weather = weather
        self.loadedWeather = true
    }
    
    func locationName() -> String {
        weather?.name ?? "Local weather"
    }
    
    func readableDescription() -> String {
        weather?.coreInformation.first?.description.capitalized ?? "The weather is uncertain"
    }
    
    func emojiRepresentationOfWeather() -> String {
        guard let mainWeather = weather?.coreInformation.first else { return "🤷" }
        switch mainWeather.type {
        case .Thunderstorm:
            return "🌩️"
        case .Drizzle:
            return "🌧️"
        case .Rain:
            return "☔️"
        case .Snow:
            return "❄️"
        case .Clear:
            return "☀️"
        case .Clouds:
            return "☁️"
        case .Unknown:
            return "🤷"
        }
    }
}
