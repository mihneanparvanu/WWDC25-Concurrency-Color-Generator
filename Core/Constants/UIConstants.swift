//
//  UIConstants.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 16.06.2025.
//

import SwiftUI

///UI Constants 
enum UI {

	//MARK: Animations
	enum Animations {
		static let appearAnimation: Animation = .bouncy(duration: 0.3)
	}

	
	//MARK: Spacing
	enum Spacing {
		static let minCornerRadius: CGFloat = 2
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
