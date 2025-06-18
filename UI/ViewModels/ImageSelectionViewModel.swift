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
final class ImageSelectionViewModel {
	let imageProcessor: ImageProcessor
	
	init(imageProcessor: ImageProcessor) {
		self.imageProcessor = imageProcessor
	}
	
	var selectedImage: PhotosPickerItem? {
		didSet {
			extractedColors = []
		}
	}
	var selectedUIImage: UIImage?
	
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [Color] = []
	
	var isColorExtractionInProgress: Bool = false
}

//MARK: Color extraction logic
extension ImageSelectionViewModel {
	func extractColors (_ colors: Int) async throws {
		guard let uiImage = selectedUIImage else {
			throw ColorExtractionError.noImageFound
		}
		
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

//MARK: Display selected image
extension ImageSelectionViewModel {
	func provideSelectedImage () async throws -> Image? {
		guard let selectedImage else {
			throw ImageSelectionError.notFound
		}
		do {
			guard let data = try await imageProcessor.extractData(from: selectedImage) else {
				throw ImageSelectionError.timeout
			}
			
			if data.count > 50_000_000 {
				throw ImageSelectionError.tooLarge
			}
			
			guard let uiImage = UIImage(data: data) else {
				throw ImageSelectionError.unsupportedFormat
			}
			
			selectedUIImage = uiImage
			return Image (uiImage: uiImage)
			
		}
		catch let error as ImageSelectionError {
			throw error
		}
		
		catch {
			throw ImageSelectionError.unknown
		}
	}
}

//MARK: Save photo to context
extension ImageSelectionViewModel {
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
extension ImageSelectionViewModel {
	func prepareImagesForDisplay (_ processedImages: [ProcessedImage]) -> [ProcessedImageDisplay] {
		guard processedImages.isNotEmpty else { return [] }
		print ("Processed images is not empty")
		
		return processedImages.compactMap { processedImage in
			ProcessedImageDisplay(processedImage: processedImage)
		}
	}
}

enum ImageSelectionError: Error {
	case unsupportedFormat, notFound, timeout, tooLarge, unknown
	
	var localizedDescription: String {
		switch self {
			case .unsupportedFormat:
				return "The selected image format is unsupported."
			case .notFound:
				return "The selected image was not found."
			case .timeout:
				return "The request timed out."
			case .tooLarge:
				return "The selected image is too large."
			case .unknown:
				return "Unknown error."
		}
	}
	
	var title: String {
		switch self {
			case .unsupportedFormat:
				return "Unsupported format"
			case .notFound:
				return "Not found"
			case .timeout:
				return "Timeout"
			case .tooLarge:
				return "Too large"
			case .unknown:
				return "Unknown"
		}
	}
	
	var userAction: String {
		switch self {
			case .unsupportedFormat:
				return "Please select an image with a JPEG, PNG, or GIF format."
			case .notFound:
				return "Please select another image."
			case .timeout:
				return "Please try again."
			case .tooLarge:
				return "Please select a smaller image."
			case .unknown:
				return "Please try again."
		}
	}
}


