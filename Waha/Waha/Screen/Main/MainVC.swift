//
//  ViewController.swift
//  Waha
//
//  Created by TaeHyeong Kim on 2020/09/11.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        
        let projectCellNib = UINib(nibName: "ProjectCollectionCell", bundle: nil)
        self.collectionView.register(projectCellNib, forCellWithReuseIdentifier: "ProjectCollectionCell")
    }
    
    
}
extension MainVC : UICollectionViewDelegate, UICollectionViewDataSource{
    //Number of collectionView Item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    //Cell init
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCollectionCell", for: indexPath) as? ProjectCollectionCell {
            
            
            return cell
            
        }
        return UICollectionViewCell()
    }
    //clicklistener
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProjectCollectionCell {
            print("\(indexPath.row)was clicked")
        }
    }
}
extension MainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowItemCount : CGFloat = 5
        let spaceBetweenCell : CGFloat = 5
        let spacing : CGFloat = 5
        let totalSpacing = (2 * spacing) + ((rowItemCount - 1) * spaceBetweenCell)
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/rowItemCount - 8
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 100, height: 100)
        }
    }
}