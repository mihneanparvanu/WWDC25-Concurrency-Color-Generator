//
//  ImageSelection.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 18.06.2025.
//

import PhotosUI
import SwiftUI

struct ImagePickerView: View {
	@Environment(\.uiConstants) var ui
	@Binding var vm: ImagePickerViewModel
	@State var photo: Image?
	let mode: ImagePickerMode
	let currentImage: Image?
	
	///Select mode
	init(
		vm: Binding<ImagePickerViewModel>
	) {
		self.mode = .select
		self.currentImage = nil
		self._vm = vm
	}
	
	///Edit mode
	init(vm: Binding<ImagePickerViewModel>, currentImage: Image){
		self.mode = .edit
		self.currentImage = currentImage
		self._vm = vm
	}
	

	var body: some View {
		switch mode {
			case .select:
				selectView
			case .edit:
				editView
		}
	}
}

//MARK: selectView
extension ImagePickerView {
	var selectView: some View {
		VStack {
			toolbar
			
			selectedPhoto
		}
	}
}

//Top toolbar
extension ImagePickerView {
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

//Selected photo
extension ImagePickerView {
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
			loadSelectedImage()
		}
	}
	
	func loadSelectedImage () {
		Task {
			do {
				photo = try await  vm.provideSelectedImage()
			}
			catch {
				photo = nil
			}
	
		}
	}
}

//MARK: editView
extension ImagePickerView {
	var editView: some View {
		VStack {
			currentImage?
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.clipShape(.rect(cornerRadius: ui.spacing.minCornerRadius))
			
			
			
			PhotosPicker(selection: $vm.selectedImage, label: {
				Label("Change image", systemImage: "photo")
			})	}
	}
}


enum ImagePickerMode {
	case select, edit
}

#Preview {
	@Previewable @State var vm = ImagePickerViewModel(imageProcessor: ImageProcessingSevice())
	
	ImagePickerView(vm: $vm)
	
	ImagePickerView(vm: $vm, currentImage: ProcessedImageDisplay.preview.image)
}

