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
final class ImagePickerViewModel {
	let imageProcessor: ImageProcessor
	
	init(imageProcessor: ImageProcessor) {
		self.imageProcessor = imageProcessor
	}
	
	//Image selection
	var selection = SelectedImage() {
		didSet {
			Task {
				do {
					try await provideSelectedImage()
				}
				catch {
					selection.uiImage = nil
				}
			}
		}
	}
	
}

//MARK: Display selected image
extension ImagePickerViewModel {
	func provideSelectedImage () async throws {
		guard let item = selection.item else {
			throw ImageSelectionError.notFound
		}
		do {
			guard let data = try await imageProcessor.extractData(from: item) else {
				throw ImageSelectionError.timeout
			}
			
			if data.count > 50_000_000 {
				throw ImageSelectionError.tooLarge
			}
			
			guard let uiImage = UIImage(data: data) else {
				throw ImageSelectionError.unsupportedFormat
			}
			
			selection.uiImage = uiImage
			
		}
		catch let error as ImageSelectionError {
			throw error
		}
		
		catch {
			throw ImageSelectionError.unknown
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


extension ImagePickerViewModel {
	struct SelectedImage {
		var item: PhotosPickerItem?
		var uiImage: UIImage?
		var image: Image? {
			if let uiImage {
				return Image(uiImage: uiImage)
			}
			return nil
		}
		
		mutating func reset () {
			item = nil
			uiImage = nil
		}
	}
}
