import Foundation

struct Question: Identifiable {
    enum Kind {
        case yesNo
        case scale0to3
        case scale0to5
    }

    let id: String
    let text: String
    let kind: Kind
}

enum QuestionBank {
    /// Ordered list of questions shown to the user
    static let all: [Question] = [
        .init(
            id: "sugar_past_hour",
            text: "Did you eat sugar in the past hour?",
            kind: .scale0to3
        ),
        .init(
            id: "caffeine_past_hour",
            text: "Did you have caffeine in the past hour?",
            kind: .scale0to3
        ),
        .init(
            id: "exercise_past_hour",
            text: "Did you exercise in the past hour?",
            kind: .scale0to3
        ),
        .init(
            id: "stress_past_hour",
            text: "How stressful was the past hour?",
            kind: .scale0to3
        ),
        .init(
            id: "positive_social_past_hour",
            text: "Did you have a positive social interaction in the past hour?",
            kind: .yesNo
        ),
        .init(
            id: "negative_social_past_hour",
            text: "Did you have a negative social interaction in the past hour?",
            kind: .yesNo
        ),
        .init(
            id: "sleep_deprivation",
            text: "How sleep deprived do you feel right now?",
            kind: .scale0to5
        )
    ]
}
