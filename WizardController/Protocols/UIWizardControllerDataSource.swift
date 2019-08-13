//
//  UIWizardControllerDataSource.swift
//  WizardController
//
//  Created by Michal Ziobro on 20/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import Foundation

public protocol UIWizardControllerDataSource : class {
    
    func numberOfPages(in: UIWizardController) -> Int
    func wizardController(_ controller: UIWizardController, viewControllerForPage index: Int) -> UIWizardPageNavigable
    func viewControllerForFinalPage(of controller: UIWizardController) -> UIWizardCompletable?
}
