//
//  ContentView.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import SwiftUI

struct LocalWeatherView: View {
    
    @StateObject var viewModel: LocalWeatherViewModel
    @State private var currentWeatherOpacity: CGFloat = 0
    
    var body: some View {
        VStack {
            viewForState()
        }
        .onAppear(perform: {
            Task {
                do {
                    try await viewModel.loadWeather()
                } catch {
                    let foo = error
                }
            }
        })
        .background(Color.background)
            .ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    private func weatherView() -> some View {
        Spacer()
            .frame(height: 80)
            LazyVStack {
                Text(viewModel.locationName())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                Text(viewModel.emojiRepresentationOfWeather())
                    .font(.system(size: 120))
                Text(viewModel.readableDescription())
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
            }
            .contentTransition(.opacity)
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity)
        Spacer()
    }
    
    @ViewBuilder
    private func viewForState() -> some View {
        if viewModel.loadedWeather {
            weatherView()
            .opacity(currentWeatherOpacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1).delay(1)) {
                    currentWeatherOpacity = 1
                }
            }
        } else {
            LoadingView()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    LocalWeatherView(viewModel: LocalWeatherViewModel())
}
