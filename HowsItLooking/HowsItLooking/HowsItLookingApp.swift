//
//  HowsItLookingApp.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import SwiftUI

@main
struct HowsItLookingApp: App {
    var body: some Scene {
        WindowGroup {
            LocalWeatherView(viewModel: LocalWeatherViewModel())
        }
    }
}
