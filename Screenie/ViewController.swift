//
//  ViewController.swift
//  Screenie
//
//  Created by gdm on 1/9/19.
//  Copyright © 2019 gdm. All rights reserved.
//

//NOT TESTED ON HARDWARE

import UIKit
import ReplayKit

class ViewController: UIViewController, RPPreviewViewControllerDelegate {

    
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
                stopRecording()
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
    
    func stopRecording() {
        recorder.stopRecording { (preview, error) in
            guard preview != nil else {
                print("Preview controller not available")
                return
            }
            
            let alert = UIAlertController(title: "Recording finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.recorder.discardRecording {
                    print("Recording discarded successfully.")
                }
            })
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            })
            alert.addAction(deleteAction)
            alert.addAction(editAction)
            self.present(alert, animated: true, completion: nil)
            
            self.isRecording = false
            self.viewReset()
        }
    }
    
    func viewReset() {
        micToggle.isEnabled = true
        statusLabel.text = "Ready to Record"
        statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        recordButton.setTitle("Record", for: .normal)
        recordButton.setTitleColor(#colorLiteral(red: 0.2994912565, green: 0.7500386834, blue: 0.3387371898, alpha: 1), for: .normal)
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

