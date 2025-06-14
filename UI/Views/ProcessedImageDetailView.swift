//
//  ProcessedImageDetailView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI

struct ProcessedImageDetailView: View {
	let image: Image?
	let colors: [Color]
	
	init(image: Image? = nil, colors: [Color] = []) {
		self.image = image
		self.colors = colors
	}
	
	var body: some View {
		VStack {
			image
			
			HStack {
				ForEach(colors, id: \.self) { color in
					Color(color)
						.frame(width: .infinity)
				}
			}
		}
	}
}


#Preview {
	ProcessedImageDetailView()
}
