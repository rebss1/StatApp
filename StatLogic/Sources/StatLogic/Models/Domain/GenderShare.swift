//
//  GenderShare.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit

public struct GenderShare {
    public let value: Double
    public let label: String
    public let color: UIColor
    
    public init(value: Double, label: String, color: UIColor) {
        self.value = value
        self.label = label
        self.color = color
    }
}
