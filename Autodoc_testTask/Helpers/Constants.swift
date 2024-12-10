//
//  Constants.swift
//  Autodoc_testTask
//
//  Created by Fixed on 08.12.24.
//

import Foundation
import UIKit

struct Constants {
    static let baseURL = "https://webapi.autodoc.ru/api/news/"
    static let placeholderImageName = "noImage"
}

struct LayoutConstants {
    static let itemHeight: CGFloat = 300
    static let footerHeight: CGFloat = 50
    static let interGroupSpacing: CGFloat = 10
    static let groupInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    static let newsTitleBgColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    static let newsTitleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    static let imageViewCellHeightAnchor: CGFloat = 200
    static let imageViewCellTopAnchor: CGFloat = 5
    static let newsTitleCellHeightAnchor: CGFloat = 70
}
