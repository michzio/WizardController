//
//  UIWizardControllerDelegate.swift
//  WizardController
//
//  Created by Michal Ziobro on 20/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import Foundation

public protocol UIWizardControllerDelegate : class {
    
    var hasNavigationBar : Bool { get }
    var navigationBackBarButtonIcon : UIImage { get }
    
    var headerHeight : Float { get }
    var footerHeight : Float { get }
    
    var headerView : UIView? { get }
    var footerView : UIView? { get }
    
    func willStepForward(from startPage: Int, to endPage: Int) -> Bool
    func didStepForward(from startPage: Int, to endPage: Int) -> Void
    
    func willStepBackward(from startPage: Int, to endPage: Int) -> Bool
    func didStepBackward(from startPage: Int, to endPage: Int) -> Void
    
    func backButtonTouched() -> Void
    func backwardSwipe() -> Void
    func forwardSwipe() -> Void
    
    func willCompleteWizard() -> Bool
    func didCompleteWizard() -> Void
    
    func willRestartWizard(at page: Int) -> Bool
    func didRestartWizard(at page: Int) -> Void
    
    func wizardController(_ controller: UIWizardController, stateForPage index: Int) -> UIWizardPageState
}
