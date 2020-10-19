//
//  ViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    
    @IBOutlet weak var xAccel: UITextField!
    @IBOutlet weak var yAccel: UITextField!
    @IBOutlet weak var zAccel: UITextField!
    
    var motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myAccelerometer()
    }
    
    
    func myAccelerometer() {
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


}

extension Double {
    // Rounds the double to decimal place value
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
