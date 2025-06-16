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
	@State private var isAnimating: Bool = false
	@Environment(\.uiConstants) private var ui
	
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
				ForEach(displayImage.colors.indices, id: \.self) { index in
					let doubleIndex = Double(index)
					displayImage.colors[index]
						.frame(maxWidth: .infinity, maxHeight: 36)
						.clipShape(RoundedRectangle(cornerRadius: 2))
						.opacity(isAnimating ? 1 : 0)
						.scaleEffect(
							x: isAnimating ? 1 : 1,
							y: isAnimating ? 1 : 0,
							anchor: .bottom
						)
						.rotationEffect(isAnimating ? .degrees(0) : .degrees(5))
						.animation(animation.delay(doubleIndex * 0.08),
							value: isAnimating
						)
						.onAppear {
							isAnimating = true
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
		ui.animations.appearAnimation
	}
}

#Preview {
	ImageCard(displayImage: ProcessedImageDisplay.preview)
}

