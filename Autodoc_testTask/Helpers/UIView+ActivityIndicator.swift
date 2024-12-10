//
//  ActivityIndicator.swift
//  Autodoc_testTask
//
//  Created by Fixed on 07.12.24.
//

import Foundation
import UIKit

extension UIView {

    private static let activityIndicatorTag = 999999
    
    func activityStartAnimating() {
        if let existingIndicator = self.viewWithTag(UIView.activityIndicatorTag) as? UIActivityIndicatorView {
            existingIndicator.startAnimating()
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.tag = UIView.activityIndicatorTag
        
        DispatchQueue.main.async {
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func activityStopAnimating() {
        DispatchQueue.main.async {
            if let activityIndicator = self.viewWithTag(UIView.activityIndicatorTag) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
