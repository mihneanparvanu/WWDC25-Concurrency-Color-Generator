//
//  ContentViewViewModel .swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 26.06.2025.
//

import Observation
import SwiftData
import SwiftUI


@MainActor
@Observable
final class ContentViewViewModel {
	
	//Current processed image
	var currentProcessedImage: ProcessedImage?
	
	//Color extraction
	var colorCount: Double = 5
	var intColorCount: Int {
		Int(colorCount)
	}
	var isExtractingColors: Bool = false
}


//MARK: Color extraction logic
extension ContentViewViewModel {
	func saveCurrentImage(_ uiImage: UIImage?,
						  in context: ModelContext
	) async throws {
		isExtractingColors = true
		defer {
			isExtractingColors = false
		}
		
		currentProcessedImage = try await ProcessedImage.create(
			from: uiImage,
			extractingColors: intColorCount
		)
		
		if let currentProcessedImage {
			context.insert(currentProcessedImage)
		}

		try context.save()
	}
}

