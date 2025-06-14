//
//  PhotoProcessingService.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI
import PhotosUI


struct ImageProcessingSevice: ImageProcessor {
	func extractData (from photo: PhotosPickerItem) async throws -> Data? {
		return try? await photo.loadTransferable(type: Data.self)
	}
	
	func getImage(from data: Data?) -> UIImage? {
		guard let data else { return nil }
		guard let uiImage = UIImage(data: data) else { return nil }
		return uiImage
	}
	
	func saveImageToFiles (image: UIImage) throws -> URL {
		guard let data = image.jpegData(compressionQuality: 1) else {
			throw NSError(
				domain: "",
				code: 0,
				userInfo: [NSLocalizedDescriptionKey: "Couldn't convert image to data"]
			)
		}
		
		let fileManager = FileManager.default
		let directory = fileManager.urls(
			for: .documentDirectory,
			in: .userDomainMask
		)[0]
		print("Saving to directory: \(directory.path)")
		let filename = UUID().uuidString
		let fileURL = directory.appendingPathComponent(filename)
		try data.write(to: fileURL)
		if fileManager.fileExists(atPath: fileURL.path) {
			print("Image saved successfully at \(fileURL.path)")
		} else {
			print("Failed to save image.")
		}
		return fileURL
	}
}

