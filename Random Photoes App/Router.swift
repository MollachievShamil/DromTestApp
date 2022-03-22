//
//  Router.swift
//  Random Photoes App
//
//  Created by Шамиль Моллачиев on 22.03.2022.
//

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? {get set}
    var assemblyBuilder: AssemblyBuilderProtocol? {get set}
}

protocol RouterProtocol: RouterMain {
    func firstVC()
 
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func firstVC() {
        if let navigationController = navigationController {
            guard let firstVC = assemblyBuilder?.createFirst(router: self) else {return}
            navigationController.viewControllers = [firstVC]
        }
    }

   
}
