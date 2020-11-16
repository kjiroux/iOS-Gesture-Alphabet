//
//  MorseCodeConverter.swift
//  iOS Gesture Alphabet
//
//  Created by Youngjoo Lee on 2020/11/13.
//

import UIKit

class MorseCodeConverter: UIViewController, UITextFieldDelegate {
    
    lazy var textField: UITextField = {
        let width: CGFloat = 250
        let height: CGFloat = 50
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = (self.view.bounds.height - height)/5
        
        let textField = UITextField(frame: CGRect(x: posX, y: posY, width: width, height: height))
        
        textField.text = ""
        
        textField.delegate = self
        
        textField.borderStyle = .roundedRect
        
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    lazy var textField_letter: UITextField = {
        let width: CGFloat = 250
        let height: CGFloat = 50
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = (self.view.bounds.height - height)/1.5
        
        let textField_letter = UITextField(frame: CGRect(x: posX, y: posY, width: width, height: height))

        textField_letter.text = ""
        textField_letter.delegate = self
        textField_letter.borderStyle = .roundedRect
        textField_letter.clearButtonMode = .whileEditing
        
        return textField_letter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.textField)
        self.view.addSubview(self.textField_letter)
    }
    
    // one morsecode to one letter
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var letters = ""
        letters += textField_letter.text!
        
        textField_letter.text = morseToString(textField.text!)
        letters += textField_letter.text!

        textField_letter.text = letters
        print("Before convertion \((textField.text) ?? "Empty")")
        print("After convertion \((textField_letter.text) ?? "Empty")")
        textField.resignFirstResponder()
        
        
        return true
    }
     */
    
    // morse codes to letters
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var letters = ""
        letters += textField_letter.text!
        
        textField_letter.text = morsestringsToString(textField.text!)
        letters += textField_letter.text!

        textField_letter.text = letters
        print("Before convertion \((textField.text) ?? "Empty")")
        print("After convertion \((textField_letter.text) ?? "Empty")")
        textField.resignFirstResponder()
        
        
        return true
    }
    
}

let morseToLetter = [
    ".-": "A",
    "-...": "B",
    "-.-.": "C",
    "-..": "D",
    ".": "E",
    "..-.": "F",
    "--.": "G",
    "....": "H",
    "..": "I",
    ".---": "J",
    "-.-": "K",
    ".-..": "L",
    "--": "M",
    "-.": "N",
    "---": "O",
    ".--.": "P",
    "--.-": "Q",
    ".-.": "R",
    "...": "S",
    "-": "T",
    "..-": "U",
    "...-": "V",
    ".--": "W",
    "-..-": "X",
    "-.--": "Y",
    "--..": "Z",
    ".----": "1",
    "..---": "2",
    "...--": "3",
    "....-": "4",
    ".....": "5",
    "-....": "6",
    "--...": "7",
    "---..": "8",
    "----.": "9",
    "-----": "0",
    " ": " ",
]

// one morsecode to one letter
func morseToString(_ input: String) -> String {
    var returnChar = morseToLetter[String(input)]
    if returnChar == nil {
        returnChar = ""
    }
    return returnChar!
}



// A string of morsecodes to letters (between space of each)
func morsestringsToString(_ input: String) -> String
{
    var returnString = ""
    let strings = input.components(separatedBy: " ")
    
    for onestring in strings
    {
        let returnChar = morseToLetter[String(onestring)]!
        returnString += returnChar + " "
    }
    
    return returnString
    
}
