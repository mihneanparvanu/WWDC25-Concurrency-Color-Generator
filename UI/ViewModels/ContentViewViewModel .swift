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
	
	//Color extraction
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [Color]?
	var isColorExtractionInProgress: Bool = false

}


//MARK: Color extraction logic
extension ContentViewViewModel {
	func saveCurrentImage(_ uiImage: UIImage?,
						  in context: ModelContext
	) async throws {
		isColorExtractionInProgress = true
		let processedImage = try await ProcessedImage.create(
			from: uiImage,
			extractingColors: intColorCount
		)
		isColorExtractionInProgress = false
		context.insert(processedImage)
		try context.save()
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

