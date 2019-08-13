//
//  ViewEmbedder.swift
//  HamburgerMenu
//
//  Created by Michal Ziobro on 09/04/2018.
//  Copyright © 2018 Click5Interactive. All rights reserved.
//

import UIKit

public enum TransitionAnimation {
    case SlideLeftToRight, SlideRightToLeft, SlideTopToBottom, SlideBottomToTop
}

class ViewEmbedder {
    
    class func transition(from previousVC: UIViewController?,
                          to nextVC: UIViewController,
                          in parentVC: UIViewController,
                          containerView: UIView,
                          with animation : TransitionAnimation = .SlideRightToLeft,
                          completion: ((Bool) -> Void)? ) {
        // helper variables
        let w = containerView.frame.size.width
        let h = containerView.frame.size.height
        
        nextVC.willMove(toParentViewController: parentVC)
        parentVC.addChildViewController(nextVC)
        containerView.addSubview(nextVC.view)
        
        switch animation {
        case .SlideRightToLeft:
            nextVC.view.frame = CGRect(x: w, y: 0, width: w, height: h)
            break
        case .SlideLeftToRight:
            nextVC.view.frame = CGRect(x: -w, y: 0, width: w, height: h)
            break
        case .SlideTopToBottom:
            nextVC.view.frame = CGRect(x: 0, y: -h, width: w, height: h)
            break
        case .SlideBottomToTop:
            nextVC.view.frame = CGRect(x: 0, y: h, width: w, height: h)
            break
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            
            switch animation {
            case .SlideRightToLeft:
                nextVC.view.frame.origin.x = 0
                previousVC?.view.frame.origin.x = -w
            case .SlideLeftToRight:
                nextVC.view.frame.origin.x = 0
                previousVC?.view.frame.origin.x = w
            case .SlideTopToBottom:
                nextVC.view.frame.origin.y = 0
                previousVC?.view.frame.origin.y = h
            case .SlideBottomToTop:
                nextVC.view.frame.origin.y = 0
                previousVC?.view.frame.origin.y = -h
            }
            
        }, completion: { (success) in
            nextVC.didMove(toParentViewController: parentVC)
            if let previousVC = previousVC {
                previousVC.willMove(toParentViewController: nil)
                previousVC.view.removeFromSuperview()
                previousVC.removeFromParentViewController()
            }
            completion?(success)
        })

    }
    
    class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParentViewController: parent)
        parent.addChildViewController(child)
        container.addSubview(child.view)
        child.didMove(toParentViewController: parent)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil) {
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: nil
        )
        completion?(vc)
    }
    
    class func embed(withIdentifier id:String, parent: UIViewController, container: UIView, previous: UIViewController, completion:((UIViewController)->Void)? = nil) {
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: previous
        )
        completion?(vc)
    }
}

