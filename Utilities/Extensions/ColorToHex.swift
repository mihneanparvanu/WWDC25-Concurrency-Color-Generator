//
//  ColorToHex.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI

extension Color {
	var toHex: String? {
		UIColor(self).toHex
	}
}


