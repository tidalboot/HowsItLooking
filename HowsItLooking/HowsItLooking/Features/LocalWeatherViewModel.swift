//
//  LocalWeatherViewModel.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import Foundation
import CoreLocation

typealias LatLon = (latidude: Double, longitude: Double)

// With more time I'd like to expose better errors rather than just this generic one
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
    
    /*
     Ideally the handling of the location authorisatoin and requests would sit outside of this view model
     
     This functionality sitting within the local weather view model, whilst relevant, isn't an ideal setup
     as it puts too much responsibility on the view model around things it probably shouldn't even need to know about
     
     Given the time constraints however I had to compromise in this situation in favor of getting something working
     */
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAccessToLocation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /*
     Offline support was something I left until last in favour of getting the rest of the app set up and unfortunately
     was something I ran out of time to implement.
     
     It should be reasonably easy to set up however given that our Weather model is already Decodable.
     
     With very little work we could make our Weather object Encodable (And at that point simply Codable) which would allow us
     to encode it to a Data object and simply store it in our UserDefaults or even better with SwiftData which would remove the need for us to encode it manually ourselves 👍
     
     When our loadWeather request fails we could then simply fall back to our cached weather
     
     There's a whole load of work around that in terms of making it "good" since ideally we would only want to store the data for
     so long since getting cached weather from yesterday for today would be basically useless to the user
     
     On top of that we'd also want to make sure we have some way of telling the user that the data they have isn't brand new and may be out of date
     
     Lots of really fun stuff that unfortunately needs more time to get working
     */
    func loadWeather() async throws {
        guard let currentLatLon = self.currentLatLon else { throw LocalWeatherViewModelErrors.unableToLoadWeather }
        let weather = try await WeatherAPIHandler.shared.requestCurrentWeather(forLongitude: currentLatLon.longitude, andLatitude: currentLatLon.latidude)
        self.weather = weather
        self.loadedWeather = true
    }
    
    //With more time I'd prefer to make all of these strings localized but given the time constraints I opted for getting everything up and runnign where possible
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

    //This whole setup isn't great, with more time I'd like to improve this
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

