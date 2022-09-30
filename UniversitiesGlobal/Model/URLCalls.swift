//
//  URLCalls.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation
class CountrysAPI {
static var shared = CountrysAPI()
func getCountryList(completion: @escaping (Result<[Country], Error>) -> Void) {
    let url = URL(string: "https://api.first.org/data/v1/countries")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard let jsonData = data else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        do {
            let decoder = JSONDecoder()
            let countryList = try decoder.decode(CountryList.self, from: jsonData)
            let countriesDic = countryList.data
            var countriesArray:[Country] = countriesDic.values.map{ $0 }
            countriesArray.sort {
                $0.country < $1.country
            }
            completion(.success(countriesArray))
    
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
}
class UniversitiesApi {
    static var shared = UniversitiesApi()
    func getUniversities(country: String, completion: @escaping (Result<[CollegeElement], Error>) -> Void) {
        if  let url = URL(string: "http://universities.hipolabs.com/search?country=\(country)") {

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let jsonData = data else {
                completion(.failure(CustomError.invalidURL))
                return
            }
            do {
                let decoder = JSONDecoder()
                var countryList = try decoder.decode([CollegeElement].self, from: jsonData)
                countryList.sort {
                    $0.name < $1.name
                }
                completion(.success(countryList))
                
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        } else {
            completion(.failure(CustomError.invalidURL))
        }
    }
}
