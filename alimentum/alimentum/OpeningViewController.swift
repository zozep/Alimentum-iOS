//
//  AppDelegate.swift
//  alimentum
//
//  Created by Nitish Dayal, Joseph Park
//  Copyright © 2016 Nitish Dayal, Joseph Park. All rights reserved.
//
//  Libraries used in project include: UIKit, CoreLocation, 0AuthSwift
//

import UIKit
import CoreLocation
import OAuthSwift

class OpeningViewController: UIViewController, IntroPageViewControllerDelegate {
    
    
//MARK: - Declare Variables
    
    /* View components */
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
//MARK: - Default UIViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On view load, call upon initAppearance method
//        initAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If passed in segue has destinationViewController of type PageViewController, declare self (OpeningViewController) as viewDelegate
        if let pageViewController = segue.destinationViewController as? IntroPageViewController {
            pageViewController.viewDelegate = self
        }
    }
    
    
//MARK: - Functions conforming OpeningViewController class to protocol IntroPageViewControllerDelegate
    
    func introPageViewController(pageViewController: IntroPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func introPageViewController(pageViewController: IntroPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }

    
//MARK: - Custom Functions

    func initAppearance() -> Void {
        //sets background color of current view
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "rest.png")!)
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
}

