//
//  LocalWeatherViewModel.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation
import CoreLocation

typealias LatLon = (latidude: Double, longitude: Double)

enum LocalWeatherViewModelErrors: Error {
    case unableToLoadWeather
}

@MainActor
class LocalWeatherViewModel: NSObject, ObservableObject {
    
    let alertTitle = "We ran into a problem loading your local weather, would you like to try again?"
    let alertRetryText = "Retry"
    
    @Published var locationAccessNeeded: Bool = true
    @Published var loadedWeather: Bool = false
    @Published var accessDenied: Bool = false
    @Published var weather: Weather?
    private var currentLatLon: LatLon?
    
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAccessToLocation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func loadWeather() async throws {
        guard let currentLatLon = self.currentLatLon else { throw LocalWeatherViewModelErrors.unableToLoadWeather }
        let weather = try await WeatherAPIHandler.shared.requestCurrentWeather(forLongitude: currentLatLon.longitude, andLatitude: currentLatLon.latidude)
        self.weather = weather
        self.loadedWeather = true
    }
    
    func accessDeniedText() -> String {
        "We need access to your location to be able to get your current weather\nPlease enable access to location via Settings -> Privacy & Security -> Location Services -> HowsItLooking and by checking \"While Using the app\" to continue \n\nOnce done please close this app by swiping to dismiss it and reopen it again"
    }
    
    func locationName() -> String {
        weather?.name ?? "Local weather"
    }
    
    func readableDescription() -> String {
        weather?.coreInformation.first?.description.capitalized ?? "The weather is uncertain"
    }
        
    func currentTemp() -> String {
        guard let currentTemp = weather?.mainDetails.currentTemperature else { return "Currently --℃" }
        return "Currently \(currentTemp)℃"
    }
    func minTemp() -> String {
        guard let currentTemp = weather?.mainDetails.minimumTemperature else { return "Lows of --℃" }
        return "Lows of \(currentTemp)℃"
    }
    
    func maxTemp() -> String {
        guard let currentTemp = weather?.mainDetails.minimumTemperature else { return "Highs of --℃" }
        return "Highs of \(currentTemp)℃"
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

extension LocalWeatherViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        if status == .authorizedWhenInUse {
            guard let latitude = manager.location?.coordinate.latitude as? Double,
                  let longitude = manager.location?.coordinate.longitude as? Double else { return }
            currentLatLon = (latitude, longitude)
            locationAccessNeeded = false
        } else {
            accessDenied = true
        }
    }
}

