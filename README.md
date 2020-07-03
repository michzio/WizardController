# WizardController
Framework for building Wizards in iOS app 

1. Place WizardController side by side with AppProject and add this to Podfile of AppProject

```
pod 'WizardController', :path => '../WizardController'
```

2. Here is sample SignupWizardController 

```
import UIKit
import TheMinteKit
import WizardController

struct SignupWizardModel {
    
    static let pages : [(identifier: String, storyboard: String)] = {
        return [
            ("Step 1", "SignupWizardScreens"),
            ("Step 2", "SignupWizardScreens")
        ]
    }()
    
    static let finalPage : (identifier: String, storyboard: String) = ("Completion", "SignupWizardScreens")
    
    static let stepNameToPageIndexMap : [StepName:Int] = {
       return [
        .Step1 : 1,
        .Step2 : FINAL_PAGE_INDEX
        ]
    }()
    
    static let FINAL_PAGE_INDEX = -1000
    
    enum StepName : String {
        case Step1 = "Step1"
        case Step2 = "Step2"
    }
}

class SignupWizardController : UIWizardController {
    
    // MARK : MODEL
    override var pages : [(identifier: String, storyboard: String)] {
        get {
            if super.pages.count == 0 {
                super.pages = SignupWizardModel.pages
            }
            return super.pages
        }
        set {
            super.pages = newValue
        }
    }
    override var finalPage: (identifier: String, storyboard: String)? {
        get {
            if super.finalPage == nil {
                super.finalPage = SignupWizardModel.finalPage
            }
            return super.finalPage
        }
        set {
            super.finalPage = newValue
        }
    }
    
   // MARK: - WIZARD CONTROLLER DELEGATE
    override func willStepBackward(from startPage: Int, to endPage: Int) -> Bool {
        if endPage == 0 &&
            pages[endPage] == SignupWizardModel.pages[0] {
             return false
        }
        return true
    }
    
    override func backButtonTouched() -> Void {
       
        if currentPage == 0 {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else if  pages[currentPage] == SignupWizardModel.pages[1] {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            super.backButtonTouched()
        }
    }
    
    override func willRestartWizard(at page: Int) -> Bool {
        
        guard let finalPage = self.finalPage else { return false }
        
        if finalPage == SignupWizardModel.finalPage {
            // if Signup Wizard Model then restart using appropriate Schedule Wizard Model
            guard ScheduleWizardModel.pages.count > page else { return false }
            self.pages = ScheduleWizardModel.pages
            self.finalPage = ScheduleWizardModel.finalPage
        } else {
            // if some of Schedule Wizard Models then restart using Signup Wizard Model
            guard SignupWizardModel.pages.count > page else { return false }
            self.pages = SignupWizardModel.pages
            self.finalPage = SignupWizardModel.finalPage
        }
        
        if let headerView = headerView as? WizardHeaderView {
            headerView.configure(WizardHeaderViewModel(currentPage: page + 1, numberOfPages: self.pages.count))
        }
        
        return true
    }
}

extension SignupWizardController {
    
    static func requestInitialPackageLastStepUpdate(_ lastStep: SignupWizardModel.StepName) {
    
        WizardService().updateInitialPackageLastStep(lastStep.rawValue) {
            success in
            
            print("Initial Package Last Step (\(lastStep.rawValue)) update ststus: \(success)")
        }
    }
}
```
