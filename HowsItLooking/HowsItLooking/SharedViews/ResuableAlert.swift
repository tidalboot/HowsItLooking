//
//  ResuableAlert.swift
//  HowsItLooking
//
//  Created by Nick Jones on 28/09/2023.
//

import SwiftUI

class AlertBuilder {
    static func buildAlert(withTitleText titleText: String,
                           actionText: String,
                           primaryAction: @escaping () -> Void) -> Alert {
        Alert(
            title: Text(titleText),
            dismissButton: .default(Text(actionText), action: {
                primaryAction()
            }))
    }
}
