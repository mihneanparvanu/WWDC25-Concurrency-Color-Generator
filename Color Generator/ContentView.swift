//
//  ContentView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 11.06.2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
	@State private var vm = ContentViewViewModel()
	@State private var photo: Image?
	var body: some View {
		VStack () {
			toolbar
			
			selectedPhoto
		}
		.onChange(of: vm.selectedPhoto) { old, new in
			if new == nil {
				photo = nil
			}
			Task {
				do {
					photo = try await vm.getSelectedPhoto()
				}
				catch {
					photo = nil
				}
			}
		}
	}
}

//MARK: Top toolbar
extension ContentView {
	@ViewBuilder var toolbar: some View {
		HStack {
			Spacer ()
			PhotosPicker(selection: $vm.selectedPhoto, matching: .images) {
				Label("Select a photo", systemImage: "photo")
					.font(.system(size: 14))
					.padding()
					.background(Color(.systemGray6))
					.clipShape(Capsule())
					
			}
			.buttonStyle(.plain)
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
					.frame(width: .infinity, height: 400)
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

//MARK: Extract colors
extension ContentView {
	var extractColors: some View {
		EmptyView()
	}
}


#Preview {
	ContentView()
}
