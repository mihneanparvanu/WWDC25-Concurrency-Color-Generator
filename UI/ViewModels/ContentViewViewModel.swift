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
import CoreImage

@MainActor
@Observable
final class ContentViewViewModel {
	var selectedPhoto: PhotosPickerItem?
	var selectedUIImage: UIImage?
	
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var extractedColors: [UIColor] = []
}




//MARK: Extract data from photo
extension ContentViewViewModel {
	func extractData(from photo: PhotosPickerItem) async throws -> Data? {
		guard let data = try await photo.loadTransferable(type: Data.self) else { return nil }
		return data
	}
}

//MARK: Save photo to context


//MARK: Photo selection logic
extension ContentViewViewModel {
	func getSelectedPhoto () async throws -> Image? {
		if let photo = selectedPhoto {
			if let data = try await extractData(from: photo) {
				if let uiImage = UIImage(data: data) {
					return Image(uiImage: uiImage)
				}
			}
		}
		return nil
	}
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

