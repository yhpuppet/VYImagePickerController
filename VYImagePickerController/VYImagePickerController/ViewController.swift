//
//  ViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/23.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    @objc
    func presentUserAllPhotosViewController(_ sender: UIButton) {
        let userAlbumListViewController = UserAlbumListViewController()
        let pickerController = VYImagePickerController(rootViewController: userAlbumListViewController)
//        let allPhotosGridVC = UserAllPhotosGridViewController()
//        pickerController.pushViewController(allPhotosGridVC, animated: true)
        userAlbumListViewController.inspectUserAllPhotos()
        present(pickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let addImageButton = UIButton(type: .custom)
        addImageButton.setTitle("添加", for: .normal)
        addImageButton.setTitleColor(.blue, for: .normal)
        addImageButton.addTarget(self,
                                 action: #selector(self.presentUserAllPhotosViewController(_:)),
                                 for: .touchUpInside)
        view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }

}
