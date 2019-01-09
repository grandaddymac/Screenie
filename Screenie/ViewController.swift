//
//  ViewController.swift
//  Screenie
//
//  Created by gdm on 1/9/19.
//  Copyright © 2019 gdm. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {

    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var imagePicker: UISegmentedControl!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var micToggle: UISwitch!
    @IBOutlet weak var recordButton: UIButton!
   
    var recorder = RPScreenRecorder.shared()
    private var isRecording = false

    @IBAction func imagePicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedImageView.image = UIImage(named: "skate")
        case 1:
            selectedImageView.image = UIImage(named: "food")
        case 2:
            selectedImageView.image = UIImage(named: "cat")
        case 3:
            selectedImageView.image = UIImage(named: "nature")
        default:
            selectedImageView.image = UIImage(named: "skate")


        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if !isRecording {
            startRecording()
        } else {
              //  stopRecording()
            }
        }
    
    
    func startRecording() {
        guard recorder.isAvailable else {
            print("Recording not available at this time")
            return
        }
        if micToggle.isOn {
            recorder.isMicrophoneEnabled = true
        } else {
            recorder.isMicrophoneEnabled = false
        }
        recorder.startRecording { (error) in
            guard  error == nil else {
                print("There was an error startng the recording.")
                return
            }
            //Call DispatchQueue to update UI in the main thread rather than background
            DispatchQueue.main.async {
                self.micToggle.isEnabled = false
                self.recordButton.setTitleColor(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), for: .normal)
                self.recordButton.setTitle("Stop", for: .normal)
                self.statusLabel.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.statusLabel.text = "Recording..."
                self.isRecording = true
                
                print("Started Recording")
            }
        }
    }
    
}

