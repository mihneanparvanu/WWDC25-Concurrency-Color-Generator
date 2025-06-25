//
//  ImageSelection.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 18.06.2025.
//

import PhotosUI
import SwiftUI

struct ImagePickerView: View {
	@State var vm: ImageSelectionViewModel
	@State private var photo: Image?
	let mode: ImageSelectionViewMode
	let currentImage: Image?
	
	///Select mode
	init(
		vm: ImageSelectionViewModel,
	) {
		self.mode = .select
		self.currentImage = nil
		self._vm = State(initialValue: vm)
	}
	
	///Edit mode
	init (vm: ImageSelectionViewModel, currentImage: Image){
		self.mode = .edit
		self._vm = State(initialValue: vm)
		self.currentImage = currentImage
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
#warning("TODO: Error handling")
			photo = nil
		}
	}
}

//MARK: editView
extension ImagePickerView {
	var editView: some View {
		VStack {
			currentImage
			
			PhotosPicker(selection: $vm.selectedImage, label: {
				Label("Change image", systemImage: "photo")
			})	}
	}
}


enum ImageSelectionViewMode {
	case select, edit
}

#Preview {
	let vm = ImageSelectionViewModel(imageProcessor: ImageProcessingSevice())
	
	ImagePickerView(vm: vm)
	
	ImagePickerView(vm: vm, currentImage: ProcessedImageDisplay.preview.image)
}
