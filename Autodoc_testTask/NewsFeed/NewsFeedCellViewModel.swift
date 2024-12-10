//
//  NewsFeedCellViewModel.swift
//  Autodoc_testTask
//
//  Created by Fixed on 08.12.24.
//

import Foundation
import UIKit

struct NewsCellViewModel {
    let id = UUID()
    let fullURL: String
    let title: String
    let image: UIImage
}

extension NewsCellViewModel: Hashable {
    static func == (lhs: NewsCellViewModel, rhs: NewsCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
