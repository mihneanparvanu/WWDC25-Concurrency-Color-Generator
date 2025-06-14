//
//  ProcessedImagesView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftData
import SwiftUI


struct ProcessedImagesView: View {
	@State private var vm = ProcessedImagesViewModel()
	var displayImages: [ProcessedImageDisplay]
	
	var body: some View {
		Text ("Test")
			VStack (spacing: 32) {
				ForEach (displayImages) { display in
					display.image
						.resizable()
						.scaledToFit()
						.frame(width: 400, height: 300)
					
					HStack {
						ForEach(display.colors, id: \.self) { color in
							color
						}
					}
				}
			}
			.padding(.horizontal)
	}
}


#Preview {
	ProcessedImagesView(displayImages: [])
}

