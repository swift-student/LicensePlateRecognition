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
    var lastSeen: Date
    var number: String?
    let uuid = UUID()
}

extension LicensePlate: Equatable {}
extension LicensePlate: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
