//
//  SoundManager.swift
//  Color Generator
//
//  Created by Mihnea Nicolae Pârvanu on 29.06.2025.
//

import AVFoundation
import Playgrounds

struct SoundManager {
	func playSound(_ sound: Sound){
		AudioServicesPlaySystemSound(sound.rawValue)
	}
	
	enum Sound: SystemSoundID {
		case tap = 1104
		case success = 1025
		case error = 1053
		case tink = 1103
		case shake = 1109
		case beep = 1000
		case refresh = 1351
		case applePay = 1407
	}
}

