//
//  UIViewController+Alert.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/18/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(title: String = "Warning", textString: String) {
        let alertController = UIAlertController(title: title, message: textString, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in

        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
