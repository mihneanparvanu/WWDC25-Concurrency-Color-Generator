//
//  ProcessedImagesView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftData
import SwiftUI


struct ImageCard: View {
	let displayImage: ProcessedImageDisplay
	let width: CGFloat
	
	init(displayImage: ProcessedImageDisplay, width: CGFloat = 200) {
		self.displayImage = displayImage
		self.width = width
	}
	
	var body: some View {
		VStack {
			displayImage.image
				.resizable()
				.scaledToFit()
				.frame(height: 200)
			HStack {
				ForEach(displayImage.colors, id: \.self) { color in
					color
						.frame(width: .infinity, height: 30)
				}
			}
		}
		.frame(width: width)
	}

}


#Preview {
	ImageCard(displayImage: ProcessedImageDisplay.preview)
}

