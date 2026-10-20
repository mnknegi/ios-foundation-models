//
//  ModelAvailabilityView.swift
//  FoundationModels
//
//  Created by Mayank Negi on 20/10/26.
//

import SwiftUI

struct ModelAvailabilityView: View {

    @State private var checker = ModelAvailabilityChecker()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbol)
                .font(.system(size: 56))
                .foregroundStyle(tint)

            Text(title)
                .font(.title2.bold())

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if checker.status == .available && !checker.supportsCurrentLocale {
                Label("Your current language isn't supported by the model.", systemImage: "globe")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }

            Button("Check Again") {
                checker.refresh()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                checker.refresh()
            }
        }
    }

    private var symbol: String {
        switch checker.status {
        case .checking: "hourglass"
        case .available: "checkmark.seal.fill"
        case .deviceNotEligible: "iphone.slash"
        case .appleIntelligenceNotEnabled: "gearshape.fill"
        case .modelNotReady: "arrow.down.circle"
        case .unknown: "questionmark.circle"
        }
    }

    private var tint: Color {
        switch checker.status {
        case .available: .green
        case .appleIntelligenceNotEnabled, .modelNotReady: .orange
        case .deviceNotEligible: .red
        case .checking, .unknown: .gray
        }
    }

    private var title: String {
        switch checker.status {
        case .checking: "Checking…"
        case .available: "Model Available"
        case .deviceNotEligible: "Device Not Supported"
        case .appleIntelligenceNotEnabled: "Apple Intelligence Is Off"
        case .modelNotReady: "Model Not Ready"
        case .unknown: "Model Unavailable"
        }
    }

    private var message: String {
        switch checker.status {
        case .checking:
            "Looking for the on-device language model."
        case .available:
            "The on-device language model is ready to use."
        case .deviceNotEligible:
            "This device can't run Apple Intelligence."
        case .appleIntelligenceNotEnabled:
            "Turn on Apple Intelligence in Settings, then come back to the app."
        case .modelNotReady:
            "The model is still downloading or preparing. Try again in a little while."
        case .unknown:
            "The model is unavailable for a reason this app doesn't recognise yet."
        }
    }
}

#Preview {
    ModelAvailabilityView()
}
