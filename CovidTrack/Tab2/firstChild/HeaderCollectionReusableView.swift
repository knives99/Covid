//
//  HeaderCollectionReusableView.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/30.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
        
    let label : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        backgroundColor = .label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(titleName:String){
        label.text = titleName
    }
}
