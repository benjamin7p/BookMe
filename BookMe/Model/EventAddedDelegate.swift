//
//  eventAddedDelegate.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/25/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI

protocol EkEventViewDelegate: EKEventViewDelegate {
    func eventDidAdd()
}
