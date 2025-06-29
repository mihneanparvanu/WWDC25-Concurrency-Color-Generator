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
	@State private var vm: ContentViewViewModel
	@State private var pickerVM: ImagePickerViewModel
	
	@Query var images: [ProcessedImage]
	@Environment(\.modelContext) var context
	
	init () {
		let imageProcessor = ImageProcessingSevice()
		self.vm = ContentViewViewModel()
		self.pickerVM = ImagePickerViewModel(imageProcessor: imageProcessor)
	}
	
	var body: some View {
		NavigationStack {
			ScrollView {
				ImagePickerView(vm: $pickerVM, mode: .select)
				
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
				if let extractedColors = vm.extractedColors {
					ColorWheelView(colors: extractedColors)
				}
				
				ExtractColorsButton(
					action: {
						Task {
							try await vm
								.saveCurrentImage(
									pickerVM.selectedUIImage,
									in: context
								)
						}
					},
					colorsCount: colorsCount,
					isLoading: vm.isExtractingColors
				)
			}
			.frame(width: 256, height: 256)
			
			Slider(
				value: $vm.colorCount,
				in: 1...5,
				step: 1,
				onEditingChanged: {_ in}
			)
		}
		.padding()
	}
	
	var selectedImage: UIImage? {
		pickerVM.selectedUIImage
	}
	
	var colorsCount: Int {
		vm.intColorCount
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
						displayImage: image.display
					)
				}
				
			}
		}
	}
}


#Preview {
	ContentView()
}

