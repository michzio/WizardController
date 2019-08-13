//
//  UIWizardCompletable.swift
//  WizardController
//
//  Created by Michal Ziobro on 23/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import Foundation

public protocol UIWizardCompletable : UIWizardControllerDelegable {
    
    func completeWizard() -> Void
    func restartWizard(at page: Int, with animation : TransitionAnimation) -> Void
}

extension UIWizardCompletable {
    
    public func completeWizard() -> Void {
        wizardController?.completeWizard()
    }
    
    public func restartWizard(at page: Int = 0, with animation : TransitionAnimation = .SlideRightToLeft) -> Void {
        wizardController?.restartWizard(at: page, with: animation)
    }
}
