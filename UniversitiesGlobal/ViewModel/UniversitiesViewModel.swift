//
//  UniversitiesViewModel.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation
struct UniversitiesViewModel {
   
    let title : String
    var url:String
    let select: () -> Void
    init(_ item: CollegeElement, selection: @escaping () -> Void) {
        self.title = item.name
        self.url = ""
        if let urlStr = item.webPages.first{
            self.url = urlStr
        }
        select = selection
    }
}
