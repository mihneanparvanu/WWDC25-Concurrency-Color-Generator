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
	@State private var vm: ContentViewViewModel
	@State private var photo: Image?
	
	init () {
		let imageProcessor = ImageProcessingSevice()
		self._vm = .init(
			initialValue: ContentViewViewModel(imageProcessor: imageProcessor)
		)
	}
	
	var body: some View {
		
		NavigationStack {
			ScrollView {
			toolbar
			
			selectedPhoto
			
			extractColors()
							
			storedImages
			}
		}
	}
}

//MARK: Top toolbar
extension ContentView {
	@ViewBuilder var toolbar: some View {
		HStack {
			Spacer ()
			PhotosPicker(selection: $vm.selectedImage, matching: .images) {
				Image(systemName: "camera")
					.padding()
			}
			.buttonStyle(.glass)
		}
		.padding()
		.frame(height: 64)
	}
}

//MARK: Selected photo
extension ContentView {
	var selectedPhoto: some View {
		Group {
			if let photo {
					photo
						.resizable()
						.scaledToFit()
						.padding(.horizontal)
			} else {
				ContentUnavailableView {
					Label("No image selected", systemImage: "photo.trianglebadge.exclamationmark")
				} description: {
					Text ("Tap the photo icon to select a photo.")
				}
			}
		}
		.frame(maxHeight: .infinity)
		.onChange(of: vm.selectedImage) {
			awaitDisplayingImage()
		}
	}
	
	func awaitDisplayingImage () {
		Task {
			try await photo = vm.provideSelectedImage()
		}
	}
}

//MARK: Extract colors
extension ContentView {
	@ViewBuilder func extractColors () -> some View {
		 VStack {
			ZStack {
					if vm.extractedColors.isNotEmpty {
						ColorWheelView(colors: vm.extractedColors)
					}

				ExtractColorsButton(
					action: {
						Task {
							try? await vm.extractColors(vm.intColorCount)
							try? vm.savePhotoDataToContext(context)
						}
					},
					colorsCount: colorsCount,
					disabled: photo == nil,
					isLoading: vm.isColorExtractionInProgress
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
						image: image
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

