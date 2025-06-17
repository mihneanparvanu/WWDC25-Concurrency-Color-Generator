//
//  ColorExtractor.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 12.06.2025.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension UIImage {
	func extractColors(_ count: Int) async throws -> [UIColor] {
		guard let ciImage = CIImage(image: self) else {
			return []
		}
		
		let kMeansFilter = CIFilter.kMeans()
		kMeansFilter.inputImage = ciImage
		kMeansFilter.extent = ciImage.extent
		kMeansFilter.count = count
		kMeansFilter.perceptual = true
		
		guard let kMeansOutput = kMeansFilter.outputImage else {
			return []
		}
		
		let paletteFilter = CIFilter.palettize()
		paletteFilter.inputImage = ciImage
		paletteFilter.paletteImage = kMeansOutput
		
		guard let paletteOutput = paletteFilter.outputImage else {
			return []
		}
		
		let context = CIContext()
		
		guard let cgImage = context.createCGImage(
			paletteOutput,
			from: paletteOutput.extent) else {
			return []
		}

		//Extract the colors from the palettized image
		
		let downscaleSize = 64
		let width = downscaleSize
		let height = downscaleSize
		let bytesPerPixel = 4 // Assuming RGBA
		let bytesPerRow = bytesPerPixel * width
		let bitsPerComponent = 8
		
		var rawData = [UInt8](repeating: 0, count: Int(width * height * bytesPerPixel))
		let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
		
		guard let renderContext = CGContext(data: &rawData,
											width: width,
											height: height,
											bitsPerComponent: bitsPerComponent,
											bytesPerRow: bytesPerRow,
											space: CGColorSpaceCreateDeviceRGB(),
											bitmapInfo: bitmapInfo)
		else {
			return []
		}
		
		renderContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
		
		var uniqueColorsSet: Set<UIColor> = []
		var extractedColors: [UIColor] = [] // Maintain order of appearance
		
		for y in 0..<height {
			for x in 0..<width {
				
				// Stop if already found count number of colors
				if extractedColors.count >= count {
					return extractedColors
				}
				
				let offset = (y * width + x) * bytesPerPixel
				let r = CGFloat(rawData[offset]) / 255.0
				let g = CGFloat(rawData[offset + 1]) / 255.0
				let b = CGFloat(rawData[offset + 2]) / 255.0
				// Alpha component is rawData[offset + 3] if needed, but for solid colors often 1.0
				
				let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
				
				// Use a very small tolerance here, as the palettized image should have
				if !uniqueColorsSet.contains(where: { $0.isVisuallySimilar(to: color, tolerance: 0.0001) }) {
					uniqueColorsSet.insert(color)
					extractedColors.append(color)
				}
			}
		}
		return extractedColors
	}
}


extension UIColor {
	func isVisuallySimilar(to otherColor: UIColor, tolerance: CGFloat) -> Bool {
		var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
		var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
		
		self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
		otherColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
		
		let dr = r1 - r2
		let dg = g1 - g2
		let db = b1 - b2
		
		let distance = sqrt(dr*dr + dg*dg + db*db)
		return distance < tolerance
	}
}


enum ColorExtractionError: Error {
	case noImageFound, coreImageCreationFailed, kmeansFilterFailed, paletteGenerationFailed, cgImageConversionFailed, contextRenderingFailed, unknown
	
	var localizedDescription: String  {
		switch self {
			case .noImageFound:
				return "No image found."
				case .coreImageCreationFailed:
				return "Failed to create CoreImage context."
			case .kmeansFilterFailed:
				return "Failed to apply K-Means clustering filter."
			case .paletteGenerationFailed:
				return "Failed to generate color palette."
			case .cgImageConversionFailed:
				return "Failed to convert CGImage."
			case .contextRenderingFailed:
				return "Failed to render context."
			case .unknown:
				return "Unknown error."
		}
	}
}
