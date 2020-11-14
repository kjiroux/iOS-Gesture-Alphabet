//
//  HomeViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Youngjoo Lee on 11/06/20.
//

import UIKit

class HomeViewController: UIViewController {

    let transiton = SlideInTransition()
    var topView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }

    func transitionToNew(_ menuType: MenuType) {
        //let title = String(describing: menuType).capitalized
        //self.title = title

        topView?.removeFromSuperview()
        switch menuType {
        case .alldata:
            let vcName = self.storyboard?.instantiateViewController(identifier: "ViewController")
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
            // or we could put all stuffs from accelerometerviewcontroller.swift to show in one page
            // or segue
        
        case .morsecodeconverter:
            let vcName = self.storyboard?.instantiateViewController(identifier: "MorseCodeConverter")
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
            // or we could put all stuffs from accelerometerviewcontroller.swift to show in one page
            // or segue
        /*
        case .accellerometer:
            let vcName = self.storyboard?.instantiateViewController(identifier: "AccellerometerViewController")
            
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
            // or we could put all stuffs from accelerometerviewcontroller.swift to show in one page
            // or segue

        case .gyroscope:
            let vcName = self.storyboard?.instantiateViewController(identifier: "GyroscopeViewController")
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
            // or we could put all stuffs from accelerometerviewcontroller.swift to show in one page
            // or segue

        case .devicemotion:
            let vcName = self.storyboard?.instantiateViewController(identifier: "DevicemotionViewController")
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
            // or we could put all stuffs from accelerometerviewcontroller.swift to show in one page
            // or segue
        */
        default:
            break
        }
    }

}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

