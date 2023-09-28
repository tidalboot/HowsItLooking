//
//  ContentView.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import SwiftUI

struct LocalWeatherView: View {
    
    @StateObject var viewModel: LocalWeatherViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            Task {
                do {
                    try await viewModel.loadWeather()
                } catch {
                    let foo = error
                }
            }
        })
    }
}

#Preview {
    LocalWeatherView(viewModel: LocalWeatherViewModel())
}
