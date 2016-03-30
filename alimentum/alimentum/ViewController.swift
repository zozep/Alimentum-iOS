//
//  ViewController.swift
//  alimentum
//
//  Created by Joseph Park on 3/30/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, LastPageViewControllerDelegate {
    
    var pageViewController = UIPageViewController()
    let pages = ["PageOneViewController", "PageTwoViewController", "PageThreeViewController"]
    
    
    //MARK: - =============LastPageViewControllerDelegate Methods
    func lastPageDone() {
        print("View Controller says Last Page done")
        //...
    }
    
    
    
    //MARK: - ==============PAGE VIEW CONTROLLER DATASOURCE
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController
        //current page returns UIViewController optional
        viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.indexOf(viewController.restorationIdentifier!) {
            if index > 0 {
                return viewControllerAtIndex(index - 1)
            }
        }
        return nil
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.indexOf(viewController.restorationIdentifier!) {
            if index < pages.count - 1 {
                return viewControllerAtIndex(index + 1)
            }
        }
        return nil
    }
    
    
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewControllerWithIdentifier(pages[index])
        
        if pages[index] == "PageThreeViewController" {
            (vc as! LastPageViewController).delegate = self
        }
        
        return vc
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") {
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            //set initial default
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .Forward, animated: true, completion: nil)
            pageViewController.didMoveToParentViewController(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
