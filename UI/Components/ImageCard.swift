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
	@State private var shouldAnimate: Bool = false
	
	init(displayImage: ProcessedImageDisplay, width: CGFloat = 200) {
		self.displayImage = displayImage
		self.width = width
	}
	
	var body: some View {
		VStack {
			displayImage.image
				.resizable()
				.scaledToFit()
				.frame(height: 100)
			
			HStack {
				ForEach(displayImage.colors.indices, id: \.self) { index in
					let doubleIndex = Double(index)
					displayImage.colors[index]
						.frame(maxWidth: .infinity, maxHeight: 36)
						.clipShape(RoundedRectangle(cornerRadius: 2))
						.opacity(shouldAnimate ? 1 : 0)
						.scaleEffect(
							x: shouldAnimate ? 1 : 1,
							y: shouldAnimate ? 1 : 0,
							anchor: .bottom
						)
						.rotationEffect(shouldAnimate ? .degrees(0) : .degrees(5))
						.animation(animation.delay(doubleIndex * 0.08),
							value: shouldAnimate
						)
						.onAppear {
							shouldAnimate = true
						}
				}
			}
		}
		.frame(width: width)
	}
}

//Animation
extension ImageCard {
	var animation: Animation {
		UI.Constants.Animations.appearAnimation
	}
}


#Preview {
	ImageCard(displayImage: .preview())
}

