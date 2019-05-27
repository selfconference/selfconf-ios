//
//  UIView+MBProgressHud.swift
//  SelfConference
//
//  Created by Flavius on 5/26/19.
//  Copyright © 2019 Self Conference. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @objc(SC_showProgressHUDWithTitle:)
    func showProgressHud(withTitle title: String? = nil) {
        let progressHud = MBProgressHUD(view: self)
        progressHud.detailsLabel.text = title
        progressHud.show(animated: true)
        
        addSubview(progressHud)
    }
    
    @objc(SC_hideProgressHUD)
    func hideProgressHud() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}
