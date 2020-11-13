//
//  ViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

class DevicemotionViewController: UIViewController {

    @IBOutlet weak var presenter: UITextField!
    
    // Device Motion
    @IBOutlet weak var xMotion: UITextField!
    @IBOutlet weak var yMotion: UITextField!
    @IBOutlet weak var zMotion: UITextField!
    
    
    var motion = CMMotionManager()
    
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
        motion.deviceMotionUpdateInterval = 0.5
        
        // Device Motion; Pitch, Roll, Yaw
        motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error)
            in
            print(data as Any)
            if let trueData = data {
                self.view.reloadInputViews()
                let mPitch = trueData.attitude.pitch
                let mRoll  = trueData.attitude.roll
                let mYaw   = trueData.attitude.yaw
                
                self.xMotion.text = "Pitch: \(Double(mPitch).rounded_motion(toPlaces: 3))"
                self.yMotion.text = "Roll: \(Double(mRoll).rounded_motion(toPlaces: 3))"
                self.zMotion.text = "Yaw: \(Double(mYaw).rounded_motion(toPlaces: 3))"
            
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
    func rounded_motion(toPlaces places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
