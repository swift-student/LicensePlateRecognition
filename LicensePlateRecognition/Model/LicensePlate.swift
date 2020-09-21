//
//  LicensePlate.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

struct LicensePlate {
    var lastRectInBuffer: CGRect
    let firstSeen: Date
    var lastSeen: Date
    var number: String?
    let uuid = UUID()
}

extension LicensePlate: Equatable {
    static func == (lhs: LicensePlate, rhs: LicensePlate) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension LicensePlate: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
