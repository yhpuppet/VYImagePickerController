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
                    self.present(alertController, animated: true) {
                        self.showNoAuthorizationPrompt()
                    }
                } else {
                    self.fetchPhotos()
                }
            }
        } else {
            showNoAuthorizationPrompt()
        }
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
        }
        switch Setion(rawValue: indexPath.section)! {
        case .allPhotos:
            cell!.textLabel?.text = "全部照片"
            if let photo = allPhotos?.firstObject {
                
            }
        default:
            cell!.textLabel?.text = "XXXXX"
        }
        
        return cell!
    }
    
}

extension UserAlbumListViewController: UITableViewDelegate {
    
}
