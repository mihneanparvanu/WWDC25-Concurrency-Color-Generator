//
//  ContentView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 11.06.2025.
//

import PhotosUI
import SwiftData
import SwiftUI


struct ContentView: View {
	@Query var images: [ProcessedImage]
	@Environment(\.modelContext) var context
	@State private var pickerVM: ImagePickerViewModel
	
	init () {
		let imageProcessor = ImageProcessingSevice()
		self._pickerVM = .init(
			initialValue: ImagePickerViewModel(imageProcessor: imageProcessor)
		)
	}
	
	var body: some View {
		
		NavigationStack {
			ScrollView {
				ImagePickerView(vm: $pickerVM)
				
				extractColors()
				
				storedImages
			}
		}
	}
}


//MARK: Extract colors
extension ContentView {
	@ViewBuilder func extractColors () -> some View {
		VStack {
			ZStack {
				if pickerVM.extractedColors.isNotEmpty {
					ColorWheelView(colors: pickerVM.extractedColors)
				}
				
				ExtractColorsButton(
					action: {
						Task {
							
							try? await pickerVM
								.extractColors(pickerVM.intColorCount)
							try? pickerVM
								.savePhotoDataToContext(context)
							
						}
					},
					colorsCount: colorsCount,
					isLoading: pickerVM.isColorExtractionInProgress
				)
			}
			.frame(width: 256, height: 256)
			
			Slider(
				value: $pickerVM.colorCount,
				in: 1...5,
				step: 1,
				onEditingChanged: {editing in
				}
			)
		}
		.padding()
	}
	
	var colorsCount: Int {
		pickerVM.intColorCount
	}
}

//MARK: List of stored images
extension ContentView {
	@ViewBuilder var storedImages: some View {
		LazyVStack (spacing: 32) {
			ForEach (images) { image in
				NavigationLink (
					destination: ProcessedImageDetailView(
						image: image, pickerVM: $pickerVM
					)
				){
					ImageCard(
						displayImage: ProcessedImageDisplay(
							processedImage: image
						)
					)
				}
				
			}
		}
	}
}



#Preview {
	ContentView()
}

