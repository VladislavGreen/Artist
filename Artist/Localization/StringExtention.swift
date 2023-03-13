//
//  StringExtention.swift
//  Artist
//
//  Created by Vladislav Green on 3/10/23.
//

import Foundation


extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
