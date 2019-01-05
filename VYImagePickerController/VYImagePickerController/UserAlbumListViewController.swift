//
//  UserAlbumListViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/4.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import Photos

class UserAlbumListViewController: UIViewController {
    
    private let albumTableView = UITableView(frame: .zero, style: .plain)
    
    private var albums = [Any]()
    
    // MARK: - Initialization
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func requestAuthorization() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .authorized {
            return
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
            }
            
        }
        
        
        if authStatus == .restricted {
            
        }
    }
    
    // MARK: - Set up subviews
    
    private func setUpSubviews() {
        albumTableView.dataSource = self;
        albumTableView.delegate = self;
        view.addSubview(albumTableView)
    }
    
    
    
    
    
}

extension UserAlbumListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
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
