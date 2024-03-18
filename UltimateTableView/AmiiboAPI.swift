//
//  AmiiboAPI.swift
//  UltimateTableView
//
//  Created by Зайнал Гереев on 01.04.2022.
//

import Foundation

final class AmiiboAPI {
    
    static let shared = AmiiboAPI()
    
    func fetchAmiiboList(onCompletion: @escaping ([Amiibo]?) -> ()) {
        let urlString = "https://www.amiiboapi.com/api/amiibo"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            guard let data = data else {
                onCompletion(nil)
            return
            }
            
            guard let amiiboList = try? JSONDecoder().decode(AmiiboList.self, from: data)
            else {
                onCompletion(nil)
                return
            }
            
            onCompletion(amiiboList.amiibo)
        }
        
        task.resume()
    }
    
}

struct AmiiboList: Codable {
    let amiibo: [Amiibo]
}

struct Amiibo: Codable {
    let amiiboSeries: String
    let character, gameSeries, head: String
    let image: String
    let name: String
    let release: AmiiboRelease
    let tail: String
    let type: String
}

struct AmiiboRelease: Codable {
    let au: String?
    let eu: String?
    let jp: String?
    let na: String?
}
