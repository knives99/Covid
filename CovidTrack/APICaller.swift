//
//  APICaller.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/28.
//

import Foundation

struct APICaller{
    
    enum DataScope {
        case national
        case state([StateModel])
    }
    
    static let shared = APICaller()
    private init(){}
    
    private struct Constants{
       static let baseURL = "https://api.covidtracking.com/v1/"
    }
    
    public func getUSData(completion:@escaping(Result<[USData],Error>)->Void){
        
        let urlString = Constants.baseURL + "us/daily.json"
        
        guard let url = URL(string:urlString) else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode([USData].self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getStateData(state:String,completion:@escaping (Result<[StateModel],Error>)-> Void){
        let urlString = Constants.baseURL + "states/\(state.lowercased())/daily.json"
        
        guard let url = URL(string:urlString) else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode([StateData].self, from: data)
                let model: [StateModel] = result.compactMap { data in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMdd"
                    guard let newData = formatter.date(from: String(data.date)) else {return .init(date: String(data.date), state: data.state, death: data.death)}
                    formatter.dateFormat = "yyyy年MM月dd日"
                    let finalDate = formatter.string(from: newData)
                    return .init(date: finalDate, state: data.state, death: data.death)
                }
                completion(.success(model))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    public func getStateList(completion:@escaping((Result<[String],Error>) -> Void)){
        let urlString = Constants.baseURL + "states/info.json"
        
        guard let url = URL(string:urlString) else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode([AllState].self, from: data)
                let array = result.compactMap({$0.state})
                completion(.success(array))
                
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
        
        
        
    }
    
}

struct USData:Codable,Hashable{
    let date:Int
    let death:Int?
}

struct StateData:Codable{
    let date:Int
    let state:String
    let death :Int?
}

struct AllState:Codable{
    let state:String
}

struct StateModel:Codable{
    let date:String
    let state:String
    let death :Int?
}
