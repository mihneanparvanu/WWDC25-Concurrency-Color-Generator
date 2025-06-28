//
//  SwiftDataService.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI
import SwiftData

struct LocalFilesService: FileService {
	func saveImage(_ uiImage: UIImage) throws -> URL {
		guard let data = uiImage.jpegData(compressionQuality: 1) else {
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
		let filename = UUID().uuidString
		let fileURL = directory.appendingPathComponent(filename)
		try data.write(to: fileURL)
		if fileManager.fileExists(atPath: fileURL.path) {
		} else {
		}
		return fileURL
	}
}
