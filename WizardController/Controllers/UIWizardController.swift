//
//  WizardController.swift
//  WizardController
//
//  Created by Michal Ziobro on 20/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import UIKit

open class UIWizardController: UIViewController, UIWizardControllerDelegate, UIWizardControllerDataSource {
    
    // MARK: - WIZARD CROSS-PAGE DATA
    public var data = [String : Any]()
    
    // MARK: - DELEGATION
    public weak var delegate : UIWizardControllerDelegate!
    public weak var dataSource : UIWizardControllerDataSource!
    
    // MARK: - MODEL
    public private(set) var currentPage = 0
    public private(set) var currentViewController : UIViewController? = nil
    
    // MARK: - NAVIGATION BAR
    public lazy var navigationBar : UINavigationBar = {
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = navigationBackBarButton
        
        let bar = UINavigationBar(frame: CGRect.zero)
        bar.delegate = self
        bar.items = [navigationItem]
        return bar
    }()
    
    public lazy var navigationBackBarButton : UIBarButtonItem = {
        
        let backBarButtonIcon = self.delegate?.navigationBackBarButtonIcon
        let backBarButton = UIBarButtonItem(image: backBarButtonIcon, style: .plain, target: self, action: #selector(self.backBarButtonTouched(_:)))
        backBarButton.imageInsets = UIEdgeInsets(top: 0.0, left: -7.0, bottom: 0.0, right: 0.0)
        return backBarButton
        
    }()

    // MARK: - CONTAINER VIEWS
    private let headerContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }()
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    private let footerContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    // MARK: - DIM VIEW
    public lazy var dimView : UIView = {
        let dimView = UIView()
        dimView.backgroundColor = .black
        dimView.alpha = 0.667
        dimView.isHidden = true
        return dimView
    }()
    
    // MARK: - LAYOUT CONSTRAINTS
    // for navigation bar
    private lazy var navigationBarLeadingConstraint : NSLayoutConstraint = {
        let constraint = navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        return constraint
    }()
    private lazy var navigationBarTrailingConstraint : NSLayoutConstraint = {
        let constraint = navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        return constraint
    }()
    private lazy var navigationBarTopConstraint : NSLayoutConstraint = {
        if #available(iOS 11.0, *) {
            let constraint = navigationBar.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 0)
            return constraint
        } else {
            let constraint = navigationBar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0)
            return constraint
        }
    }()
    // for containr view
    private lazy var containerViewLeadingConstraint : NSLayoutConstraint = {
        let constraint = containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        return constraint
    }()
    private lazy var containerViewTrailingConstraint : NSLayoutConstraint = {
       let constraint = containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        return constraint
        
    }()
    private lazy var containerViewTopConstraint : NSLayoutConstraint = {
        let constraint = containerView.topAnchor.constraint(equalTo: self.headerContainerView.bottomAnchor, constant: 0)
        return constraint
    }()
    private lazy var containerViewBottomConstraint : NSLayoutConstraint = {
        let constraint = containerView.bottomAnchor.constraint(equalTo: self.footerContainerView.topAnchor, constant: 0)
        return constraint
    }()
    // for header view
    private lazy var headerContainerViewLeadingConstraint : NSLayoutConstraint = {
        let constraint = headerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        return constraint
    }()
    private lazy var headerContainerViewTrailingConstraint : NSLayoutConstraint = {
        let constraint = headerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        return constraint
    }()
    private lazy var headerContainerViewTopConstraint : NSLayoutConstraint = {
        let constraint = headerContainerView.topAnchor.constraint(equalTo: delegate.hasNavigationBar ? navigationBar.bottomAnchor : self.view.topAnchor, constant: 0)
        return constraint
    }()
    private lazy var headerContainerViewHeightConstraint : NSLayoutConstraint = {
        let constraint = headerContainerView.heightAnchor.constraint(equalToConstant: CGFloat(delegate.headerHeight))
        return constraint
    }()
    // for footer view
    private lazy var footerContainerViewLeadingConstraint : NSLayoutConstraint = {
        let constraint = footerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        return constraint
    }()
    private lazy var footerContainerViewTrailingConstraint : NSLayoutConstraint = {
        let constraint = footerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        return constraint
    }()
    private lazy var footerContainerViewBottomConstraint : NSLayoutConstraint = {
        let constraint = footerContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        return constraint
    }()
    private lazy var footerContainerViewHeightConstraint : NSLayoutConstraint = {
        let constraint = footerContainerView.heightAnchor.constraint(equalToConstant: CGFloat(delegate.footerHeight))
        return constraint
    }()
    
    // for dim view
    private lazy var dimViewTopConstraint : NSLayoutConstraint = {
        let constraint = dimView.topAnchor.constraint(equalTo: delegate.hasNavigationBar ? navigationBar.bottomAnchor : self.view.topAnchor, constant: 0)
        return constraint
    }()
    private lazy var dimViewBottomConstraint : NSLayoutConstraint = {
        let constraint = dimView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        return constraint
    }()
    private lazy var dimViewTrailingConstraint : NSLayoutConstraint = {
        let constraint = dimView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        return constraint
    }()
    private lazy var dimViewLeadingConstraint : NSLayoutConstraint = {
        let constraint = dimView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        return constraint
    }()
    // MARK: - LIFECYCLE HOOKS
    override open func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self 
        layoutContainerViews()
        startWizard()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         //navigationBarTopConstraint.constant =
         //   (traitCollection.verticalSizeClass == .compact) ? 0.0 : 20.0
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.headerContainerViewHeightConstraint.constant > 0 {
            self.headerContainerViewHeightConstraint.constant = CGFloat(delegate?.headerHeight ?? 0.0)
        }
        if self.footerContainerViewHeightConstraint.constant > 0 {
            self.footerContainerViewHeightConstraint.constant = CGFloat(delegate?.footerHeight ?? 0.0)
        }
    }
    
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
//        if newCollection.verticalSizeClass == .compact {
//            navigationBarTopConstraint.constant = 0.0
//        } else {
//            navigationBarTopConstraint.constant = 20.0
//        }
    }

    private func layoutContainerViews() -> Void {
        
        self.view.addSubview(containerView)
        self.view.addSubview(headerContainerView)
        self.view.addSubview(footerContainerView)
        self.view.addSubview(dimView)
        if delegate.hasNavigationBar { self.view.addSubview(navigationBar) }
        
        // add container view's layout constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerViewLeadingConstraint,
            containerViewTrailingConstraint,
            containerViewTopConstraint,
            containerViewBottomConstraint
        ])
        
        // add header view's layout constraints
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerContainerViewLeadingConstraint,
            headerContainerViewTrailingConstraint,
            headerContainerViewTopConstraint,
            headerContainerViewHeightConstraint
        ])
        
        // add footer view's layout constraints
        footerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerContainerViewLeadingConstraint,
            footerContainerViewTrailingConstraint,
            footerContainerViewBottomConstraint,
            footerContainerViewHeightConstraint
        ])
        
        // add dim view's layout constraints
        dimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimViewLeadingConstraint,
            dimViewTrailingConstraint,
            dimViewBottomConstraint,
            dimViewTopConstraint
        ])
        
        // add navigation bar's layout constraints
        if delegate.hasNavigationBar {
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                navigationBarLeadingConstraint,
                navigationBarTrailingConstraint,
                navigationBarTopConstraint
            ])
        }
        
        if let headerView = delegate.headerView {
            headerContainerView.addSubview(headerView)
            headerView.resizeToEdges(of: headerContainerView)
        } else {
            headerContainerViewHeightConstraint.constant = 0.0
        }
        if let footerView = delegate.footerView {
            footerContainerView.addSubview(footerView)
            footerView.resizeToEdges(of: footerContainerView)
        } else {
            footerContainerViewHeightConstraint.constant = 0.0
        }
    }
    
    // MARK: - WIZARD CONTROLLER - NAVIGATION LOGIC
    private func startWizard() {
        currentPage -= 1
        stepToNextPage()
        
        // add swipe recognizers
        self.view.addGestureRecognizer(forwardSwipeRecognizer)
        self.view.addGestureRecognizer(backwardSwipeRecognizer)
    }
    
    internal func stepToPreviousPage() {
        
        guard currentPage > 0 else { return }
        if let page = currentViewController as? UIWizardPageNavigable {
            guard page.willStepBackward() == true else { return }
        }
        guard delegate?.willStepBackward(from: currentPage, to: currentPage-1) == true else { return }
        
        // step backward
        currentPage -= 1
        var previousViewController = dataSource.wizardController(self, viewControllerForPage: currentPage)
        previousViewController.wizardController = self
        
        // replace view controller in container view
        ViewEmbedder.transition(from: self.currentViewController, to: previousViewController as UIViewController, in: self, containerView: self.containerView, with: .SlideLeftToRight)
        { success in
            if let page = self.currentViewController as? UIWizardPageNavigable {
                page.didStepBackward()
            }
            self.currentViewController = previousViewController as? UIViewController
            self.navigationBar.topItem?.title = self.currentViewController?.title
            self.delegate?.didStepBackward(from: self.currentPage+1, to: self.currentPage)
        }
    }
    
    internal func stepToNextPage() {
        let numberOfPages = dataSource.numberOfPages(in: self)
        guard currentPage + 1 < numberOfPages else {
            stepToFinalPage()
            return
        }
        if let page = currentViewController as? UIWizardPageNavigable {
            guard page.willStepForward() == true else { return }
        }
        guard delegate?.willStepForward(from: currentPage, to: currentPage+1) == true else { return }
        
        // step foreward
        currentPage += 1
        var nextViewController = dataSource.wizardController(self, viewControllerForPage: currentPage)
        nextViewController.wizardController = self
        
        // replace view controller in container view
        ViewEmbedder.transition(from: self.currentViewController, to: nextViewController as UIViewController, in: self, containerView: self.containerView, with: .SlideRightToLeft)
        { success in
            if let page = self.currentViewController as? UIWizardPageNavigable {
                page.didStepForward()
            }
            self.currentViewController = nextViewController as? UIViewController
            self.navigationBar.topItem?.title = self.currentViewController?.title
            self.delegate?.didStepForward(from: self.currentPage-1, to: self.currentPage)
        }
    }
    
    internal func stepToFinalPage() {
        
        if let page = currentViewController as? UIWizardPageNavigable {
            guard page.willStepToFinalPage() == true else { return }
        }
        
        // remove swipe recognizers
        self.view.removeGestureRecognizer(forwardSwipeRecognizer)
        self.view.removeGestureRecognizer(backwardSwipeRecognizer)
        
        // final page
        if var finalPage = self.dataSource.viewControllerForFinalPage(of: self),
            let finalPageVC = finalPage as? UIViewController {
            // hide header and footer views
            if delegate.headerView != nil {
                self.headerContainerView.subviews.first?.removeFromSuperview()
            }
            self.headerContainerViewHeightConstraint.constant = 0.0
            if delegate.footerView != nil {
                self.footerContainerView.subviews.first?.removeFromSuperview()
            }
            self.footerContainerViewHeightConstraint.constant = 0.0
            // update navigation bar
            self.navigationBar.topItem?.leftBarButtonItem = nil
            self.navigationBar.topItem?.title = finalPageVC.title
            
            ViewEmbedder.transition(from: currentViewController, to: finalPageVC, in: self, containerView: self.containerView, with: .SlideBottomToTop, completion: { success in
                if let page = self.currentViewController as? UIWizardPageNavigable {
                    page.didStepToFinalPage()
                }
                finalPage.wizardController = self
                self.currentViewController = finalPageVC
            })
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    internal func completeWizard() {
        
        guard delegate?.willCompleteWizard() == true else { return }
        
        self.presentingViewController?.dismiss(animated: true) { [weak self] in
             self?.delegate?.didCompleteWizard()
        }
    }
    
    internal func restartWizard(at page: Int = 0, with animation: TransitionAnimation = .SlideRightToLeft) {
        
        guard delegate?.willRestartWizard(at: page) == true else { return }
        
        // show header and/or footer views
        if let headerView = delegate.headerView {
            self.headerContainerViewHeightConstraint.constant = CGFloat(self.delegate?.headerHeight ?? 0)
            headerContainerView.addSubview(headerView)
            headerView.resizeToEdges(of: headerContainerView)
            
        } else {
            headerContainerViewHeightConstraint.constant = 0.0
        }
        if let footerView = delegate.footerView {
            self.footerContainerViewHeightConstraint.constant = CGFloat(self.delegate?.footerHeight ?? 0)
            footerContainerView.addSubview(footerView)
            footerView.resizeToEdges(of: footerContainerView)
        } else {
            footerContainerViewHeightConstraint.constant = 0.0
        }
        
        // update navigation bar
        self.navigationBar.topItem?.leftBarButtonItem = self.navigationBackBarButton
        
        // transition to first page of wizard
        var firstViewController = dataSource.wizardController(self, viewControllerForPage: page)
        firstViewController.wizardController = self
        
        ViewEmbedder.transition(from: self.currentViewController, to: firstViewController as UIViewController, in: self, containerView: self.containerView, with: animation, completion: { success in
            self.currentViewController = firstViewController as? UIViewController
            self.currentPage = page
            self.navigationBar.topItem?.title = self.currentViewController?.title
            
            self.delegate?.didRestartWizard(at: page)
        })
        
        // add swipe recognizers
        self.view.addGestureRecognizer(forwardSwipeRecognizer)
        self.view.addGestureRecognizer(backwardSwipeRecognizer)
    }
    
    // MARK: - WIZARD CONTROLLER - GESTURE NAVIGATION
    
    private lazy var forwardSwipeRecognizer : UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.forwardSwipeRecognized(_:)))
        recognizer.direction = .left
        return recognizer
    }()
    
    private lazy var backwardSwipeRecognizer : UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.backwardSwipeRecognized(_:)))
        recognizer.direction = .right
        return recognizer
    }()
    
    // MARK: - NAVIGATION BAR - TARGET ACTIONS
    @objc private func forwardSwipeRecognized(_ recognizer: UIGestureRecognizer) {
       forwardSwipe()
    }
    
    @objc private func backwardSwipeRecognized(_ recognizer: UIGestureRecognizer) {
        backwardSwipe()
    }
    
    @objc private func backBarButtonTouched(_ sender: UIBarButtonItem) {
        backButtonTouched()
    }
    
    // MARK: - DATA SOURCE - stubs
    open func numberOfPages(in: UIWizardController) -> Int {
        return 0
    }
    
    open func wizardController(_ controller: UIWizardController, viewControllerForPage index: Int) -> UIWizardPageNavigable {
    
        return UIWizardPageViewController()
    }
    
    open func viewControllerForFinalPage(of controller: UIWizardController) -> UIWizardCompletable? {
        
        return nil
    }
    
    // MARK: - DELEGATE - stubs
    open var hasNavigationBar : Bool {
        return true
    }
    open var navigationBackBarButtonIcon: UIImage {
        let bundle = Bundle(for: UIWizardController.self)
        let image = UIImage(named: "BackBarButtonIcon", in: bundle, compatibleWith: nil)!
        return image
    }
    
    open var headerHeight : Float {
        // if UIDevice.current.orientation.isLandscape {
        if traitCollection.verticalSizeClass == .compact {
            return 50.0
        } else {
            return 100.0
        }
    }
    open var footerHeight : Float {
        //if UIDevice.current.orientation.isLandscape {
        if traitCollection.verticalSizeClass == .compact {
            return 50.0
        } else {
            return 100.0
        }
    }
    
    open var headerView : UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    open var footerView : UIView? {
        return nil
    }
    
    open func willStepForward(from startPage: Int, to endPage: Int) -> Bool {
        return true
    }
    open func didStepForward(from startPage: Int, to endPage: Int) -> Void {
        
    }
    
    open func willStepBackward(from startPage: Int, to endPage: Int) -> Bool {
        return true
    }
    open func didStepBackward(from startPage: Int, to endPage: Int) -> Void {
        
    }
    
    open func willCompleteWizard() -> Bool {
        return true
    }
    open func didCompleteWizard() -> Void {
        
    }
    
    open func willRestartWizard(at page: Int) -> Bool {
        return true
    }
    open func didRestartWizard(at page: Int) -> Void {
        
    }
    
    open func backButtonTouched() -> Void {
        
        if currentPage == 0 {
            if let page = currentViewController as? UIWizardPageNavigable {
                guard page.willStepBackward() == true else { return }
            }
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else if currentPage > 0 {
            self.stepToPreviousPage()
        }
    }
    
    open func backwardSwipe() -> Void {
        stepToPreviousPage()
    }
    
    open func forwardSwipe() -> Void {
        let currentPageState = delegate?.wizardController(self, stateForPage: currentPage)
        if currentPageState == .Completed {
            stepToNextPage()
        }
    }
    
    open func wizardController(_ controller: UIWizardController, stateForPage index: Int) -> UIWizardPageState {
        
        let wizardPage = (index == currentPage) ? currentViewController : dataSource.wizardController(self, viewControllerForPage: index) as? UIViewController
        if let wizardPage = wizardPage as? UIWizardPageValidable {
                return wizardPage.pageState
        }
        return .Unknown
    }
}

// MARK: - NAVIGATION BAR DELEGATE
extension UIWizardController : UINavigationBarDelegate {
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - GO TO PAGE
extension UIWizardController {
    
    public func go(to page: Int) -> Bool {
        
        guard page > -1 else { return false }
        guard page < dataSource.numberOfPages(in: self) else { return false }
        
        //*** old animated
        //currentPage = page-1
        //stepToNextPage()
        //*** old animated
        startPage(page: page)
        return true
    }
    
    private func startPage(page: Int) {
        let numberOfPages = dataSource.numberOfPages(in: self)
        guard page < numberOfPages else {
            stepToFinalPage()
            return
        }
        
        // step to page
        let oldPage = currentPage
        let direction = (page - oldPage) // (+) -> forward, (-) -> backward
        currentPage = page
        var nextViewController = dataSource.wizardController(self, viewControllerForPage: currentPage)
        nextViewController.wizardController = self
        
        // replace view controller in container view
        ViewEmbedder.embed(parent: self, container: containerView, child: nextViewController as UIViewController, previous: self.currentViewController)
      
        
        if let pageController = self.currentViewController as? UIWizardPageNavigable {
            if direction > 0 { pageController.didStepForward() }
            if direction < 0 { pageController.didStepBackward() }
        }
        self.currentViewController = nextViewController as? UIViewController
        self.navigationBar.topItem?.title = self.currentViewController?.title
        self.delegate?.didStepForward(from: oldPage, to: self.currentPage)
    }
    
    public func go(to page: Int, animation: TransitionAnimation) -> Bool {
        guard page > -1 else { return false }
        guard page < dataSource.numberOfPages(in: self) else { return false }
        
        let numberOfPages = dataSource.numberOfPages(in: self)
        guard page < numberOfPages else {
            stepToFinalPage()
            return false
        }
        
        // step to page
        let oldPage = currentPage
        let direction = (page - oldPage) // (+) -> forward, (-) -> backward
        currentPage = page
        var nextViewController = dataSource.wizardController(self, viewControllerForPage: currentPage)
        nextViewController.wizardController = self
        
        // replace view controller in container view animated
        ViewEmbedder.transition(from: self.currentViewController, to: nextViewController as UIViewController, in: self, containerView: self.containerView, with: animation)
        { success in
            if let pageController = self.currentViewController as? UIWizardPageNavigable {
                if direction > 0 { pageController.didStepForward() }
                if direction < 0 { pageController.didStepBackward() }
            }
            self.currentViewController = nextViewController as? UIViewController
            self.navigationBar.topItem?.title = self.currentViewController?.title
            self.delegate?.didStepForward(from: oldPage, to: self.currentPage)
        }
        
        return true
    }
    
    public func goToFinalPage() {
        stepToFinalPage()
    }
    
    public func setInitialPage(_ page : Int) -> Bool  {
       
        guard page > -1 else { return false }
        if let numberOfPages = dataSource?.numberOfPages(in: self) {
            guard page < numberOfPages else { return false }
        }
        
        self.currentPage = page
        return true
    }
}
