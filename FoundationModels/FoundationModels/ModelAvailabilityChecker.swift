//
//  ModelAvailabilityChecker.swift
//  FoundationModels
//
//  Created by Mayank Negi on 20/10/26.
//

import FoundationModels
import Observation

/// Reads whether Apple's on-device language model can be used right now.
///
/// `SystemLanguageModel.default.availability` is a snapshot, not a stream: it can change while
/// the app is running (the model finishes downloading, the user turns Apple Intelligence on in
/// Settings), so callers should `refresh()` whenever the app returns to the foreground.
@Observable
final class ModelAvailabilityChecker {

    enum Status: Equatable {
        case checking
        case available
        /// The hardware can't run Apple Intelligence at all. Nothing the user can do.
        case deviceNotEligible
        /// Capable device, but Apple Intelligence is switched off in Settings.
        case appleIntelligenceNotEnabled
        /// Enabled, but the model is still downloading or otherwise preparing.
        case modelNotReady
        /// A reason added in a newer OS than this code knows about.
        case unknown
    }

    private(set) var status: Status = .checking
    private(set) var supportsCurrentLocale = false

    private let model: SystemLanguageModel

    init(model: SystemLanguageModel = .default) {
        self.model = model
    }

    func refresh() {
        status = Self.status(for: model.availability)
        supportsCurrentLocale = model.supportsLocale()
    }

    static func status(for availability: SystemLanguageModel.Availability) -> Status {
        switch availability {
        case .available:
            return .available
        case .unavailable(.deviceNotEligible):
            return .deviceNotEligible
        case .unavailable(.appleIntelligenceNotEnabled):
            return .appleIntelligenceNotEnabled
        case .unavailable(.modelNotReady):
            return .modelNotReady
        case .unavailable:
            return .unknown
        }
    }
}
