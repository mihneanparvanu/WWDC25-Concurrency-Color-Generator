//
//  ProcessedImageDetailView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI

struct ProcessedImageDetailView: View {
	var image: ProcessedImage
	@Binding var pickerVM: ImagePickerViewModel
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss

	@State private var shouldPresentSheet: Bool = false
	@State private var sheetContent: SheetContent = .delete


	var body: some View {
		VStack (spacing: 32){
			ImageCard(displayImage: displayImage,
					  width: 350)
			
			buttons
		}
		.sheet(isPresented: $shouldPresentSheet){
			sheetContentView
		}
	}
}

//MARK: Buttons
extension ProcessedImageDetailView {
	var buttons: some View {
		HStack (spacing: 16){
			Button {
				sheetContent = .edit
				shouldPresentSheet.toggle()
			} label: {
				buttonLabel(systemName: "pencil", color: .gray)
			}
			Button {
				sheetContent = .delete
				shouldPresentSheet.toggle()
				context.delete(image)
				print (context.hasChanges)
				
				try? context.save()
				dismiss()
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
	}
	
}

//MARK: Useful
extension ProcessedImageDetailView {
	var displayImage: ProcessedImageDisplay {
		ProcessedImageDisplay(processedImage: image)
	}
}

#Preview {
	@Previewable @State var pickerVM = ImagePickerViewModel(imageProcessor: ImageProcessingSevice())
	let image = ProcessedImageDisplay.preview.processedImage
	
	ProcessedImageDetailView(image: image,
							 pickerVM: $pickerVM)
		
}


//MARK: Sheet Logic
extension ProcessedImageDetailView {
	@ViewBuilder var sheetContentView: some View {
		switch sheetContent {
			case .edit:
				ImagePickerView(vm: $pickerVM, currentImage: displayImage.image)
			case .delete:
				DeleteCurrentImage()
		}
	}
}


enum SheetContent {
	case edit, delete
}
