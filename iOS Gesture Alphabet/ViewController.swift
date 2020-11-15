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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
                
                if (-0.5 < mRoll && 0.5 > mRoll)
                {
                    self.reset = 0
                }
                
                if (self.reset == 0 && -0.5 > mRoll)
                {
                    self.presenter.text = "short"
                    self.reset = 1
                }
                else if (self.reset == 0 && 0.5 < mRoll)
                {
                    self.presenter.text = "long"
                    self.reset = 1
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
