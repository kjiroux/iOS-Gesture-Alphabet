//
//  ViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

struct GestureCapture {
    //var pitch = ""
    var rollDir = ""   // roll
    //var yaw = ""
}

struct AccelCapture {
    var xAccel = 0.0
    var yAccel = 0.0
    var zAccel = 0.0
}

class ViewController: UIViewController {

    @IBOutlet weak var presenter: UITextField!
    
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
    var reset = 0
    var onSwitch = false
    var gestureCapture: [GestureCapture] = []
    var accelCapture: [AccelCapture] = []
    
    let updateInterval = 0.25
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        // Fixes issue where dark mode causes text to be invisible. PLEASE INCLUDE ON EVERY PAGE
        overrideUserInterfaceStyle = .light

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
            switchOff()
        }
    }
    
    
    // This function turns off all CoreMotion updates after the button has been
    // hit again, and currently prints out the corresponding gesture information
    // that has been captured.
    func switchOff() {
        print("")
        print("Switch off.")
        
        onSwitch = false
        motion.stopAccelerometerUpdates()
        motion.stopGyroUpdates()
        motion.stopDeviceMotionUpdates()
        
        print("_____________________________________________")
        print("Printing Results:")

        /*
        for gesture in gestureCapture {
            print(gesture.rollDir)
        }
 */
        for value in accelCapture {
            print("X: \(value.xAccel) | Y: \(value.yAccel) | Z: \(value.zAccel)")
        }
        
    }
    
    
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
            
                self.xAccel.text = "x: \(Double(x))"
                self.yAccel.text = "y: \(Double(y))"
                self.zAccel.text = "z: \(Double(z))"
                
                self.accelCapture.append(AccelCapture(xAccel: x.rounded(toPlaces: 9), yAccel: y.rounded(toPlaces: 9), zAccel: z.rounded(toPlaces: 9)))
                
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
                
                self.xGyro.text = "x: \(Double(x).rounded(toPlaces: 3))"
                self.yGyro.text = "y: \(Double(y).rounded(toPlaces: 3))"
                self.zGyro.text = "z: \(Double(z).rounded(toPlaces: 3))"
                
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
                
                self.xMotion.text = "Pitch: \(Double(mPitch).rounded(toPlaces: 3))"
                self.yMotion.text = "Roll: \(Double(mRoll).rounded(toPlaces: 3))"
                self.zMotion.text = "Yaw: \(Double(mYaw).rounded(toPlaces: 3))"
                
                
                
                
                if (-0.5 < mRoll && 0.5 > mRoll)
                {
                    self.reset = 0
                    
                    //self.gestureCapture.append(GestureCapture(dir: "_"))
                }
                
                if (self.reset == 0 && -0.5 > mRoll)
                {
                    self.presenter.text = "short"
                    self.reset = 1
                    self.gestureCapture.append(GestureCapture(rollDir: "short"))
                }
                else if (self.reset == 0 && 0.5 < mRoll)
                {
                    self.presenter.text = "long"
                    self.reset = 1
                    
                    self.gestureCapture.append(GestureCapture(rollDir: "long"))
                    
                }
                else if (self.reset == 0 && 1.0 < mPitch) {
                    self.presenter.text = "_"
                    self.reset = 1
                    self.gestureCapture.append(GestureCapture(rollDir: "_"))
                }
            
                /*
                 if mRoll < 0.5 && mRoll > -0.5 {
                    self.presenter.text = ""
                }
                 if (mPitch > 1.0) {
                    if mRoll > 1.3 {
                        self.presenter.text = "A"
                        print("A")
                    }
                    else if mRoll < -1.2 {
                        self.presenter.text = "B"
                        print("B")
                    }
                }
                else if (mPitch > -0.5 && mPitch < 0.5){
                    if mRoll > 1.3 {
                        self.presenter.text = "C"
                        print("C")
                    }
                    else if mRoll < -1.2 {
                        self.presenter.text = "D"
                        print("D")
                    }
                }
                 */
                
            }
        }
        
        
    }
    
}


// Rounds the double to decimal place value
extension Double
{
    func rounded(toPlaces places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
