//
//  FirstPresenter.swift
//  Random Photoes App
//
//  Created by Шамиль Моллачиев on 22.03.2022.
//

import Foundation
import UIKit

protocol FirstViewProtocol: AnyObject {
    func reloadCollectionView()
}

protocol FirstPresenterProtocol: AnyObject{
    init(view: FirstViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    func getImage(ind: Int, compl: @escaping ((UIImage) -> Void))
    var photoModels: [PhotoModel] {get set}
    func fetchPhotoModels()
    func pullTorefresh()
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
    //MARK: -  fetch Array of urls
    func fetchPhotoModels() {
        networkService?.fetchModels { [weak self] model in
            guard let model = model else { return }
            self?.photoModels = model
            self?.photoModelForRefresh = model
            self?.view?.reloadCollectionView()
        }
    }
    
    //MARK: - Fetch photos from urls
    func getImage(ind: Int, compl: @escaping ((UIImage) -> Void)) {
       
        guard let url = photoModels[ind].urls?.small else { return }
      
        if let cachedImage = imageCache.object(forKey: url as NSString){
            compl(cachedImage)
            print("image number \(ind) downloaded from cache")

        } else {
            networkService?.fetcImage(from: photoModels[ind]) { [weak self] image in
                guard let image = image else { return }
                compl(image)
                self?.imageCache.setObject(image, forKey: url as NSString)
                print("image number \(ind) has been cached")
            }
        }
    }
    
    //MARK: - pull to refresh
    func pullTorefresh() {
        photoModels = photoModelForRefresh
        view?.reloadCollectionView()
    }
}

