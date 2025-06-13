//
//  ContentView.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 11.06.2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
	@Environment(\.modelContext) var context
	@State private var vm = ContentViewViewModel()
	@State private var photo: Image?
	var body: some View {
		VStack () {
			toolbar
			
			selectedPhoto
			
			extractColors(vm.intColorCount)
			
			colorsDisplay
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
	@ViewBuilder func extractColors (_ colorsNumber: Int) -> some View {
		VStack {
			Button {
				vm.extractColors(vm.intColorCount)
			} label :{
				Text ("Extract \(colorsNumber) colors")
					.padding(64)
					.overlay {
						Circle()
							.stroke(style: .init(lineWidth: 2))
							.fill(Color(.systemGray4))
					}
			}
			.buttonStyle(.glass)
			
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
}

//MARK: Colors display
extension ContentView {
	@ViewBuilder var colorsDisplay: some View {
		ScrollView(.horizontal){
			HStack {
				ForEach(vm.extractedColors, id: \.self) {color in
					Color(color)
						.frame(width: 100, height: 100)
				}
			}
		}
	}
}

#Preview {
	ContentView()
}
