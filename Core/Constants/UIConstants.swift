//
//  UIConstants.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 16.06.2025.
//

import SwiftUI

struct UIConstants {
	//MARK: Animations
	let animations: Animations
	struct Animations {
		let appearAnimation: Animation = .bouncy(duration: 0.3)
	}

	
	//MARK: Spacing
	let spacing: Spacing
	struct Spacing {
		let minCornerRadius: CGFloat = 2
	}

}

private struct UIConstantsKey: EnvironmentKey {
	static let defaultValue = UIConstants(
		animations: UIConstants.Animations(),
		spacing: UIConstants.Spacing()
	)
}

extension EnvironmentValues {
	var uiConstants: UIConstants {
		get {self[UIConstantsKey.self]}
		set {self[UIConstantsKey.self] = newValue}
	}
}
