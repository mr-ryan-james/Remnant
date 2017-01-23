//
//  AlertsViewController.swift
//  ios
//
//  Created by System Administrator on 10/17/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomNavbarDelegate {

    @IBOutlet weak var alertsTableView: UITableView!
    @IBOutlet weak var customNavbar: NavbarView!
    
    
    var alerts:[PFObject] = []
    var selectedRemnant:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SpinnerUtility.initializeSpinnerInViewDidLoad(self.view)
        
        customNavbar.customNavbarDelegate = self
        customNavbar.titleLabel.text = "Alerts"
        customNavbar.leftButton.hidden = false
        customNavbar.leftButton.setTitle("Back", forState: UIControlState.Normal)
        
        alertsTableView.hidden = true
        alertsTableView.delegate = self
        alertsTableView.dataSource = self
        alertsTableView!.tableFooterView = UIView(frame: CGRectZero)
        
        alertsTableView.rowHeight = UITableViewAutomaticDimension
        alertsTableView.estimatedRowHeight = 160.0
        
        loadAlerts()
        
        if UIApplication.sharedApplication().applicationIconBadgeNumber != 0 {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            let currentInstallation = PFInstallation.currentInstallation()
            
            currentInstallation.badge = 0;
            PFInstallation.currentInstallation().saveEventually({ (success:Bool, error: NSError?) -> Void in
                
            })
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
    }
    
    func loadAlerts(){
        SpinnerUtility.startAnimatingForView(self.view)
        DataAccessLayer.getAlertsForUser().then { (alertsFromParse:[PFObject]?) -> Void in
            self.alerts = alertsFromParse!
            self.alertsTableView.reloadData()
            self.alertsTableView.hidden = false
        }.always { () -> Void in
                SpinnerUtility.stopAnimatingForView(self.view)
        }.error { (error:ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was an error loading the alerts. \(error)")
        }
    }
    
    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:AlertsTableCell?
        let index = indexPath.row
        let alert = alerts[index]

        
        let alertType = alert["type"] as! String
        let fromUser = alert["fromUser"] as! PFUser
        let fromUsername = fromUser.username
        let labelText:NSMutableAttributedString = NSMutableAttributedString()
        
        switch alertType {
        case "comment":
            labelText.appendAttributedString(getColoredText(fromUsername!, description: "commented on your remnant"))
            cell = tableView.dequeueReusableCellWithIdentifier("alertsImageCell") as? AlertsTableCell
            cell!.alert = alert
            //dispatch_async(dispatch_get_main_queue()) {
                self.requestImage(cell!)
            //}
            break;
        case "like":
            labelText.appendAttributedString(getColoredText(fromUsername!, description: "liked your remnant"))
            cell = tableView.dequeueReusableCellWithIdentifier("alertsImageCell") as? AlertsTableCell
            cell!.alert = alert
            //dispatch_async(dispatch_get_main_queue()) {
                self.requestImage(cell!)
            //}
            break;
        case "follow":
            labelText.appendAttributedString(getColoredText(fromUsername!, description: "started following you"))
            cell = tableView.dequeueReusableCellWithIdentifier("alertsCell") as? AlertsTableCell
            break;
        default:
            print("this shouldn't happen")
        }
        
        
        
        cell!.label!.attributedText = labelText
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let alert = alerts[index]
        let alertType = alert["type"] as! String
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if(alertType == "follow"){
            return
        }

        selectedRemnant = alert["remnant"].objectId!
        performSegueWithIdentifier("remnantViewSegue", sender: self)
    }
    
    func requestImage(cell:AlertsTableCell){
        //let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let thumbnail = (cell.alert!["remnant"]["thumbnail"] as? PFFile)
        
        if(thumbnail != nil){
            NSURLConnection.GET(thumbnail!.url!).then({ (data:NSData) -> Void in
                cell.alertImage!.image = UIImage(data: data)
            })
        }
        
    }
    
    func getColoredText(username: String, description: String?, color:UIColor = UIColor.blueColor()) -> NSMutableAttributedString {
        let string:NSMutableAttributedString = NSMutableAttributedString(string: username)
        
        let range:NSRange = (string.string as NSString).rangeOfString(username)
        string.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        if(description != nil){
            string.appendAttributedString(NSAttributedString(string: " " + description!))
        }
        
        return string
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if alerts.count > 0 {
            
            self.alertsTableView!.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.alertsTableView!.bounds.size.width, self.alertsTableView!.bounds.size.height))
            noDataLabel.text = "No alerts found"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.alertsTableView!.backgroundView = noDataLabel
            
        }
        return numOfSection
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "remnantViewSegue"){
            let destinationVC = segue.destinationViewController as! RemnantViewController
            destinationVC.remnantId = selectedRemnant
        }
    }


}

class AlertsTableCell : UITableViewCell{
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var alertImage: UIImageView?
    
    var alert:PFObject?
}
