//
//  DidableViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/29.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    
    let firstVc = FirstChildViewController()
    let secondVc = SecondChildViewController()
    
    let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }()
    let scrollVIew : UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollVIew)
        view.addSubview(indicatorView)
        setChildController()
        scrollVIew.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollVIew.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: view.frame.width , height: view.frame.height)
        self.indicatorView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top + 40, width: self.view.frame.width / 2, height: 10)
    }

    private func setChildController(){
        //Content Size !!!
        scrollVIew.contentSize = CGSize(width: view.frame.width * 2, height: scrollVIew.frame.height)
        addChild(firstVc)
        addChild(secondVc)
        scrollVIew.addSubview(firstVc.view)
        scrollVIew.addSubview(secondVc.view)
        firstVc.didMove(toParent: self)
        secondVc.didMove(toParent: self)
        firstVc.view.frame = CGRect(x: 0, y: 0, width: scrollVIew.frame.width, height: scrollVIew.frame.height)
        secondVc.view.frame = CGRect(x:  view.frame.origin.x + view.frame.width, y:0, width: scrollVIew.frame.width, height: view.frame.height)
    }
}

extension MainViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= scrollView.frame.width - 100{
            UIView.animate(withDuration: 0.2) {
                self.indicatorView.frame = CGRect(x: self.view.frame.width / 2, y: self.view.safeAreaInsets.top + 40, width: self.view.frame.width / 2, height: 10)
            }
        }else{
            UIView.animate(withDuration: 0.2) {
                self.indicatorView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top + 40, width: self.view.frame.width / 2, height: 10)
            }
        }
    }
    
}
