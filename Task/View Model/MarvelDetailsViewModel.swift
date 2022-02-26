//
//  MarvelDetailsViewModel.swift
//  Task
//
//  Created by Rama Krishna on 23/02/22.
//

import Foundation

protocol GetMarvelDetailsApiProtocol {
    
    func getMarvelDetailRequestApiSuccessfuly(results : MarvelDetails)
    func getMarvelDetailRequestApiFailure(results : [String : AnyObject])
    func getMarvelDetailRequestConncetionFail(message : String)
    func getMarvelDetailRequestSessionExpire(message : String)
}

class MarvelDetailsViewModel : NSObject, URLSessionDelegate, URLSessionDataDelegate {
    var delegate : GetMarvelDetailsApiProtocol?
    var dataList : MarvelDetails?

    func getMarvelListViewModel(id: String) {
        guard let url = URL(string: detailUrl + "&i=" + id) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            guard let data = data else { return }
                    do {
                        let decodedFood = try JSONDecoder().decode(MarvelDetails.self, from: data)
                        self.dataList = decodedFood
                        self.delegate?.getMarvelDetailRequestApiSuccessfuly(results: self.dataList!)
                        print("Completion handler decodedFood", decodedFood)
             } catch {
                     print("Error decoding", error)
             }
        }

        dataTask.resume()
    }
}
