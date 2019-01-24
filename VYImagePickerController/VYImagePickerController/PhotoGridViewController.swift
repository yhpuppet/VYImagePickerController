//
//  PhotoGridViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/24.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import Photos

class PhotoGridViewController: UIViewController {
    private var assets: PHFetchResult<PHAsset>!
    private var shouldScrollToBottom = true
    
    private var photoGridCollectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    private let imageManager = PHCachingImageManager()
    
    private var thumbnailSize: CGSize!
    
    private var availableWidth: CGFloat = 0
    
    private let columnCount = 4
    private let gridCollectionViewEdgeMargin: CGFloat = 20.0
    private let gridCollectionViewInteritemSpacing: CGFloat = 5.0
    
    // MARK: - Initialization
    
    init(assets: PHFetchResult<PHAsset>, shouldScrollToBottom: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.assets = assets
        self.shouldScrollToBottom = shouldScrollToBottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scale = UIScreen.main.scale
        let itemSize = flowLayout.itemSize
        thumbnailSize = CGSize(width: scale * itemSize.width, height: scale * itemSize.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        if availableWidth != width {
            availableWidth = width
            let totalInterval = gridCollectionViewEdgeMargin * 2 + gridCollectionViewInteritemSpacing * CGFloat((columnCount - 1))
            let totalLength = (availableWidth - totalInterval).rounded(.down)
            let itemLength = (totalLength / CGFloat(columnCount)).rounded(.down)
            flowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldScrollToBottom && photoGridCollectionView.contentSize.height > 0 {
            if let collectionView = photoGridCollectionView {
                let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.size.height)
                collectionView.contentOffset = bottomOffset
            }
            shouldScrollToBottom = false
        }
    }
    
    // MARK: - Set up subviews
    
    private func setUpSubviews() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = gridCollectionViewInteritemSpacing
        flowLayout.minimumInteritemSpacing = gridCollectionViewInteritemSpacing
        
        photoGridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout!)
        photoGridCollectionView.backgroundColor = .white
        photoGridCollectionView.register(GridViewCell.self, forCellWithReuseIdentifier: "GridViewCell")
        photoGridCollectionView.dataSource = self
        photoGridCollectionView.delegate = self
        view.addSubview(photoGridCollectionView!)
        photoGridCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-gridCollectionViewEdgeMargin)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(gridCollectionViewEdgeMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let view1 = UIView()
        view.addSubview(view1)
        view1.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 1.0, height: 1.0))
        }
    }

}

extension PhotoGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = assets.object(at: indexPath.item)
        
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

extension PhotoGridViewController: UICollectionViewDelegate {
    
}
