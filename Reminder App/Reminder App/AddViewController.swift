//
//  AddViewController.swift
//  Reminder App
//
//  Created by GGS-BKS on 24/08/22.
//

import UIKit
import Speech
import InstantSearchVoiceOverlay


class AddViewController:ViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var titleSpeech: UIButton!
    @IBOutlet weak var descSpeech: UIButton!
    let voiceOverlayController = VoiceOverlayController()
    
    public var completion: ((String,String,Date)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dataFile as Any)
        
    }
    @objc func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !titleText.isEmpty{
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
            //            self.createItem(name: titleText, identifier: bodyText, date: targetDate)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func titleSpeechPressed(_ sender: UIButton) {
        voiceOverlayController.start(on: self) { text, final,_ in
            if final {
                print("Text:\(text)")
                self.titleField.text = text
            }else{
                print("in pogress \(text)")
            }
        } errorHandler: {error in
            print("voice output: error \(String(describing: error))")
        }
            }
    
    @IBAction func descSpeechPressed(_ sender: UIButton) {
        voiceOverlayController.start(on: self) { text, final,_ in
            if final {
                print("Text:\(text)")
                self.bodyField.text = text
            }else{
                print("in pogress \(text)")
            }
        } errorHandler: {error in
            print("voice output: error \(String(describing: error))")
        }

    }
    
    }

