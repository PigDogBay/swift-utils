//
//  SoundUtils.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import AVFoundation

public func mpdbSpeak(text : String){
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: text)
    let locale = Locale.current.identifier
    utterance.voice = AVSpeechSynthesisVoice(language: locale)
    synthesizer.speak(utterance)
}
