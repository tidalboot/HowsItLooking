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
    @State private var showErrorAlert = false

    
    var body: some View {
        VStack {
            viewForState()
                .alert(isPresented: $showErrorAlert) {
                    AlertBuilder.buildAlert(
                        withTitleText: viewModel.alertTitle,
                        actionText: viewModel.alertRetryText) {
                            loadData()
                        }
                }
        }
        .onAppear(perform: {
            viewModel.requestAccessToLocation()
        })
        .background(Color.background)
            .ignoresSafeArea(edges: .bottom)
    }
    
    func loadData() {
        Task {
            do {
                try await viewModel.loadWeather()
            } catch {
                showErrorAlert = true
            }
        }
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
                Text(viewModel.currentTemp())
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                Text(viewModel.minTemp())
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                Text(viewModel.maxTemp())
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
            }
            .contentTransition(.opacity)
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity)
        Spacer()
    }
    
    @ViewBuilder func accessDenied() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                    .frame(width: 50)
                Text(viewModel.accessDeniedText())
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                Spacer()
                    .frame(width: 50)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func accessGranted() -> some View {
        if viewModel.locationAccessNeeded {
            LoadingView()
                .frame(maxWidth: .infinity)
        } else {
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
                    .onAppear(perform: {
                        loadData()
                    })
            }
        }
    }
    
    @ViewBuilder
    private func viewForState() -> some View {
        
        if viewModel.accessDenied {
            accessDenied()
        } else {
            accessGranted()
        }
    }
}

#Preview {
    LocalWeatherView(viewModel: LocalWeatherViewModel())
}
