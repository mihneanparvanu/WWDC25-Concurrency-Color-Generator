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
	
	init(proccessor: ImageProcessor){
		self.imageProcessor = proccessor
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
	func extractColors (from selectedImage: UIImage?) async throws {
		guard let uiImage = selectedImage else { throw ColorExtractionError.noImageFound }
		extractedColors = []
		
		isColorExtractionInProgress = true
		defer {
			isColorExtractionInProgress = false
		}
		
		//Clear previous colors
		extractedColors = []
		
		do {
			let extractedUIColors = try await uiImage.extractColors(intColorCount)
			extractedColors = extractedUIColors.map{ Color($0) }
		}
		
		catch let error as ColorExtractionError {
			throw error
		}
		catch {
			throw ColorExtractionError.unknown
		}
	}
}


//MARK: Save photo to context
extension ContentViewViewModel {
	func saveImageInContext (_ selectedUIImage: UIImage?, in context: ModelContext) throws {
		guard let selectedUIImage else { return }
		guard let extractedColors else { return }
		let imageURL = try imageProcessor.saveImageToFiles(image: selectedUIImage)
		var imageColorHexCodes: [String] = []
		extractedColors.forEach({color in
			if let hexString = color.toHex {
				imageColorHexCodes.append(hexString)
			}
		})
		
		let processedImage = ProcessedImage(imageURL: imageURL, colorHexCodes: imageColorHexCodes)
		context.insert(processedImage)
		try context.save()
	}
}

//MARK: Transform data into display images
extension ContentViewViewModel {
	func prepareImagesForDisplay (_ processedImages: [ProcessedImage]) -> [ProcessedImageDisplay] {
		guard processedImages.isNotEmpty else { return [] }
		
		return processedImages.compactMap { processedImage in
			ProcessedImageDisplay(processedImage: processedImage)
		}
	}
}

