//
//  LoadingView.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Spacer()
        ProgressView()
            .tint(.white)
            .frame(width: 100)
        Text("Loading...")
            .padding()
            .foregroundStyle(.white)
        Spacer()
            .background(Color.background)
                .ignoresSafeArea(edges: .bottom)
    }
}
