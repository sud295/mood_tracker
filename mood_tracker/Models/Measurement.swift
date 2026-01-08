//
//  Measurement.swift
//  mood_tracker
//
//

import Foundation
import SwiftData

@Model
final class Measurement {
    var id: UUID
    var createdAt: Date
    var mood: Int
    var responsesJSON: String

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        mood: Int,
        responsesJSON: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.mood = mood
        self.responsesJSON = responsesJSON
    }
}
