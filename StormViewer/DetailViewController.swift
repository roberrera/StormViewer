//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Robert M. Errera on 8/31/16.
//  Copyright © 2016 Robert M. Errera. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let imageView = self.detailImageView {
                imageView.image = UIImage(named: detail)
            }
        }
    }
    
    func shareTapped() {
        let actionSheet = UIAlertController(title: "", message: "Share this storm", preferredStyle: .ActionSheet)
        
        let actionTweet = shareToTwitter()
        let actionFacebook = shareToFacebook()
        let actionShareSheet = shareSheet()
        
        actionSheet.addAction(actionTweet)
        actionSheet.addAction(actionFacebook)
        actionSheet.addAction(actionShareSheet)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func shareSheet() -> UIAlertAction {
        return UIAlertAction(title: "More options", style: .Default, handler: { (action) -> Void in
            let vc = UIActivityViewController(activityItems: [self.detailImageView.image!], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    func shareToFacebook() -> UIAlertAction {
        return UIAlertAction(title: "Share on Facebook", style: .Default, handler: { (action) -> Void in
            // Check if service is available
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbVC.addImage(self.detailImageView.image!)
                fbVC.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
                self.presentViewController(fbVC, animated: true, completion: nil)
            } else {
                self.showAlertDialog("You must be logged in to Facebook")
            }
        })
    }
    
    func shareToTwitter() -> UIAlertAction {
        return UIAlertAction(title: "Tweet this", style: .Default, handler: { (action) -> Void in
            // Check if service is available
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterVC.addImage(self.detailImageView.image!)
                twitterVC.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
                self.presentViewController(twitterVC, animated: true, completion: nil)
            } else {
                self.showAlertDialog("You must be logged in to Twitter")
            }
        })
    }
    
    func showAlertDialog(message: String, var alertTitle: String? = nil, var alertStyle: UIAlertActionStyle? = nil, alertActionHandler: ((UIAlertAction) -> Void )? = nil) {
        let alertController = UIAlertController(title: "Share", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if alertTitle == nil {
            alertTitle = "Okay"
        }
        
        if alertStyle == nil {
            alertStyle = UIAlertActionStyle.Default
        }
        
        alertController.addAction(UIAlertAction(title: alertTitle!, style: alertStyle!, handler: alertActionHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}

