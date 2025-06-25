//
//  DeleteCurrentImage.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 18.06.2025.
//

import SwiftUI

struct DeleteCurrentImage: View {
    var body: some View {
		VStack (spacing: 20){
			Image(systemName: "trash.fill")
				.padding()
				.foregroundStyle(.red)
				.background(.red.opacity(0.1))
				.clipShape(Circle())
			
			Text("Are you sure you want to delete the current image?")
			
			buttons
		}
		.padding(44)
		
    }
}

extension DeleteCurrentImage {
	var buttons: some View {
		VStack (spacing: 24){
			Button {} label: {
			Text ("Yes, delete")
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.padding(12)
					.background(.red.opacity(0.9))
					.clipShape(Capsule())
			
			}
	
			
			Button {} label : {
			Text ("Cancel")
					.padding(12)
					.frame(maxWidth: .infinity)
					.background(Color(.systemGray5))
					.clipShape(Capsule())
			}
		}
		.buttonStyle(.plain)
	}
}

#Preview {
    DeleteCurrentImage()
}
