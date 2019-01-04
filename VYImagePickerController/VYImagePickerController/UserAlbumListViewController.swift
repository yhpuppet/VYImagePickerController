//
//  UserAlbumListViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/4.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit

class UserAlbumListViewController: UIViewController {
    
    private let albumTableView = UITableView(frame: .zero, style: .plain)
    
    private var albums = [Any]()
    
    // MARK: - Initialization
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
