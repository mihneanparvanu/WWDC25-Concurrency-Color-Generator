//
//  Color_GeneratorApp.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 11.06.2025.
//

import SwiftData
import SwiftUI

@main
struct Color_GeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: ProcessedImage.self)
    }
		
}
