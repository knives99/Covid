//
//  FirstChildCell.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/30.
//

import UIKit

class FirstChildCell: UICollectionViewCell {
    
    static let identifier = "FirstChildCell"
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondaryLabel
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
//        nameLabel.frame = contentView.bounds
//        nameLabel.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
}
