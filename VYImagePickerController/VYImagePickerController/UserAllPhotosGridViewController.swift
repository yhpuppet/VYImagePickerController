//
//  UserAllPhotosGridViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/23.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class UserAllPhotosGridViewController: UIViewController {
    private var photoGridCollectionView: UICollectionView?
    private var flowLayout: UICollectionViewFlowLayout?
    
    private var fetchResult: PHFetchResult<PHAsset>!
    
    private let imageManager = PHCachingImageManager()
    
    private var thumbnailSize: CGSize!
    
    private var availableWidth: CGFloat = 0
    
    private let columnCount = 3
    private let gridCollectionViewEdgeMargin: CGFloat = 20.0
    private let gridCollectionViewInteritemSpacing: CGFloat = 5.0
    
    private var isFirstShow = true
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Request authorization
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .authorized {
            fetchPhotos()
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    self.fetchPhotos()
                } else {
                    
                }
            }
        } else {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let flowLayout = flowLayout {
            let scale = UIScreen.main.scale
            let itemSize = flowLayout.itemSize
            thumbnailSize = CGSize(width: scale * itemSize.width, height: scale * itemSize.height)
        }
        
        if isFirstShow {
            if let collectionView = photoGridCollectionView {
                let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.size.height)
                collectionView.contentOffset = bottomOffset
            }
            isFirstShow = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if flowLayout != nil {
            let width = view.bounds.inset(by: view.safeAreaInsets).width
            if availableWidth != width {
                availableWidth = width
                let totalLength = availableWidth - (gridCollectionViewInteritemSpacing + gridCollectionViewEdgeMargin) * 2.0
                let itemLength = totalLength / CGFloat(columnCount)
                flowLayout!.itemSize = CGSize(width: itemLength, height: itemLength)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        setUpSubviews()
    }

    
    private func setUpSubviews() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout!.minimumLineSpacing = gridCollectionViewInteritemSpacing
        flowLayout!.minimumInteritemSpacing = gridCollectionViewInteritemSpacing
        
        photoGridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout!)
        photoGridCollectionView!.backgroundColor = .white
        photoGridCollectionView!.register(GridViewCell.self, forCellWithReuseIdentifier: "GridViewCell")
        photoGridCollectionView!.dataSource = self
        photoGridCollectionView!.delegate = self
        view.addSubview(photoGridCollectionView!)
        photoGridCollectionView!.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-gridCollectionViewEdgeMargin)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(gridCollectionViewEdgeMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    

}

extension UserAllPhotosGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as? GridViewCell else { fatalError("Unexpected cell in collection view")}
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset,
                                  targetSize: thumbnailSize,
                                  contentMode: .aspectFill,
                                  options: nil) { (image, _) in
                                    // UIKit may have recycled this cell by the handler's activation time.
                                    // Set the cell's thumbnail image only if it's still showing the same asset.
                                    if cell.representedAssetIdentifier == asset.localIdentifier {
                                        cell.thumbnailImage = image
                                    }
        }
        
        
        
        return cell
    }
    
}

extension UserAllPhotosGridViewController: UICollectionViewDelegate {
    
}

class GridViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    var representedAssetIdentifier: String!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func prepareForReuse() {
        imageView.image = nil
        
        representedAssetIdentifier = ""
    }
    
    // MARK: - Set up subviews
    
    private func setUpSubviews() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


