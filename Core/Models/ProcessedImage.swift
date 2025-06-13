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
	var photoIdentifier: String
	var colorPalette: [String] = []
	
	init (photoIdentifier: String){
		self.photoIdentifier = photoIdentifier
	}	
}
