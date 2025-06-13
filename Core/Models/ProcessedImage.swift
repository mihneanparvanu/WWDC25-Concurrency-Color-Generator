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
