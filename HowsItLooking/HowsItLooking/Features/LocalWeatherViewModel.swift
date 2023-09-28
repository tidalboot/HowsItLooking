//
//  LocalWeatherViewModel.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation

@MainActor
class LocalWeatherViewModel: ObservableObject {
    
    @Published var weather: Weather?
    
    func loadWeather() async throws {
        let weather = try await WeatherAPIHandler.shared.requestCurrentWeather(forLongitude: -122.406417, andLatitude: 37.785834)
        self.weather = weather
    }
}
