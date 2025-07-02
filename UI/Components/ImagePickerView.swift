//
//  ImageSelection.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 18.06.2025.
//

import PhotosUI
import SwiftUI

struct ImagePickerView: View {
	@Bindable var vm: ImagePickerViewModel
	let mode: ImagePickerMode
	
	var body: some View {
		switch mode {
			case .select:
				SelectView(
					selectedItem: $vm.selection.item,
					image: vm.selection.image
				)
			case .edit(let currentImage):
				EditView(
					currentImage: currentImage,
					selectedItem: $vm.selection.item,
					selectedImage: vm.selection.image
				)
		}
	}
}


//MARK: SelectView
private extension ImagePickerView {
	struct SelectView: View {
		@Binding var selectedItem: PhotosPickerItem?
		
		let image: Image?
		var body: some View {
			VStack {
				toolbar
				
				selectedPhoto
			}
		}
	}
}


//Top toolbar
extension ImagePickerView.SelectView {
	@ViewBuilder var toolbar: some View {
		HStack {
			Spacer ()
			PhotosPicker(selection: $selectedItem, matching: .images) {
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
extension ImagePickerView.SelectView {
	var selectedPhoto: some View {
		Group {
			if let image {
				image
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
	}
}


//EditView
private extension ImagePickerView {
	struct EditView: View {
		let currentImage: Image?
		@Binding var selectedItem: PhotosPickerItem?
		let selectedImage: Image?
		
		var body: some View {
				editImage
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100)
					.clipShape(
						.rect(
							cornerRadius: UI.Constants.Spacing.minCornerRadius
						)
					)
				
			PhotosPicker(selection: $selectedItem, label: {
					Label("Change image", systemImage: "photo")
				})
			}
		}
}

extension ImagePickerView.EditView {
	var editImage: Image {
		if let image = selectedImage {
			return image
		} else {
			return currentImage ?? Image(systemName: "phototrianglebadge.exclamationmark")
		}
	}
}



enum ImagePickerMode {
	case select, edit(currentImage: Image)
}


#Preview {
	@Previewable @State var vm = ImagePickerViewModel(imageProcessor: ImageProcessingService())
	
	ImagePickerView(vm: vm, mode: .select)
	
}

#Preview {
	@Previewable @State var vm = ImagePickerViewModel(imageProcessor: ImageProcessingService())
	let image = ProcessedImageDisplay.preview().image
	
	ImagePickerView(
		vm: vm,
		mode: .edit(currentImage: image)
	)
}
