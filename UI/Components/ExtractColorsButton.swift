//
//  ExtractColorsButton.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 16.06.2025.
//

import SwiftUI

struct ExtractColorsButton: View {
	let action: () -> Void
	let colorsCount: Int
	let disabled: Bool
	var isLoading: Bool
	
	var body: some View {
		Button (action: action){
			Text ("Extract \(colorsCount) \(colorsString)")
				.font(.system(size: 15))
				.padding()
				.frame(width: 128, height: 128)
		}
		.buttonStyle(.glass)
		.disabled(disabled)
		.phaseAnimator(BlurPhase.allCases,
					   trigger: isLoading,
					   content: {content, phase in
			content
				.blur(radius: blurRadius(for: phase))
			
		},
					   animation: {phase in
			blurAnimation(for: phase)
		})
	}
}

extension ExtractColorsButton {
	var colorsString: String {
		colorsCount == 1 ? "color" : "colors"
	}
}

enum BlurPhase: CaseIterable {
	case clear, light, heavy
}

extension ExtractColorsButton {
	func blurRadius (for phase: BlurPhase) -> CGFloat {
		switch phase {
			case .clear:
				return 0
			case .light:
				return 5
			case .heavy:
				return 10
		}
	}
	
	func blurAnimation (for phase: BlurPhase) -> Animation {
		let animation: Animation = .easeInOut(duration: 0.69)
		switch phase {
			case .clear:
				return animation
			case .light:
				return animation
			case .heavy:
				return animation
		}
	}
	
	
}


#Preview {
	ExtractColorsButton(
		action: {
		},
		colorsCount: 5,
		disabled: false,
		isLoading: false)
}

