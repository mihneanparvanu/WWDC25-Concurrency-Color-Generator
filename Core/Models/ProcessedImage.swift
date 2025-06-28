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
	private static var fileService: LocalFilesService = LocalFilesService()
	private static var colorExtractor: ColorExtractor = ColorExtractionService()
	
	static func create(from uiImage: UIImage?,
					   extractingColors colorCount: Int,
					   fileService: LocalFilesService? = nil,
					   colorExtractor: ColorExtractor? = nil
	) async throws -> ProcessedImage {
		let localFiles = fileService ?? Self.fileService
		let extractor = colorExtractor ?? Self.colorExtractor
		
		guard let uiImage = uiImage else { throw ColorExtractionError .noImageFound }
		
		//Try extracting colors
		let colors = try await extractor.extractColors(
			count: colorCount,
			from: uiImage
		)
		
		//Try saving image to files
		let imageURL = try localFiles.saveImage(uiImage)
		
		
		//Create proccessed image
		return ProcessedImage(
			imageURL: imageURL,
			colorHexCodes: colors.map{$0.toHex ?? ""})
	}
	
	func update(with uiImage: UIImage?,
				colorCount: Int = 5,
				fileService: LocalFilesService? = nil,
				colorExtractor: ColorExtractor? = nil
	) async throws {
		let localFiles = fileService ?? Self.fileService
		let extractor = colorExtractor ?? Self.colorExtractor
		
		guard let uiImage else { throw ColorExtractionError.noImageFound }
		
		//Try extracting colors
		let newColors = try await extractor.extractColors(
			count: colorCount,
			from: uiImage
		)
		
		//Try saving image to files
		let newImageURL = try localFiles.saveImage(uiImage)
		
		//Update processed image
		self.imageURL = newImageURL
		self.colorHexCodes = newColors.map ({$0.toHex ?? ""})
	}
}

