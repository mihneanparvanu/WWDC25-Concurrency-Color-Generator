//
//  PhotoProcessingService.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI
import PhotosUI

struct ImageProcessingSevice {
	func extractData (from photo: PhotosPickerItem) async throws -> Data? {
		return try? await photo.loadTransferable(type: Data.self)
	}
	
	func getImage(from data: Data?) -> Image? {
		guard let data else { return nil }
		guard let uiImage = UIImage(data: data) else { return nil }
		return Image (uiImage: uiImage)
	}
}
