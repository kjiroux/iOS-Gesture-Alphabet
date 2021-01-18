//
//  MorseCodeConverter.swift
//  iOS Gesture Alphabet
//
//  Created by Youngjoo Lee on 2020/11/13.
//

import UIKit
import CoreMotion



///
struct GestureCapture_cp {
    //var pitch = ""
    var rollDir = ""   // roll
    //var yaw = ""
}

struct AccelCapture_cp {
    var xAccel = 0.0
    var yAccel = 0.0
    var zAccel = 0.0
}
///


class MorseCodeConverter: UIViewController, UITextFieldDelegate {
    
    ///
    
    @IBOutlet weak var presenter: UITextField!
    // weak var morsebox:  UITextField!
    
    // Accelerometer
    @IBOutlet weak var xAccel: UITextField!
    @IBOutlet weak var yAccel: UITextField!
    @IBOutlet weak var zAccel: UITextField!
    
    // Gyroscope
    @IBOutlet weak var xGyro: UITextField!
    @IBOutlet weak var yGyro: UITextField!
    @IBOutlet weak var zGyro: UITextField!
    
    // Device Motion
    @IBOutlet weak var xMotion: UITextField!
    @IBOutlet weak var yMotion: UITextField!
    @IBOutlet weak var zMotion: UITextField!
    
    var motion = CMMotionManager()

    var hReset = 0
    var vReset = 0
    
    // Variable for determining horizontal direction
    // Left is 0, middle is 1, right is 2
    // Perhaps using an enum would be better instead?
    var horizontalMotion = -1
    
    // Variable for determining vertical direction
    // Up is 0, middle is 1, down is 2
    // Perhaps using an enum would be better instead?
    var verticalMotion = -1

    var onSwitch = false
    var gestureCapture: [GestureCapture_cp] = []
    var accelCapture: [AccelCapture_cp] = []
    
    // data (gesture capture) storing
    var recordedgesture: [String] = []
    
    let updateInterval = 0.25
    var acc_x = 0.0
    var acc_y = 0.0
    var acc_z = 0.0
    
    
    // This function captures accelerometer data with the CoreMotionManager motion
    // and Updates the UI to display the most recent accelerometer data.
    func getCoreMotionData()
    {
        motion.accelerometerUpdateInterval = updateInterval
        motion.gyroUpdateInterval = updateInterval
        motion.deviceMotionUpdateInterval = updateInterval
        
        // Accelerometer
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            print(data as Any)
            if let trueData = data {
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                print(x, y, z)
                self.acc_x = x.rounded(toPlaces: 9)
                self.acc_y = y.rounded(toPlaces: 9)
                self.acc_z = z.rounded(toPlaces: 9)
                /*
                self.xAccel.text = "x: \(Double(x))"
                self.yAccel.text = "y: \(Double(y))"
                self.zAccel.text = "z: \(Double(z))"
                */
                self.accelCapture.append(AccelCapture_cp(xAccel: x.rounded(toPlaces: 9), yAccel: y.rounded(toPlaces: 9), zAccel: z.rounded(toPlaces: 9)))
                
            }
        
        }
        
        // Gyroscope
        motion.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            print(data as Any)
            if let trueData = data {
                self.view.reloadInputViews()
                let x = trueData.rotationRate.x
                let y = trueData.rotationRate.y
                let z = trueData.rotationRate.z
                /*
                self.xGyro.text = "x: \(Double(x).rounded(toPlaces: 3))"
                self.yGyro.text = "y: \(Double(y).rounded(toPlaces: 3))"
                self.zGyro.text = "z: \(Double(z).rounded(toPlaces: 3))"
                 */
                
            }
        }
        
        // Device Motion; Pitch, Roll, Yaw
        motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error)
            in
            print(data as Any)
            if let trueData = data {
                self.view.reloadInputViews()
                let mPitch = trueData.attitude.pitch
                let mRoll  = trueData.attitude.roll
                let mYaw   = trueData.attitude.yaw
                
                /*
                self.xMotion.text = "Pitch: \(Double(mPitch).rounded(toPlaces: 3))"
                self.yMotion.text = "Roll: \(Double(mRoll).rounded(toPlaces: 3))"
                self.zMotion.text = "Yaw: \(Double(mYaw).rounded(toPlaces: 3))"
                */

                // In the middle
                if (-0.5 < mRoll && 0.5 > mRoll)
                {
                    self.hReset = 0
                    self.horizontalMotion = 1
                }
                if (-0.5 < mPitch && 0.5 > mPitch)
                {
                    self.vReset = 0
                    self.verticalMotion = 1
                }
                
                // Left
                if (self.hReset == 0 && -0.5 > mRoll)
                {

                    self.hReset = 1
                    self.horizontalMotion = 0

                }
                // Right
                else if (self.hReset == 0 && 0.5 < mRoll)
                {

                    self.hReset = 1
                    self.horizontalMotion = 2

                }
            
                // Up
                if (self.vReset == 0 && -0.5 > mPitch)
                {
                    self.vReset = 1
                    self.verticalMotion = 2
                }
                // Down
                else if (self.vReset == 0 && 0.5 < mPitch)
                {
                    self.vReset = 1
                    self.verticalMotion = 0
                }
                
                // Here is where we print what values we are getting
                if (self.horizontalMotion == 0 && self.verticalMotion == 0)
                {
                    
                    // idea 1) keep holding the record button (or volum down button?) until the user is done his gesture
                    // if the user's done his/her gesture, release the button
                    // then it records how it moves (e.g: bottom left->bottom / bottom->bottom right)
                    // So, translate the movement to letters (bottom(A) / bottom->bottom_left(B) / bottom->bottom_right(C) ...)
                    // Esenssially, the prsenter text box should always prints out the status (like, "bottom" (or "A"), "bottom right" (or "D") / bottom("A")->bottom_left("B") / bottom("A")->bottom_right("C")) to let the user know where he/she starts before recording their gesture.
                    // Then, it's possible to make/design bunch of gestures! (more than 100)
                    // Difficulty)
                    // 1) how to make record button (should be recorded only while the user is pushing the button)
                    // 2) how to make functions (use if statement?)
                    
                    
                    
                    // if we push "caputre" (or "record)" button,
                    // then, the letter that is assgined will print out in the text box
                    
                    // Problem 1) How to get accelometer data?
                    // Problem 2) How much time we need without changing letter to push the record button
                    // Problem 3) Do we need to make "reset" button ? // I don't think so
                    // Problem 4) Do we need Gyroscope data?
                    
                    // no accelometer data, then it will print E
                    // IMPORTANT: x y z are accelometer data that is printed out on the screen!
                    
                    self.presenter.text = "bottom_left"
                    //self.presenter.text = "E" // bottom left (x = -0.87 / y = -0.48 / z = -0.085) (left side)
                    // ~ (x = -0.177 / y = -0.98 / z = -0.038) (bottom side)
                    
                    
                    // with accelometer data on x-axis, then 'A' will be B
                    // Need more testing to find proper accelometer data.!!!!!!!!
                    // Need more data how accelometer seonsor works.!!!!!!!!!!!
                    /*
                    if(self.acc_x > 0 && self.acc_y <= 0 && self.acc_z <= 0)
                    {
                        self.presenter.text = "F"
                    }
                    else if(self.acc_x <= 0 && self.acc_y > 0 && self.acc_z <= 0)
                    {
                        self.presenter.text = "G"
                    }
                    else if(self.acc_x <= 0 && self.acc_y <= 0 && self.acc_z > 0)
                    {
                        self.presenter.text = "H"
                    }
                    */
                    
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 1)
                {
                    self.presenter.text = "M" // left (x = -0.99 / y = 0.007 / z = -0.12)
                                            // need upper middle side and lower middle side
                    // N
                    // O
                    // P
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top left" // top_left (x = -0.80 / y = 0.52 / z = -0.048) (left side)
                    // ~ (x = -0.11 / y = 1.00 / z = -0.11) (top side)
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 0)
                {
                    self.presenter.text = "bottom"
                    /*
                    self.presenter.text = "A" // bottom (x = -.008 / y = -0.99 / z = -0.001)
                                            // need upper middle side and lower middle side
                    
                    if(self.acc_x > 0.09 && self.acc_y <= 0 && self.acc_z <= 0) // move up
                    {
                        self.presenter.text = "B"
                    }
                    else if(self.acc_x > 0.2 && self.acc_y <= 0 && self.acc_z <= 0) // move right
                    {
                        self.presenter.text = "C"
                    }
                    else if(self.acc_x < -0.15 && self.acc_z < -0.2) // move left
                    {
                        self.presenter.text = "D"
                    }
                    */
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 1)
                {
                    self.presenter.text = "middle" // middle (x = -0.007 / y = 0.017 / z = -1.0)
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top" // top (x = 0.011 / y = 1.028 / z = -0.065)
                                            // need upper middle side and lower middle side
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 0)
                {
                    self.presenter.text = "bottom_right"
                    //self.presenter.text = "I" //bottom right (x = 0.77 / y =-0.59 / z = -0.125) (right side)
                                                // ~ (x = 0.175 / y =-0.98 / z = -0.073) (bottom side)
                    //J
                    //K
                    //L
                    
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 1)
                {
                    self.presenter.text = "right" // right (x = 1.00 / y = -0.001 / z = -0.11)
                                                // need upper middle side and lower middle side
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top right" // top_right (
                }
                
            }
        }
        
        
    }
    ///
    
    
    
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
        
        // Fixes issue where dark mode causes text to be invisible. PLEASE INCLUDE ON EVERY PAGE
        overrideUserInterfaceStyle = .light
        
        //self.view.addSubview(self.textField)
        self.view.addSubview(self.textField_letter)
        
        // long press button
        let longbutton = UILongPressGestureRecognizer(target: self, action: #selector(readinggesture(press:)))
        longbutton.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longbutton)
    }
    
    //dupicated value remove
    func removeduplicate (_ array: [String]) -> [String]
    {
        var removedarray = [String]()
        for i in array
        {
            if removedarray.contains(i) == false
            {
                removedarray.append(i)
            }
        }
        return removedarray
    }
    
    // this function is to print out the result depending on the gesture
    func printgesture(_ array: [String]) -> String
    {
        /*
        for index in 0..<array.count
        {
            if (array[i] == "bottom")
            {
                
            }
        }
        */
        
        //for little demo!
        if array.count == 1
        {
            if array[0] == "bottom"
            {
                return "A"
            }
        }
        else if array.count == 2
        {
            if array[0] == "bottom" && array[1] == "bottom_left"
            {
                return "B"
            }
            else if array[0] == "bottom" && array[1] == "bottom_right"
            {
                return "C"
            }
        }
        return "err"
    }
    
    // alter action
    let alert = UIAlertController(title: "Longpress", message: "Success", preferredStyle: UIAlertController.Style.alert)
    let okaction = UIAlertAction(title: "OK", style: .default) { (action) in }
    
    
    //record and reading gesture (Not working)
    @objc func readinggesture(press:UILongPressGestureRecognizer)
    {
        //alert.addAction(okaction)
        //present(alert, animated: false, completion: nil)
        
        // How to repeat this action while the user is holding the button: NSTimer
        // stackoverflow.com/questions/41807787/call-uibuttons-action-multiple-times-on-long-press
        if press.state == .began // if error, then use .active
        {
            //action when the user press action
            //storing gesture!!
            print("begin")
            recordedgesture.append(self.presenter.text!)
        }
        
        if press.state == .ended
        {
            print("ended")
            // action when the user release
            
            // remove duplicated values
            recordedgesture = removeduplicate(recordedgesture)
            
            // printing out!
            var lettervalue:String = ""
            lettervalue += textField_letter.text!
            lettervalue += printgesture(recordedgesture)
            
            textField_letter.text = lettervalue
            
            
            //reset
            recordedgesture.removeAll()
        }
    }
    
    // when press "return" (or "enter" button on the keyboard)
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
    /*
    // This is in direct relation to the button and when it is hit. onSwitch is
    // a boolean variable which determines if CoreMotion data should be started,
    // as well as clears the gestureCapture array before getting started.
    @IBAction func recordButton(_ sender: UIButton) {
        
        onSwitch = !onSwitch
        accelCapture = []
        gestureCapture = []
        getCoreMotionData()
        
        if (onSwitch == true) {
            print("Capture data.")
            var temp_letter = ""
            // prsenter.text data capture
            // 여기서 바텀래프트 라이트 같은것 (프레젠터에 있는값)을 캡처버튼을 누르면 모스코드 페이지의 위쪽 텍스트 박스에
            // 점차 쌓이게 되도록 설정해놓자.
            // 그리고 모스코드 볂환 버튼(엔터키)를 누르면 그 텍스트필드는 비어있도록 설정해놓고 아래 텍스트박스에 모스코드 변환값을 넣을것
            //  바텀레프트는 닷, 바텀 라이트는 대쉬, 그냥 바텀은 스페이스바로 설정하자.
            temp_letter += textField_letter.text!
            temp_letter += self.presenter.text!
            textField_letter.text = temp_letter
            onSwitch = false
        }
    }
     */
    // This is in direct relation to the button and when it is hit. onSwitch is
    // a boolean variable which determines if CoreMotion data should be started,
    // as well as clears the gestureCapture array before getting started.
    @IBAction func recordButton(_ sender: UIButton) {
        
        onSwitch = !onSwitch
        
        if (onSwitch == true) {
            print("Switch On.")
            accelCapture = []
            gestureCapture = []
            getCoreMotionData()
        }
        else {
            switchOff_cp()
        }
    }
    
    
    // This function turns off all CoreMotion updates after the button has been
    // hit again, and currently prints out the corresponding gesture information
    // that has been captured.
    func switchOff_cp() {
        print("")
        print("Switch off.")
        
        onSwitch = false
        
        var temp_letter = ""
        // prsenter.text data capture
        // 여기서 바텀래프트 라이트 같은것 (프레젠터에 있는값)을 캡처버튼을 누르면 모스코드 페이지의 위쪽 텍스트 박스에
        // 점차 쌓이게 되도록 설정해놓자.
        // 그리고 모스코드 볂환 버튼(엔터키)를 누르면 그 텍스트필드는 비어있도록 설정해놓고 아래 텍스트박스에 모스코드 변환값을 넣을것
        //  바텀레프트는 닷, 바텀 라이트는 대쉬, 그냥 바텀은 스페이스바로 설정하자.
        temp_letter += textField_letter.text!
        temp_letter += self.presenter.text!
        textField_letter.text = temp_letter
        
        motion.stopAccelerometerUpdates()
        motion.stopGyroUpdates()
        motion.stopDeviceMotionUpdates()
        
        
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

func morseToString(_ input: String) -> String {
    var returnChar = morseToLetter[String(input)]
    if returnChar == nil {
        returnChar = ""
    }
    return returnChar!
}
