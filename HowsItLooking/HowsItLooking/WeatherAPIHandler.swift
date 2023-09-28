//
//  WeatherAPIHandler.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation

class WeatherAPIHandler {
    
    enum WeatherLoadingError: Error {
        case unableToLoadWeather
    }
    
    static let shared = WeatherAPIHandler()
    private let apiKey = "0ad8d1d87e47aba90d6451a25084eb0a"
    private let baseEndpoint = "https://api.openweathermap.org"
    
    private init() {}
    
    private func weatherQueryParams(withLongitude longitude: CGFloat, andLatitude latitude: CGFloat) -> String {
        let rawParams = ["lat": latitude,
                           "lon": longitude,
                           "appid": apiKey] as KeyValuePairs<String, Any>
        return rawParams.queryParams()
    }
    
    func requestCurrentWeather(forLongitude longitude: CGFloat, andLatitude latitude: CGFloat) async throws -> Weather  {
        let params = weatherQueryParams(withLongitude: longitude, andLatitude: latitude)
        guard let weatherURL = URL(string: baseEndpoint + "/data/2.5/weather" + params) else {
            throw WeatherLoadingError.unableToLoadWeather
        }
        
        let (data, _) = try await URLSession(configuration: .ephemeral).data(from: weatherURL)
        let weatherResult = try JSONDecoder().decode(Weather.self, from: data)
        return weatherResult
    }
}
