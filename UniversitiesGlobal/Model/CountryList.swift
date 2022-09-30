//
//  CountryList.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation
// MARK: - CountryList
struct CountryList: Codable,Equatable {
    let status: String
    let statusCode: Int
    let version, access: String
    let data: [String: Country]

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version, access, data
    }
    static func == (lhs: CountryList, rhs: CountryList) -> Bool {
        return lhs.version == rhs.version
    }
    static func != (lhs: CountryList, rhs: CountryList) -> Bool {
        return lhs.version != rhs.version
    }
}

// MARK: - Datum
struct Country: Codable, Equatable {
    let country: String
    let region: String
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.country == rhs.country
    }
    static func != (lhs: Country, rhs: Country) -> Bool {
        return lhs.country != rhs.country
    }
}
