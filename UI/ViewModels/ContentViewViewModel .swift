//
//  ContentViewViewModel .swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 26.06.2025.
//

import Observation
import SwiftData
import SwiftUI


@MainActor
@Observable
final class ContentViewViewModel {
	let imageProcessor: ImageProcessor
	let colorExtractor: ColorExtractor
	
	init(proccessor: ImageProcessor, colorExtractor: ColorExtractor){
		self.imageProcessor = proccessor
		self.colorExtractor = colorExtractor
	}
	
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [Color]?

	var isColorExtractionInProgress: Bool = false

}


//MARK: Color extraction logic
extension ContentViewViewModel {
	func extractColors (from selectedUIImage: UIImage?) async throws {
		guard let uiImage = selectedUIImage else { return }
		
		extractedColors = try await colorExtractor.extractColors(count: intColorCount, from: uiImage)
	}
}


//MARK: Save photo to context

//MARK: Transform data into display images
extension ContentViewViewModel {
	func prepareImagesForDisplay (_ processedImages: [ProcessedImage]) -> [ProcessedImageDisplay] {
		guard processedImages.isNotEmpty else { return [] }
		
		return processedImages.compactMap { processedImage in
			ProcessedImageDisplay(processedImage: processedImage)
		}
	}
}

