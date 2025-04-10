//
//  SoundManager.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-04-08.
//

import SwiftUI
import AVFoundation
import FirebaseFirestore

class SoundManager: NSObject, ObservableObject {
    @Published var sound: Bool = true 
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var audioSession = AVAudioSession.sharedInstance()
    private let soundNames = ["Countdown", "Start", "Complete"]
    private var db = Firestore.firestore()

    override init() {
        super.init()
        preloadSounds()
    }

    private func preloadSounds() {
        do {
            try audioSession.setCategory(.playback, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch { }

        for name in soundNames {
            if let asset = NSDataAsset(name: name) {
                do {
                    let player = try AVAudioPlayer(data: asset.data)
                    player.delegate = self
                    player.prepareToPlay()
                    audioPlayers[name] = player
                } catch { }
            }
        }
    }

    func playSound(name: String, shouldDeactivateAfter: Bool = false) {
        guard let player = audioPlayers[name] else {
            print("Sound \(name) not loaded.")
            return
        }

        do {
            try audioSession.setCategory(.playback, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch { }

        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }

        player.accessibilityHint = shouldDeactivateAfter ? "deactivate" : nil
        player.play()
    }

    private func deactivateSession() {
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch { }
    }
    
    func saveSoundPreference(userId: String, sound: Bool) {
        db.collection("users").document(userId).setData(["sound": sound], merge: true)
        self.sound = sound
    }
    
    func getSoundPreference(userId: String) {
            db.collection("users").document(userId).getDocument { document, error in
                if error != nil {
                    self.sound = true
                    return
                } else {
                    if let document = document, document.exists, let soundPreference = document.get("sound") as? Bool {
                        self.sound = soundPreference
                        return
                    } else {
                        self.sound = true
                        return
                    }
                }
            }
        }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player.accessibilityHint == "deactivate" {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                self.deactivateSession()
            }
        }
    }
}
