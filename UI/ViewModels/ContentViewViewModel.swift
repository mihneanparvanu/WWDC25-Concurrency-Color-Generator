//
//  ContentViewViewModel.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import Observation
import PhotosUI
import SwiftData
import SwiftUI


@MainActor
@Observable
final class ContentViewViewModel {
	let imageProcessor: ImageProcessor
	
	init(imageProcessor: ImageProcessor) {
		self.imageProcessor = imageProcessor
	}
	
	var selectedImage: PhotosPickerItem?
	var selectedUIImage: UIImage?
	
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [Color] = []
}

//MARK: Color extraction logic
extension ContentViewViewModel {
	func extractColors(_ colors: Int){
		
		//Clear previous colors
		extractedColors = []
		
		if let uiImage = selectedUIImage {
			let extractedUIColors = uiImage.extractColors(intColorCount)
			extractedColors = extractedUIColors.map{Color($0)}
		}
	}
}

//MARK: Display selected image
extension ContentViewViewModel {
	func provideSelectedImage () async throws -> Image? {
		guard let selectedImage else { return nil }
		guard let data = try await imageProcessor.extractData(from: selectedImage) else { return nil }
		guard let uiImage = UIImage(data: data) else { return nil }
		selectedUIImage = uiImage
		return Image (uiImage: uiImage)
	}
}

//MARK: Save photo to context
extension ContentViewViewModel {
	func savePhotoDataToContext (_ context: ModelContext) throws {
		guard let selectedUIImage else { return }
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
		print ("Processed images is not empty")
		
		return processedImages.compactMap { processedImage in
			ProcessedImageDisplay(processedImage: processedImage)
		}
	}
}



