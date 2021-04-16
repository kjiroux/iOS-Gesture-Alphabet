//
//  MorseCodeConverter.swift
//  iOS Gesture Alphabet
//
//  Created by Youngjoo Lee on 2020/11/13.
//
/*
* Motion Data Gesture Alphabet
* Record motion data while touching the screen
* Print letter after releasing from the screen.
* More data: branch name= gestureconverter
* IMPORTANT: Positions that already visited will be ignored 
(e.g: bottom->bottom_left->bottom  == bottom->bottom_left) (the second "bottom" is ignored.) 

A: bottom
B: bottom -> bottom_left
C: bottom -> bottom_right
D: bottom_left
E: bottom_left -> left
F: bottom_left -> bottom
G: left
H: left -> bottom_left
I: left -> top_left
J: top_left
K: top_left -> left
L: top_left -> top
M: top
N: top -> top_left
O: top -> top_right
P: top_right
Q: top_right -> top
R: top_right -> right
S: right
T: right -> top_right
U: right -> bottom_right
V: bottom_right
W: bottom_right -> right
X: bottom_right -> bottom
Y: bottom -> bottom_left -> bottom_right
Z: bottom -> bottom_right -> bottom_left

space: middle

0: middle -> bottom
1: middle -> bottom_left
2: middle -> left
3: middle -> top_left
4: middle -> top
5: middle -> top_right
6: middle -> right
7: middle -> bottom_right
8: middle -> bottom -> bottom_left
9: middle -> bottom -> bottom_right
*/


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
                    
                    self.presenter.text = "bottom_left"
                    
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 1)
                {
                    self.presenter.text = "left"
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top_left"
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 0)
                {
                    self.presenter.text = "bottom"
   
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 1)
                {
                    self.presenter.text = "middle"
                }
                else if (self.horizontalMotion == 1 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top"
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 0)
                {
                    self.presenter.text = "bottom_right"
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 1)
                {
                    self.presenter.text = "right"
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top_right"
                }
                
            }
        }
    }
    
    lazy var textField_letter: UITextField = {
        let width: CGFloat = 200
        let height: CGFloat = 50
        let posX: CGFloat = (self.view.bounds.width - width)/2
        let posY: CGFloat = (self.view.bounds.height - height)/2
        
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
        longbutton.minimumPressDuration = 0.5
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
        
        //for little demo!
        if array.count == 1
        {
            if array[0] == "bottom"
            {
                return "A"
            }
            else if array[0] == "bottom_left"
            {
                return "D"
            }
            else if array[0] == "left"
            {
                return "G"
            }
            else if array[0] == "top_left"
            {
                return "J"
            }
            else if array[0] == "top"
            {
                return "M"
            }
            else if array[0] == "top_right"
            {
                return "P"
            }
            else if array[0] == "right"
            {
                return "S"
            }
            else if array[0] == "bottom_right"
            {
                return "V"
            }
            else if array[0] == "middle"
            {
                return " "
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
            else if array[0] == "bottom_left" && array[1] == "left"
            {
                return "E"
            }
            else if array[0] == "bottom_left" && array[1] == "bottom"
            {
                return "F"
            }
            else if array[0] == "left" && array[1] == "top_left"
            {
                return "H"
            }
            else if array[0] == "left" && array[1] == "bottom_left"
            {
                return "I"
            }
            else if array[0] == "top_left" && array[1] == "left"
            {
                return "K"
            }
            else if array[0] == "top_left" && array[1] == "top"
            {
                return "L"
            }
            else if array[0] == "top" && array[1] == "top_left"
            {
                return "N"
            }
            else if array[0] == "top" && array[1] == "top_right"
            {
                return "O"
            }
            else if array[0] == "top_right" && array[1] == "top"
            {
                return "Q"
            }
            else if array[0] == "top_right" && array[1] == "right"
            {
                return "R"
            }
            else if array[0] == "right" && array[1] == "top_right"
            {
                return "T"
            }
            else if array[0] == "right" && array[1] == "bottom_right"
            {
                return "U"
            }
            else if array[0] == "bottom_right" && array[1] == "right"
            {
                return "W"
            }
            else if array[0] == "bottom_right" && array[1] == "bottom"
            {
                return "X"
            }
            else if array[0] == "middle" && array[1] == "bottom"
            {
                return "0"
            }
            else if array[0] == "middle" && array[1] == "bottom_left"
            {
                return "1"
            }
            else if array[0] == "middle" && array[1] == "left"
            {
                return "2"
            }
            else if array[0] == "middle" && array[1] == "top_left"
            {
                return "3"
            }
            else if array[0] == "middle" && array[1] == "top"
            {
                return "4"
            }
            else if array[0] == "middle" && array[1] == "top_right"
            {
                return "5"
            }
            else if array[0] == "middle" && array[1] == "right"
            {
                return "6"
            }
            else if array[0] == "middle" && array[1] == "bottom_right"
            {
                return "7"
            }

        }
        else if array.count == 3
        {
            if array[0] == "bottom" && array[1] == "bottom_left" && array[2] == "bottom_right"
            {
                return "Y"
            }
            else if array[0] == "bottom" && array[1] == "bottom_right" && array[2] == "bottom_left"
            {
                return "Z"
            }
            else if array[0] == "middle" && array[1] == "bottom" && array[2] == "bottom_left"
            {
                return "8"
            }
            else if array[0] == "middle" && array[1] == "bottom" && array[2] == "bottom_right"
            {
                return "9"
            }
        }
        return " "
    }
    
    

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
            // timerbegin()
        }
        
        if press.state == .changed
        {
            print("changed")
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
        textField_letter.text = ""
        print("Before convertion \((textField.text) ?? "Empty")")
        print("After convertion \((textField_letter.text) ?? "Empty")")
        textField.resignFirstResponder()
        
        return true
    }
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
        
        temp_letter += textField_letter.text!
        temp_letter += self.presenter.text!
        textField_letter.text = temp_letter
        
        motion.stopAccelerometerUpdates()
        motion.stopGyroUpdates()
        motion.stopDeviceMotionUpdates()
        
        
    }
    
}
