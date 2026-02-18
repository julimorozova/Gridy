//
//  BoardCard.swift
//  Gridy
//
//  Created by Julia Morozova on 16. 2. 2026..
//

import UIKit

enum CardStatus: String, CaseIterable {
    case todo = "ToDo"
    case inProgress = "In Progress"
    case done = "Done"
}

struct BoardCard {
    let id = UUID()
    var title: String
    var description: String
    var status: CardStatus
}
