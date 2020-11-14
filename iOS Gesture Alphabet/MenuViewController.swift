//
//  MenuViewController.swift
//  iOS Gesture Alphabet
//
//  Created by Youngjoo Lee on 11/06/20.
//

import UIKit

enum MenuType: Int {
    case home
    case alldata
    case morsecodeconverter
    /*
    case accellerometer
    case gyroscope
    case devicemotion
     */
 }

class MenuViewController: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
}
