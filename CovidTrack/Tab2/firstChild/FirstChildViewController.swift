//
//  FirstViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/30.
//


//MARK: - collectionView 製作標題
// 添加Header :
//0. 在cocoTouch 添加 UICollectionReusableView 做label
//1. collectionView註冊forSupplementaryViewOfKind
//2. 在UICollectionViewCompositionalLayout 裏的Section加入boundarySupplementaryItems
//3.使用 delegate 的 viewForSupplementaryElementOfKind 傳送header的資料


import UIKit

class FirstChildViewController: UIViewController {
    
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
        setLayout(section:section)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        addlongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.frame = view.bounds
        collection.delegate = self
        collection.dataSource = self
        collection.register(FirstChildCell.self, forCellWithReuseIdentifier: FirstChildCell.identifier)
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
    }
    
    
    //CollectionView 添加手勢
    private func addlongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collection.isUserInteractionEnabled = true
        collection.addGestureRecognizer(gesture)
    }
    
    @objc private func didLongPress(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else{return}
        let touchPoint = gesture.location(in: collection)
        guard let index = collection.indexPathForItem(at: touchPoint) else {return}
        
        let alert = UIAlertController(title: "LongPressed", message: "\(index)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Noticed", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    static func setLayout(section:Int) -> NSCollectionLayoutSection{
        switch section {
        case 0 :
            let header = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection.init(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = header
            return section
        case 1 :
            let header = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 2)
            let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(200)), subitem: group, count: 1)
            let section = NSCollectionLayoutSection.init(group: group2)
            section.orthogonalScrollingBehavior = .groupPaging
            
            section.boundarySupplementaryItems = header
            return section
            
        default:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection.init(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let header = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            section.boundarySupplementaryItems = header
            return section
        }

    }

}

extension FirstChildViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstChildCell.identifier, for: indexPath) as! FirstChildCell
        cell.nameLabel.text = "123fdlkdlfklsdfklsdfF"
//        cell.backgroundColor = .orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section{
        case 0 :
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
            header.configure(titleName: "Title Here")
            return header
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
            header.configure(titleName: "2222")
            return header
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
            header.configure(titleName: "Default")
            return header

        }

    }
    
    
}
