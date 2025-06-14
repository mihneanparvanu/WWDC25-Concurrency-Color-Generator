//
//  ProcessedImageDetailView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 13.06.2025.
//

import SwiftUI

struct ProcessedImageDetailView: View {
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	let displayImage: ProcessedImageDisplay
	var body: some View {
		ImageCard(displayImage: displayImage,
				  width: 350)
		
		
		buttons
		
	}
}

//MARK: Buttons
extension ProcessedImageDetailView {
	var buttons: some View {
		
		HStack (spacing: 16){
			Button {
				
			} label: {
				buttonLabel(systemName: "pencil", color: .gray)
			}
			
			
			Button {
				
				context.delete(displayImage.processedImage)
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
		 .background(color.opacity(0.1))
		 .clipShape(Circle())
		 .foregroundStyle(color)
	}
	
}



#Preview {
	ProcessedImageDetailView(
		displayImage: ProcessedImageDisplay.preview
	).buttons
}

