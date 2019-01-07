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
    
    private enum Setion: Int, CaseIterable {
        case allPhotos = 0
        case smartAlbums
        case userCollections
    }
    
    private var allPhotos: PHFetchResult<PHAsset>!
    private var smartAlbums: PHFetchResult<PHAssetCollection>!
    private var userCollections: PHFetchResult<PHCollection>!
    
    private let albumTableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Initialization
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // request authorization
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .authorized {
            fetchPhotos()
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus != .authorized {
                    let alertController = UIAlertController(title: "提示",
                                                            message: "您未授权使用照片",
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.fetchPhotos()
                }
            }
        } else {
            var message = ""
            let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alertController.addAction(okAction)
            if authStatus == .restricted {
                message = "您无法授权使用照片，可能是因为您处于家长控制模式下"
            } else if authStatus == .denied {
                message = "您已禁止访问您的照片"
                let navToSettingAction = UIAlertAction(title: "去设置", style: .default) { (action) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                              options: [:],
                                              completionHandler: { (success) in
                        if !success {
                            let failOpenSettingAlertController = UIAlertController(title: "打开失败",
                                                                                   message: "未能打开'设置'，请手动打开",
                                                                                   preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "好的", style: .default, handler: { (action) in
                                
                            })
                            failOpenSettingAlertController.addAction(okAction)
                            self.present(failOpenSettingAlertController, animated: true, completion: {
                                
                            })
                        }
                    })
                }
                alertController.addAction(navToSettingAction)
                return
            }
            present(alertController, animated: true)
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
    }
    
    // MARK: - Set up subviews
    
    private func setUpSubviews() {
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
            return allPhotos.count
        case .smartAlbums:
            return smartAlbums.count
        case .userCollections:
            return userCollections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ""
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
}

extension UserAlbumListViewController: UITableViewDelegate {
    
}
