//
//  UniversitiesList.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation

// MARK: - CollegeListElement
struct CollegeElement: Codable {
    let domains: [String]
    let alphaTwoCode: String
    let country: String
    let webPages: [String]
    let name: String
    let stateProvince: String?

    enum CodingKeys: String, CodingKey {
        case domains
        case alphaTwoCode = "alpha_two_code"
        case country
        case webPages = "web_pages"
        case name
        case stateProvince = "state-province"
    }
}


typealias CollegeList = [CollegeElement]
