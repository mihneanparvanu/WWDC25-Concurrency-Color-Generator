//
//  ProcessedImagesViewModel.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import Observation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class ProcessedImagesViewModel {
	let imageProcessor: ImageProcessor
	
	init(imageProcessor: ImageProcessor) {
		self.imageProcessor = imageProcessor
	}

	
	//MARK: Retrieve photo from URL
	func retrievePhotoFromURL (_ url: URL) -> Image? {
		if let uiImage = try? imageProcessor.loadImageFromFiles(at: url) {
			return Image(uiImage: uiImage)
		} else {
			return nil
		}
	}
	
	//MARK: Convert colors from hex to [Color]
	func colorFromHex(_ hex: String) -> Color? {
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
