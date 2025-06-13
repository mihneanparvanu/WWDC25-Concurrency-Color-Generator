//
//  UIColorToHex.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import UIKit

extension UIColor {
	var toHex: String? {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
			let r = Int(red * 255)
			let g = Int(green * 255)
			let b = Int(blue * 255)
			return String(format: "#%02X%02X%02X", r, g, b)
		}
		return nil
	}
}
