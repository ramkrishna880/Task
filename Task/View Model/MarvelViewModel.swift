//
//  MarvelViewModel.swift
//  Task
//
//  Created by Rama Krishna on 23/02/22.
//

import Foundation

protocol GetMarvelListApiProtocol {
    
    func getMarvelRequestApiSuccessfuly(results : MarvelList)
    func getMarvelyRequestApiFailure(results : [String : AnyObject])
    func getMarvelRequestConncetionFail(message : String)
    func getMarvelRequestSessionExpire(message : String)
}

class MarvelViewModel : NSObject, URLSessionDelegate, URLSessionDataDelegate {
    var delegate : GetMarvelListApiProtocol?
    var dataList : MarvelList?

    func getMarvelListViewModel() {
        guard let url = URL(string: listUrl) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            guard let data = data else { return }
                    do {
                        let decodedFood = try JSONDecoder().decode(MarvelList.self, from: data)
                        self.dataList = decodedFood
                        self.delegate?.getMarvelRequestApiSuccessfuly(results: self.dataList!)
                        print("Completion handler decodedFood", decodedFood)
             } catch {
                     print("Error decoding", error)
             }
        }

        dataTask.resume()
    }
}
