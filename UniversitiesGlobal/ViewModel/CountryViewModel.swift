//
//  CountryViewModel.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation
struct CountryViewModel {
   
    let title : String
    let select: () -> Void
    init(_ item: Country, selection: @escaping () -> Void) {
        self.title = item.country
        select = selection
    }
}
