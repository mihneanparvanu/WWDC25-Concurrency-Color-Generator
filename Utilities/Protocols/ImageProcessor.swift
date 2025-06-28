//
//  ImageProcessor.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 14.06.2025.
//

import PhotosUI
import SwiftUI

protocol ImageProcessor {
	func extractData (from photo: PhotosPickerItem) async throws -> Data?
	func getImage(from data: Data?) -> UIImage?
}
