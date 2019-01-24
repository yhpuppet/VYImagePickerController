//
//  VYImagePickerController.swift
//  VYImagePickerController
//
//  Created by Vincent Yang on 2019/1/24.
//  Copyright © 2019 Vincent Yang. All rights reserved.
//

import UIKit

class VYImagePickerController: UINavigationController {
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
