//
//  ViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

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
    
    // Variable for determining horizontal direction
    // Left is 0, middle is 1, right is 2
    // Perhaps using an enum would be better instead?
    var horizontalMotion = -1
    
    // Variable for determining vertical direction
    // Up is 0, middle is 1, down is 2
    // Perhaps using an enum would be better instead?
    var verticalMotion = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Fixes issue where dark mode causes text to be invisible. PLEASE INCLUDE ON EVERY PAGE
        overrideUserInterfaceStyle = .light
        getCoreMotionData()
    }

    // This function captures accelerometer data with the CoreMotionManager motion
    // and Updates the UI to display the most recent accelerometer data.
    func getCoreMotionData()
    {
        motion.accelerometerUpdateInterval = 0.5
        motion.gyroUpdateInterval = 0.5
        motion.deviceMotionUpdateInterval = 0.5
        
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
                
                // In the middle
                if (-0.5 < mRoll && 0.5 > mRoll && -0.5 < mPitch && 0.5 > mPitch)
                {
                    self.reset = 0
                    self.horizontalMotion = 1
                    self.verticalMotion = 1
                }
                
                // Left
                if (self.reset == 0 && -0.5 > mRoll)
                {
                    self.reset = 1
                    self.horizontalMotion = 0
                }
                // Right
                else if (self.reset == 0 && 0.5 < mRoll)
                {
                    self.reset = 1
                    self.horizontalMotion = 2
                }
            
                // Down
                if (self.reset == 0 && -0.5 > mPitch)
                {
                    self.reset = 1
                    self.verticalMotion = 0
                }
                // Up
                else if (self.reset == 0 && 0.5 < mPitch)
                {
                    self.reset = 1
                    self.verticalMotion = 2
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
