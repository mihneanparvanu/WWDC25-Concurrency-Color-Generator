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
	@State private var extractedColors: [Color]?
	let soundManager = SoundManager()
	
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
				ColorWheelView(colors: extractedColors)
				
				ExtractColorsButton(
					action: {
						Task {
							try await vm
								.saveCurrentImage(
									pickerVM.selection.uiImage,
									in: context)
							await updateExtractedColors()
						}
					},
					colorsCount: colorsCount,
					isLoading: vm.isExtractingColors
				)
			}
			.onChange(of: vm.currentProcessedImage) {
				soundManager.playSound(.applePay)
			}
			.onChange(of: pickerVM.selection.item) {
				resetExtractedColors()
			}
			.frame(width: 256, height: 256)
			
			Slider(
				value: $vm.colorCount,
				in: 1...5,
				step: 1,
				onEditingChanged: {_ in
					resetExtractedColors()
				}
			)
		}
		.padding()
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

//MARK: Extracted colors
extension ContentView {
	func updateExtractedColors () async {
		resetExtractedColors()
		extractedColors = vm.currentProcessedImage?.display.colors
	}
	
	func resetExtractedColors () {
		extractedColors = nil
	}
}


#Preview {
	ContentView()
}

#Preview {
	let soundManager = SoundManager()
	Button {
		soundManager.playSound(.applePay)
	} label: {
		Text("Play sound")
	}
}
