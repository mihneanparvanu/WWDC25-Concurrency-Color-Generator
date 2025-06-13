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
	let imageProcessor = ImageProcessingSevice()
	var selectedImage: PhotosPickerItem?
	var selectedUIImage: UIImage?
	
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [UIColor] = []
}

//MARK: Color extraction logic
extension ContentViewViewModel {
	func extractColors(_ colors: Int){
		
		//Clear previous extracted colors
		extractedColors = []
		
		if let uiImage = selectedUIImage {
			extractedColors =
			uiImage.extractColors(intColorCount)
		}
		
		if extractedColors != [] {
			print ("Extracted colors: \(extractedColors)")
		} else {
			print ("No colors extracted")
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

