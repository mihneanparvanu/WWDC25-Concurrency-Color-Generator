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
	let images: [ProcessedImage]

	
	var body: some View {
		NavigationStack {
			VStack (spacing: 32) {
				ForEach (images, id: \.self) { image in
					for color in image.colorHexCodes {
						colors.append(vm.colorFromHex(color))
					}
					
					if let image = vm.retrievePhotoFromURL(image.imageURL) {
						image
							.resizable()
							.scaledToFit()
							.frame(width: 400, height: 300)
					}
					
					HStack {
						ForEach(image.colorHexCodes, id: \.self) {hex in
							if let color = vm.colorFromHex(hex){
								
								Color(color)
									.frame(width: .infinity, height: 36)
							}
						}
					}
					
				}
			}
				.padding(.horizontal)
		}
	}
}





#Preview {
	ProcessedImagesView(images: [])
}

