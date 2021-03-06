//
//  UserAlbumListViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/4.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class UserAlbumListViewController: UIViewController {
    
    var isFirstShow = true
    
    private enum Setion: Int, CaseIterable {
        case allPhotos = 0
        case smartAlbums
        case userCollections
    }
    
    private var allPhotos: PHFetchResult<PHAsset>?
    private var smartAlbums: PHFetchResult<PHAssetCollection>?
    private var userCollections: PHFetchResult<PHCollection>?
    
    private var albumTableView: UITableView!
    
    private var noAuthorizationPromptLabel: UILabel!
    
    // MARK: - Initialization
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "照片"
        
        // request authorization
//        let authStatus = PHPhotoLibrary.authorizationStatus()
//        if authStatus == .authorized {
//            fetchPhotos()
//        } else if authStatus == .notDetermined {
//            PHPhotoLibrary.requestAuthorization { (authStatus) in
//                if authStatus != .authorized {
//                    let alertController = UIAlertController(title: "提示",
//                                                            message: "您未授权使用照片",
//                                                            preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true) {
//                        self.showNoAuthorizationPrompt()
//                    }
//                } else {
//                    self.fetchPhotos()
//                }
//            }
//        } else {
//            showNoAuthorizationPrompt()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func showNoAuthorizationPrompt() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        var prompt = ""
        if authStatus == .restricted {
            prompt = "无法访问您的照片，可能是因为您处于家长控制模式下"
        } else if authStatus == .denied {
            prompt = "您已禁止访问您的照片，请在“设置”-“隐私”中允许访问照片"
        }
        noAuthorizationPromptLabel = UILabel()
        noAuthorizationPromptLabel.numberOfLines = 0
        noAuthorizationPromptLabel.textAlignment = .center
        noAuthorizationPromptLabel.textColor = UIColor.darkGray
        noAuthorizationPromptLabel.text = prompt
        view.addSubview(noAuthorizationPromptLabel)
        noAuthorizationPromptLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        allPhotos = PHAsset.fetchAssets(with: fetchOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .albumRegular,
                                                              options: nil)
        userCollections = PHCollection.fetchTopLevelUserCollections(with: nil)
        
        addAlbumTableView()
        albumTableView.reloadData()
    }
    
    private func fetchUserAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return PHAsset.fetchAssets(with: fetchOptions)
    }
    
    func inspectUserAllPhotos() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .restricted:
            fallthrough
        case .denied:
            showNoAuthorizationPrompt()
        case .authorized:
            let vc = PhotoGridViewController(assets: fetchUserAllPhotos())
            navigationController?.pushViewController(vc, animated: true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    let vc = PhotoGridViewController(assets: self.fetchUserAllPhotos())
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showNoAuthorizationPrompt()
                }
            }
        }
    }
    
    // MARK: - Set up subviews
    
    private func addAlbumTableView() {
        albumTableView = UITableView(frame: .zero, style: .grouped)
        albumTableView.dataSource = self;
        albumTableView.delegate = self;
        albumTableView.rowHeight = UITableView.automaticDimension
        albumTableView.estimatedRowHeight = 45.0
        view.addSubview(albumTableView)
        albumTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension UserAlbumListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Setion.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Setion(rawValue: section)! {
        case .allPhotos:
            return 1
        case .smartAlbums:
            return smartAlbums != nil ? smartAlbums!.count : 0
        case .userCollections:
            return userCollections != nil ? userCollections!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "UserAlbumListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.accessoryType = .disclosureIndicator
        }
        switch Setion(rawValue: indexPath.section)! {
        case .allPhotos:
            cell!.textLabel?.text = "全部照片"
            if let photo = allPhotos?.lastObject {
                PHImageManager.default().requestImage(for: photo,
                                                      targetSize: CGSize(width: 30.0, height: 30.0),
                                                      contentMode: PHImageContentMode.aspectFit,
                                                      options: nil) { (result, info) in
                                                        if let image = result {
                                                            cell?.imageView?.image = image
                                                        }
                }
            }
        case .smartAlbums:
            let album = smartAlbums![indexPath.row]
            cell!.textLabel?.text = album.localizedTitle
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            if let date = album.startDate {
//                cell!.textLabel?.text = formatter.string(from: date)
//            }
        case .userCollections:
            let album = userCollections![indexPath.row]
            cell!.textLabel?.text = album.localizedTitle
        }
        
        return cell!
    }
    
}

extension UserAlbumListViewController: UITableViewDelegate {
    
}
