//
//  FirstVC.swift
//  Random Photoes App
//
//  Created by Шамиль Моллачиев on 22.03.2022.
//

import UIKit

class FirstVC: UIViewController {
    
    var presenter: FirstPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchPhotoModels()
        setDelegate()
        setConstraints()
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FirstVCCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshTapped), for: .allEvents)
        return collectionView
    }()
    
    @objc func refreshTapped() {
        presenter.pullTorefresh()
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - CollectionView Delegates
extension FirstVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstVCCell
        presenter.getImage(ind: indexPath.row, compl: { image in
            cell.imageView.image = image
        })
        return cell
    }
    
    //MARK: - Delete action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? FirstVCCell {
            UIView.animate(withDuration: 0.5) {
                cell.frame.origin.x = self.view.bounds.width
                cell.alpha = 0
            } completion: { [weak self] _ in
               self?.presenter.photoModels.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
               
            }
        }
    }
    
    //MARK: - Cell animation
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.4) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
    //MARK: -  Cells Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.size.width) - 20,
            height: (view.frame.size.width)
        )
    }
    
    //MARK: - Cell spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - Constraints
extension FirstVC {
    func setConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Extension for delegation
extension FirstVC: FirstViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

//MARK: -  CollectionView Extension

extension UICollectionViewFlowLayout {
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(
            scaleX: 0.95,
            y: 1
        )
      return attributes
    }
}
