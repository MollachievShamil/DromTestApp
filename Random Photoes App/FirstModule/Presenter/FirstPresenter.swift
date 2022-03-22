//
//  FirstPresenter.swift
//  Random Photoes App
//
//  Created by Шамиль Моллачиев on 22.03.2022.
//

import Foundation
import UIKit

protocol FirstViewProtocol: AnyObject {
    func reloadCollectionVieww()
}

protocol FirstPresenterProtocol: AnyObject{
    init(view: FirstViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    func fetchPhotoModels()
    var photoModels: [PhotoModel] {get set}
    func pullTorefresh()
    func getImage(ind: Int, compl: @escaping ((UIImage) -> Void))
}


class FirstPresenter: FirstPresenterProtocol {
    
    var imageCache = NSCache<NSString, UIImage>()
   
    weak var view: FirstViewProtocol?
    var networkService: NetworkServiceProtocol?
    let router: RouterProtocol?
    var photoModels: [PhotoModel] = []
    var photoModelForRefresh: [PhotoModel] = []
    
    required init(view: FirstViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    func fetchPhotoModels() {
        networkService?.fetchModels { [weak self] model in
            guard let model = model else { return }
            self?.photoModels = model
            self?.photoModelForRefresh = model
            self?.view?.reloadCollectionVieww()
        }
    }
    
    func getImage(ind: Int, compl: @escaping ((UIImage) -> Void)) {
       
        let url = photoModels[ind].urls?.small
        
        if let cachedImage = imageCache.object(forKey: url! as NSString){
            compl(cachedImage)
        } else {

        networkService?.fetcImage(from: photoModels[ind]) { [weak self] image in
            compl(image!)
            self?.imageCache.setObject(image!, forKey: url! as NSString)
            print("image number \(ind) has been cached")
        }
      }
    }
    
    func pullTorefresh() {
        photoModels = photoModelForRefresh
        view?.reloadCollectionVieww()
    }
}

