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
	
	init (vm: ContentViewViewModel,
		  pickerVM: ImagePickerViewModel
	) {
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
				if let extractedColors = extractedColors {
					ColorWheelView(colors: extractedColors)
				}
				
				ExtractColorsButton(
					action: {
						Task {
							isColorExtractionInProgress = true
							let processedImage = try await
							ProcessedImage
								.create(
									from: pickerVM.selectedUIImage,
									extractingColors: colorsCount
								)
							isColorExtractionInProgress = false
							extractedColors = ProcessedImageDisplay(
								processedImage: processedImage
							).colors
							context.insert(processedImage)
							try context.save()
						}
					},
					colorsCount: colorsCount,
					isLoading: isColorExtractionInProgress
				)
			}
			.frame(width: 256, height: 256)
			
			Slider(
				value: $vm.colorCount,
				in: 1...5,
				step: 1,
				onEditingChanged: {editing in
				}
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

