//
//  ViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/28.
//

import UIKit
import Charts

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    

    
    private var scope:APICaller.DataScope = .national
    
    var usDatas : [USData] = []{
        didSet{
            DispatchQueue.main.async {
                self.createGraph()
            }
        }
    }
//    var stateData = [StateModel]()
    let barChart : BarChartView = {
        return BarChartView()
    }()
    let tableView :UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
//MARK: -  searchController
    let searchController:UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "states"
        vc.searchBar.searchBarStyle = .default
        return vc
    }()
    
    private var serchTime : Timer?
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        serchTime?.invalidate()
        
        serchTime = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { time in
            print("\(time) | \(text)")
        })
    }
    
    //MARK: -  life cycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        view.addSubview(tableView)
        navigationItem.searchController = searchController
        tableView.delegate = self
        tableView.dataSource = self
        getUSdata()
        searchController.searchResultsUpdater = self
        
    }
    

    
    private func createGraph(){
        tableView.tableHeaderView = nil
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        var dataEntries = [BarChartDataEntry]()
        switch scope{
        case.national:
            let set = usDatas.prefix(20)
            for i in 0...set.count - 1  {
                let data = set[i]
                dataEntries.append(.init(x: Double(i), y: Double(data.death ?? 0)))
            }
        case.state(let models):
            let set = models.prefix(20)
            for i in 0...set.count - 1{
                let data = set[i]
                dataEntries.append(.init(x: Double(i), y: Double(data.death ?? 0)))
            }
        }

        let dataSet = BarChartDataSet(entries: dataEntries)
        dataSet.colors = ChartColorTemplates.material()
        let data = BarChartData(dataSet: dataSet)
        barChart.data = data
        barChart.animate(yAxisDuration: 3.0)
        tableView.addSubview(barChart)
        tableView.tableHeaderView = headView
        headView.clipsToBounds = true
        
    }
    
    private func setTitle(){
        let titleString :String = {
            switch scope{
            case.national :return "NATIONAL"
            case .state(let stateData): return stateData.first?.state ?? "00"
            }
        }()
        title = titleString
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: titleString, style: .done, target: self, action: #selector(didTapBtn))
    }
    
    private func getUSdata() {
        APICaller.shared.getUSData { [weak self]result in
            switch result {
            case.success(let usDatas):
                self?.usDatas = usDatas
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        barChart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        
    }
    
    @objc private func didTapBtn(){
       let vc = FilterViewController()
        
        //complention 資料回傳叫出API 注意completion寫法
        vc.completion = {[weak self] state in
            APICaller.shared.getStateData(state: state) { [weak self]result in
                switch result{
                case.success(let stateModel):
                    //實際上enum帶入參數的位置
                    self?.scope = .state(stateModel)
                    DispatchQueue.main.async {
                        self?.setTitle()
                        self?.createGraph()
                        self?.tableView.reloadData()
                    }
          
                case.failure(let error):
                    print(error)
                }
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch scope{
        case.national: return  usDatas.count
        case.state(let stateDatas): return stateDatas.count
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch scope {
        case.national:
            let model = usDatas[indexPath.row]
            guard let deathNumber = model.death else {return cell}
            cell.textLabel?.text = "\(model.date)美國死亡總人數\(deathNumber)"
            return cell
        case.state(let stateDatas):
            let model = stateDatas[indexPath.row]
            if let death = model.death{
                cell.textLabel?.text = "\(model.date)|\(model.state)州|\(death)"
            }
            return cell
        }
    }

}

