//
//  ProcessedImageDisplay.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 14.06.2025.
//

import SwiftUI

struct ProcessedImageDisplay: Identifiable {
	var id: UUID = UUID()
	let processedImage: ProcessedImage
	var colors: [Color] {
		processedImage.colorHexCodes.compactMap(Self.colorFromHex)
	}
	var image: Image {
		if let uiImage = try? Self.loadImageFromFiles(at: processedImage.imageURL) {
			Image(uiImage: uiImage)
		} else {
			Self.placeholderImage
		}
	}
	
	
	static let placeholderImage: Image = Image(systemName: "photo.badge.exclamationmark.fill")
	
	//MARK: Load image from files
	static func loadImageFromFiles(at url: URL) throws -> UIImage? {
		let data = try Data(contentsOf: url)
		return UIImage(data: data)
	}
	
	//MARK: Convert colors from hex to [Color]
	static func colorFromHex(_ hex: String) -> Color? {
		var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		if hexString.hasPrefix("#") { hexString.removeFirst() }
		var rgb: UInt64 = 0
		guard Scanner(string: hexString).scanHexInt64(&rgb) else { return nil }
		switch hexString.count {
			case 6: // RRGGBB
				let r = Double((rgb & 0xFF0000) >> 16) / 255.0
				let g = Double((rgb & 0x00FF00) >> 8) / 255.0
				let b = Double(rgb & 0x0000FF) / 255.0
				return Color(red: r, green: g, blue: b)
			case 8: // AARRGGBB
				let a = Double((rgb & 0xFF000000) >> 24) / 255.0
				let r = Double((rgb & 0x00FF0000) >> 16) / 255.0
				let g = Double((rgb & 0x0000FF00) >> 8) / 255.0
				let b = Double(rgb & 0x000000FF) / 255.0
				return Color(red: r, green: g, blue: b, opacity: a)
			default:
				return nil
		}
	}
}
