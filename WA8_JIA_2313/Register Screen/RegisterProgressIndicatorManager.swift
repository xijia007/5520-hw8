//
//  RegisterProgressIndicatorManager.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//


import Foundation

extension RegisterViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}