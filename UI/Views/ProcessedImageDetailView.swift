//
//  ProcessedImageDetailView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI

struct ProcessedImageDetailView: View {
	@Bindable var image: ProcessedImage
	@Binding var pickerVM: ImagePickerViewModel
	@State private var sheetContent: SheetContent?
	
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		VStack (spacing: 32){
			ImageCard(displayImage: image.display,
					  width: 350)
			
			buttons
		}
		.sheet(item: $sheetContent){content in
			sheetView(content: content)
				.presentationDetents(content.detents)
		}
		.onChange(of: pickerVM.selection.uiImage, {
			Task {
				try await image.update(with: pickerVM.selection.uiImage)
			}
			
		})
	}
}

//MARK: Buttons
extension ProcessedImageDetailView {
	var buttons: some View {
		HStack (spacing: 16){
			Button {
				sheetContent = .edit
				UI.Haptics.playLightHaptic()
			} label : {
				buttonLabel(systemName: "pencil", color: .blue)
			}
			
			Button {
				sheetContent = .delete
			} label: {
				buttonLabel()
			}
		}
		.buttonStyle(.glass)
	}
	
	
	@ViewBuilder func buttonLabel (systemName: String = "trash.fill", color: Color = .red) -> some View {
		Image(systemName: systemName)
			.padding()
			.frame(width: 44, height: 44)
			.foregroundStyle(color)
	}
	
}


//MARK: Sheet Logic
extension ProcessedImageDetailView {
	@ViewBuilder func sheetView(content: SheetContent) -> some View {
		switch content {
			case .edit:
				ImagePickerView(
					vm: $pickerVM,
					mode: .edit(currentImage: image.display.image)
				)
			case .delete:
				DeleteCurrentImage(image: image, dismissNav: {
					dismiss()
				})
		}
	}
}


enum SheetContent: String, Identifiable {
	case edit, delete
	
	var id: String {
		self.rawValue
	}
	
	var detents: Set<PresentationDetent> {
		let fraction: PresentationDetent = .fraction(0.4)
		switch self {
			case .edit:
				return [fraction, .medium]
			case .delete:
				return [fraction]
		}
	}
}


#Preview {
	@Previewable @State var pickerVM = ImagePickerViewModel(imageProcessor: ImageProcessingSevice())
	let image = ProcessedImageDisplay.preview.processedImage
	
	ProcessedImageDetailView(image: image,
							 pickerVM: $pickerVM)
	
}

#Preview {
	@Previewable @State var pickerVM = ImagePickerViewModel(imageProcessor: ImageProcessingSevice())
	
	let image = ProcessedImageDisplay.preview.image
	ImagePickerView(vm: $pickerVM, mode: .edit(currentImage: image))
}
