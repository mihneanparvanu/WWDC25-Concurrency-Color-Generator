//
//  ExtractedColorsView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import SwiftUI

struct ColorWheelView: View {
	let colors: [Color]
	let innerRadiusRatio: CGFloat
    var body: some View {
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
			}
		}
    }
}

//MARK: Degrees per segment
extension ColorWheelView {
	var degreesPerSegment: Double {
		let segmentCount: Double = Double(colors.count)
		return 360 / segmentCount
	}
}

//MARK: Custom Shape
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
