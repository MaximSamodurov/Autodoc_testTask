//
//  NewsFeedCell.swift
//  Autodoc_testTask
//
//  Created by Fixed on 02.12.24.
//
import UIKit

class NewsFeedCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsFeedCell"
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textAlignment = .center
        label.font = LayoutConstants.newsTitleFont
        label.backgroundColor = LayoutConstants.newsTitleBgColor
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentAddSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func contentAddSubview() {
        [newsTitle, imageView]
            .forEach {
            contentView.addSubview($0)
        }

        let layout = [
            newsTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            newsTitle.heightAnchor.constraint(equalToConstant: LayoutConstants.newsTitleCellHeightAnchor),
            newsTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            newsTitle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: LayoutConstants.imageViewCellTopAnchor),
            imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageViewCellHeightAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(layout)
    }

    func configure(with viewModel: NewsCellViewModel) {
        newsTitle.text = viewModel.title
        imageView.image = viewModel.image
    }
}


