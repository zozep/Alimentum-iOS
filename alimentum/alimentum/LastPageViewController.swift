//
//  LastPageViewController.swift
//  alimentum
//
//  Created by Joseph Park on 3/30/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit

protocol LastPageViewControllerDelegate {
    func lastPageDone()
}

class LastPageViewController: UIViewController {
    
    var delegate: LastPageViewControllerDelegate?
    

    //MARK: - IBActions
    
    @IBAction func goButtonClicked(sender: UIButton) {
        //send view message to ViewController
        if delegate != nil {
            delegate?.lastPageDone()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
