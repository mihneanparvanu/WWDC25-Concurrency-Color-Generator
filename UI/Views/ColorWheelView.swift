//
//  ExtractedColorsView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import SwiftUI

struct ColorWheelView: View {
	let colors: [Color]?
	let innerRadiusRatio: CGFloat
	@State private var shouldAnimate = false
	
	init (colors: [Color]?, innerRadiusRatio: CGFloat = 0) {
		self.colors = colors
		self.innerRadiusRatio = innerRadiusRatio
	}
	
	var body: some View {
		if hasColors {
			colorWheel(colors ?? [])
		} else {
			EmptyView()
		}
	}
}


//MARK: colorWheel
extension ColorWheelView {
	@ViewBuilder func colorWheel(_ colors: [Color]) -> some View {
		ZStack {
			ForEach(colors.indices, id: \.self) { index in
				let indexFloat = Double(index)
				let startAngle: Angle = .degrees(indexFloat * degreesPerSegment)
				let endAngle: Angle = .degrees ((indexFloat + 1) * degreesPerSegment)
				
				WheelSegment(
					startAngle: startAngle,
					endAngle: endAngle,
					innerRadiusRatio: innerRadiusRatio
				)
				.fill(colors[index])
				.opacity(shouldAnimate ? 1 : 0)
				.scaleEffect(shouldAnimate ? 1 : 0.2, anchor: .center)
				.animation(animation.delay(indexFloat * 0.2),
						   value: shouldAnimate)
				.onAppear {
					shouldAnimate = true
					
					Task {
						try? await Task.sleep(for: .seconds(indexFloat * 0.2))
						UI.Haptics.playSoftHaptic()
					}
				}
				.onDisappear {
					shouldAnimate = false
				}
			}
			
		}
	}
}


//MARK: Useful
extension ColorWheelView {
	
	var hasColors: Bool {
		colors?.isNotEmpty ?? false
	}
	
	var degreesPerSegment: Double {
		let segmentCount: Double = Double(colors?.count ?? 0)
		return 360 / segmentCount
	}
}


//MARK: Animation
extension ColorWheelView {
	var animation: Animation {
		UI.Animations.appearAnimation
	}
}

//MARK: Wedge Shape
struct WheelSegment: Shape {
	let startAngle: Angle
	let endAngle: Angle
	let innerRadiusRatio: CGFloat
	
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let innerRadius = radius * innerRadiusRatio
		
		var path = Path()
		path.addArc(
			center: center,
			radius: radius,
			startAngle: startAngle,
			endAngle: endAngle,
			clockwise: false
		)
		path.addArc(
			center: center,
			radius: innerRadius,
			startAngle: endAngle,
			endAngle: startAngle,
			clockwise: true
		)
		path.closeSubpath()
		return path
	}
}


#Preview {
	ColorWheelView(colors: [.red, .yellow, .blue], innerRadiusRatio: 0)
}


