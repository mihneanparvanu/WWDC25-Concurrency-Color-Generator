//
//  ContentViewViewModel.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import Foundation
import Observation
import SwiftUI
import PhotosUI

@MainActor
@Observable
final class ContentViewViewModel {
	var selectedPhoto: PhotosPickerItem?
}

extension ContentViewViewModel {
	func getSelectedPhoto () async throws -> Image? {
		if let selectedPhoto {
			let data = try await selectedPhoto.loadTransferable(type: Data.self)
			if let data {
				let uiImage = UIImage(data: data)
				if let uiImage {
					return Image(uiImage: uiImage)
				}
			}
		}
		return nil
	}
}
