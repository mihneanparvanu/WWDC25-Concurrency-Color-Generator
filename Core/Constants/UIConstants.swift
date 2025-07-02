//
//  UIConstants.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 16.06.2025.
//

import SwiftUI


///UI Constants
struct UI {
	private init() {}
	struct Theme {
		let primaryColor: Color
		let secondaryColor: Color
		let accentColor: Color
		
		static let light = Theme(primaryColor: .blue,
							   secondaryColor: .white,
							   accentColor: .orange)
		static let dark = Theme(primaryColor: .white,
							  secondaryColor: .black,
							  accentColor: .orange)
	}

	
	enum Constants {
		
		//MARK: Spacing
		enum Spacing {
			static let minCornerRadius: CGFloat = 2
		}
		
		//MARK: Animations
		enum Animations {
			static let appearAnimation: Animation = .bouncy(duration: 0.3)
		}
		
		//MARK: Haptics
		enum Haptics {
			private static let softImpact = UIImpactFeedbackGenerator(style: .soft)
			private static let lightImpact = UIImpactFeedbackGenerator(style: .light)
			
			static func playSoftHaptic() {
				Self.softImpact.impactOccurred()
			}
			
			static func playLightHaptic() {
				Self.lightImpact.impactOccurred()
			}
		}
	}
}
