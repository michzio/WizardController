//
//  UIWizardPageViewController.swift
//  WizardController
//
//  Created by Michal Ziobro on 23/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import UIKit

open class UIWizardPageViewController: UIViewController, UIWizardPageNavigable, UIWizardPageValidable {
    
    open var pageState: UIWizardPageState = .Unknown

    // MARK: - MODEL
    private var _wizardController : UIWizardController?
    public var wizardController : UIWizardController? {
        get {
            return _wizardController
        }
        set {
            _wizardController = newValue
        }
    }

    // MARK: - WIZARD PAGE NAVIGATION
    public func stepToPreviousPage() {
        // delegate navigation handling to master wizard controller
        wizardController?.stepToPreviousPage()
    }
    
    public func stepToNextPage() {
        // delegate navigation handling to master wizard controller
        wizardController?.stepToNextPage()
    }
    
    // MARK: - LIFECYCLE HOOKS
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
