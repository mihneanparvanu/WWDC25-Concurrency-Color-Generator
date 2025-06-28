//
//  Image.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import SwiftData
import SwiftUI

@Model
class ProcessedImage {
	var imageURL: URL
	var colorHexCodes: [String]
	
	init (imageURL: URL, colorHexCodes: [String]){
		self.imageURL = imageURL
		self.colorHexCodes = colorHexCodes
	}
}

extension ProcessedImage {
	static var imageProcessor: ImageProcessor = ImageProcessingSevice()
	static var colorExtractor: ColorExtractor = ColorExtractionService()
	
	static func create(image uiImage: UIImage?, colorCount: Int, using imageProcessor: ImageProcessor? = nil, using colorExtractor: ColorExtractor? = nil) async throws -> ProcessedImage {
		let extractor = colorExtractor ?? Self.colorExtractor
		let processor = imageProcessor ?? Self.imageProcessor
		
		guard let uiImage = uiImage else {
			throw ColorExtractionError
			.noImageFound}
		
		
		//Extract colors
		let colors = try await extractor.extractColors(
			count: colorCount,
			from: uiImage
		)
		
		//Save image to disk
		let imageURL = try processor.saveImageToFiles(image: uiImage)
		
		
		//Create proccessed image
		return ProcessedImage(
			imageURL: imageURL,
			colorHexCodes: colors.map{$0.toHex ?? ""})
	}
	
}

