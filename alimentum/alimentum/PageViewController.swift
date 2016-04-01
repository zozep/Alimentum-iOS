//
//  PageViewController.swift
//  alimentum
//
//  Created by Nitish Dayal on 4/1/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate: class {
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int)
    func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int)
    
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    weak var viewDelegate : PageViewControllerDelegate?
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("page1"),
                self.newViewController("page2"),
                self.newViewController("page3")]
    }()
    
    func newViewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "FirstTime", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        print("Woo?")
//        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
//        if launchedBefore  {
//            print("Not first launch.")
//            let mainAppStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainVC = mainAppStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
//            dispatch_async(dispatch_get_main_queue(), {
//                self.presentViewController(mainVC, animated: true, completion: nil)
//            })
//        } else {
//            print("First launch, setting NSUserDefault.")
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        
        viewDelegate?.pageViewController(self, didUpdatePageCount: orderedViewControllers.count)
            }
        initAppearance()
        
    }
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.indexOf(firstViewController) {
                viewDelegate?.pageViewController(self, didUpdatePageIndex: index)
            }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

}
