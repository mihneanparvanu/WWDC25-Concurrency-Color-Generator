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



//MARK: Photo selection logic
extension ContentViewViewModel {
	func getSelectedPhoto () async throws -> Image? {
		if let selectedPhoto {
			let data = try await selectedPhoto.loadTransferable(type: Data.self)
			if let data {
				selectedUIImage = UIImage(data: data)
				if let uiImage = selectedUIImage {
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
