//
//  AccellerometerViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

class AccellerometerViewController: UIViewController {

    
    @IBOutlet weak var xAccel: UITextField!
    @IBOutlet weak var yAccel: UITextField!
    @IBOutlet weak var zAccel: UITextField!
    @IBOutlet weak var touchOutput: UITextField!
    
    var motion = CMMotionManager()
    var morseTimer = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myAccelerometer()
        self.touchOutput.text = "not-touch"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        morse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.makeLong()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if (morseTimer == 0)
        {
            self.touchOutput.text = "short"
        }
        else if (morseTimer == 1)
        {
            self.touchOutput.text = "long"
        }
        else
        {
            self.touchOutput.text = "ERROR DETECTING INPUT"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.touchOutput.text = ""
        }
    }
    
    
    // This function captures accelerometer data with the CoreMotionManager motion
    // and Updates the UI to display the most recent accelerometer data.
    func myAccelerometer()
    {
        motion.accelerometerUpdateInterval = 0.5
        
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
    }

    func makeLong()
    {
        morseTimer = 1
    }
    
    // This function detects long and short taps
    func morse()
    {
        morseTimer = 0
        self.touchOutput.text = ""
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
