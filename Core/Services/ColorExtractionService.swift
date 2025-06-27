//
//  ColorExtractionService.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 27.06.2025.
//

import Foundation
import SwiftUI

struct ColorExtractionService: ColorExtractor {
	func extractColors (count: Int, from selectedImage: UIImage?) async throws -> [Color] {
		var extractedColors: [Color] = []
		guard let uiImage = selectedImage else { throw ColorExtractionError.noImageFound }
				
		do {
			let extractedUIColors = try await uiImage.extractColors(count)
			extractedColors = extractedUIColors.map{ Color($0) }
		}
		
		catch let error as ColorExtractionError {
			throw error
		}
		catch {
			throw ColorExtractionError.unknown
		}
		return extractedColors
	}
}

enum ColorExtractionError: Error {
	case noImageFound, coreImageCreationFailed, kmeansFilterFailed, paletteGenerationFailed, cgImageConversionFailed, contextRenderingFailed, unknown
	
	var localizedDescription: String  {
		switch self {
			case .noImageFound:
				return "No image found."
				case .coreImageCreationFailed:
				return "Failed to create CoreImage context."
			case .kmeansFilterFailed:
				return "Failed to apply K-Means clustering filter."
			case .paletteGenerationFailed:
				return "Failed to generate color palette."
			case .cgImageConversionFailed:
				return "Failed to convert CGImage."
			case .contextRenderingFailed:
				return "Failed to render context."
			case .unknown:
				return "Unknown error."
		}
	}
}
