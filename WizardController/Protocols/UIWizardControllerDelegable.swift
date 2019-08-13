//
//  UIWizardControllerDelegable.swift
//  WizardController
//
//  Created by Michal Ziobro on 23/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import Foundation

public protocol UIWizardControllerDelegable where Self : UIViewController {
    var wizardController : UIWizardController? { get set }
}

struct UIWizardPageNavigableAssociatedKeys {
    static var UIWizardController : UInt8 = 0
}

extension UIWizardControllerDelegable {
    
    public var wizardController : UIWizardController? {
        
        get {
            guard let controller = objc_getAssociatedObject(self, &UIWizardPageNavigableAssociatedKeys.UIWizardController) as? UIWizardController else {
                return nil
            }
            return controller
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &UIWizardPageNavigableAssociatedKeys.UIWizardController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
