//
//  SoundManager.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 28/10/2025.
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    // Play completion sound
    func playCompletionSound() {
        // Using system sound for task completion
        // System Sound ID 1519 is a nice "pop" sound
        AudioServicesPlaySystemSound(1519)
        
        // Add haptic feedback for extra satisfaction
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Alternative: Play custom sound file
    func playCustomSound(named soundName: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("Sound file not found: \(soundName).\(ext)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    // Play different sound for uncompleting a task
    func playUncompleteSound() {
        // System Sound ID 1520 is a subtle "click"
        AudioServicesPlaySystemSound(1520)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
