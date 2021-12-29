//
//  FilterViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/28.
//

import UIKit

class FilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    public var completion:((String) -> Void)?

//    這寫法無法
//    var sta = [String]{
//        didSet{
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//        }
//    }()
    var states :[String] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }
    
    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        APICaller.shared.getStateList { [weak self]result in
            switch result{
            case.success(let states):
                self?.states = states
            case.failure(let error):
                print(error)
            }
        }

    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = states[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let state = states[indexPath.row]
        print(state)
        //completion 帶入參數的位置
        completion?(state)
        self.dismiss(animated: true, completion: nil)
        
    }

}
