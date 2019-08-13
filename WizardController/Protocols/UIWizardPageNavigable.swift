//
//  UIWizardPageNavigable.swift
//  WizardController
//
//  Created by Michal Ziobro on 23/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import Foundation

public protocol UIWizardPageNavigable : UIWizardControllerDelegable {

    func stepToPreviousPage() -> Void
    func stepToNextPage() -> Void
    
    func shouldStepToPreviousPage() -> Bool
    func shouldStepToNextPage() -> Bool
    
    func willStepForward() -> Bool
    func didStepForward() -> Void
    
    func willStepBackward() -> Bool
    func didStepBackward() -> Void
    
    func willStepToFinalPage() -> Bool
    func didStepToFinalPage() -> Void
}

extension UIWizardPageNavigable {
    
    public func stepToPreviousPage() -> Void {
        guard shouldStepToPreviousPage() else { return }
        
        wizardController?.stepToPreviousPage()
    }
    
    public func stepToNextPage() -> Void {
        guard shouldStepToNextPage() else { return }
        
        wizardController?.stepToNextPage()
    }
    
    public func shouldStepToPreviousPage() -> Bool {
        return true
    }
    
    public func shouldStepToNextPage() -> Bool {
        return true
    }
    
    public func willStepForward() -> Bool {
        return true
    }
    
    public func didStepForward() -> Void {
        
    }
    
    public func willStepBackward() -> Bool {
        return true
    }
    
    public func didStepBackward() -> Void {
        
    }
    
    public func willStepToFinalPage() -> Bool {
        return true
    }
    
    public func didStepToFinalPage() -> Void {
        
    }
}
