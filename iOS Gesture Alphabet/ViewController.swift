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
    weak var morsebox:  UITextField!
    
    /*
    // Accelerometer
    //@IBOutlet weak var xAccel: UITextField!
    //@IBOutlet weak var yAccel: UITextField!
    //@IBOutlet weak var zAccel: UITextField!
    
    
    
    // Gyroscope
    @IBOutlet weak var xGyro: UITextField!
    @IBOutlet weak var yGyro: UITextField!
    @IBOutlet weak var zGyro: UITextField!
    
    */
    
    // Accelerometer Motion Output
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
    var gestureCapture: [GestureCapture] = []
    var accelCapture: [AccelCapture] = []
    
    // data (gesture capture) storing
    var captureddata = ""
    
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

        // Here is where we'll need to include some sort of storage functionality
        
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
            
                self.xMotion.text = "x: \(Double(x))"
                self.yMotion.text = "y: \(Double(y))"
                self.zMotion.text = "z: \(Double(z))"
            
                self.accelCapture.append(AccelCapture(xAccel: x.rounded(toPlaces: 9), yAccel: y.rounded(toPlaces: 9), zAccel: z.rounded(toPlaces: 9)))
                
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
                    self.presenter.text = "bottom left"
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 1)
                {
                    self.presenter.text = "left"
                }
                else if (self.horizontalMotion == 0 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top left"
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
                    self.presenter.text = "bottom right"
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 1)
                {
                    self.presenter.text = "right"
                }
                else if (self.horizontalMotion == 2 && self.verticalMotion == 2)
                {
                    self.presenter.text = "top right"
                }
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
