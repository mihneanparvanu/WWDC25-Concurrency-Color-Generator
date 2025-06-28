//
//  FileService.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 28.06.2025.
//

import SwiftUI

protocol FileService {
	func saveImage(_ uiImage: UIImage) throws -> URL 
}

