//
//  EditImageViewController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/23.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit
import Photos

class EditImageViewController: UIViewController {
    private var asset: PHAsset!
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    // MARK: - Initialization
    
    init(asset: PHAsset) {
        super.init(nibName: nil, bundle: nil)
        self.asset = asset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }


}
