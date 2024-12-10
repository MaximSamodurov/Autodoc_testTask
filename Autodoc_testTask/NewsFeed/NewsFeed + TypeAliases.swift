//
//  NewsFeed + Types.swift
//  Autodoc_testTask
//
//  Created by Fixed on 04.12.24.
//

import UIKit

enum Section {
    case main
}

typealias NewsFeedDataSource = UICollectionViewDiffableDataSource<Section, NewsCellViewModel>
typealias NewsFeedSnapshot = NSDiffableDataSourceSnapshot<Section, NewsCellViewModel>
