//
//  OpeningViewController.swift
//  alimentum
//
//  Created by Nitish Dayal on 4/1/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController, PageViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initAppearance()
        
    }
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageViewController = segue.destinationViewController as? PageViewController {
            pageViewController.viewDelegate = self
        }
    }
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }

}


