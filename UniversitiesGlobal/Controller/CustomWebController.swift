//
//  CustomWebController.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import UIKit
import SafariServices

class CustomWebController: SFSafariViewController {
    var element:CollegeElement?
    func setCustomNavigation() {
        if let title = element?.name {
            self.title = title
        }
        self.navigationController?.setNavigationBar()
        self.navigationController?.setCustomBack(imageName: "back", title: "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigation()
    }
    

}
