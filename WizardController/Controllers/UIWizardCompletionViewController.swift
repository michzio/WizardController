//
//  UIWizardCompletionViewController.swift
//  WizardController
//
//  Created by Michal Ziobro on 23/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import UIKit

class UIWizardCompletionViewController: UIViewController, UIWizardCompletable {

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
    
    // MARK: - WIZARD COMPLETABLE
    public func completeWizard() {
        // delegate completion handling to master wizard controller
        wizardController?.completeWizard()
    }
    
    public func restartWizard() {
        // delegate restart handling to master wizard controller
        wizardController?.restartWizard()
    }
    
    // MARK: - LIFECYCLE HOOKS
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
