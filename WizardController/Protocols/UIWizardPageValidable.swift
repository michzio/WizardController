//
//  UIWizardPageValidable.swift
//  WizardController
//
//  Created by Michal Ziobro on 24/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//
import Foundation

public protocol UIWizardPageValidable {
    
    var pageState : UIWizardPageState { get set }
    var isPageCompleted : Bool { get }
    var isPageDraft : Bool { get }
}

extension UIWizardPageValidable {
    
    public var isPageCompleted : Bool {
        return pageState == .Completed
    }
    public var isPageDraft : Bool {
        return pageState == .Draft
    }
}
