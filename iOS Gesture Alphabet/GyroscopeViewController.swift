//
//  ViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Kira Jiroux on 10/19/20.
//

import UIKit
import CoreMotion

class GyroscopeViewController: UIViewController {

    @IBOutlet weak var presenter: UITextField!

    
    // Gyroscope
    @IBOutlet weak var xGyro: UITextField!
    @IBOutlet weak var yGyro: UITextField!
    @IBOutlet weak var zGyro: UITextField!

    
    
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

        motion.gyroUpdateInterval = 0.5

        
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
        
        
    }
    
}
