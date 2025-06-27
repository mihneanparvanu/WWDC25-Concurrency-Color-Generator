//
//  ColorExtractor.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 27.06.2025.
//

import Foundation
import SwiftUI

protocol ColorExtractor {
	func extractColors(count: Int, from: UIImage?) async throws -> [Color]
}
