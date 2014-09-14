//
//  BrotherStatusViewController.swift
//  APO-DZ
//
//  Created by Ronald Martin on 11/9/14.
//  Copyright (c) 2014 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

import UIKit

class BrotherStatusViewController: UITableViewController {
    
    // MARK: properties

    /* Top header label used to display name & status or error */
    @IBOutlet var nameLabel: UILabel!
    
    /* Dictionary from Spreadsheet representing the user's data */
    var brotherData: [String: AnyObject]? {
        // Called when async request for Spreadsheet data returns 1+ result.
        didSet {
            // Show user name and status in header.
            let name   = (brotherData?["First_and_Last_Name"] as AnyObject?) as? String
            let status = (brotherData?["Status"] as AnyObject?) as? String
            nameLabel.text = "\(name!) - \(status!)"
            
            // Populate TableView rows with user's data.
            self.tableView.reloadData()
        }
    }
    
    // MARK: Controller callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        brotherData = nil
    }
    
    // MARK: data retrieval
    
    func retrieveName() -> (String, String) {
        let prefs = NSUserDefaults.standardUserDefaults()
        return (prefs.objectForKey("first_name") as String, prefs.objectForKey("last_name") as String)
    }
    
    func retrieveStatus() -> () {
        // Form the request for the user's Spreadsheet data.
        let (firstName, lastName) = retrieveName()
        let url = URLs.brotherScriptUrlWithFirstName(firstName, lastName: lastName)
        
        // GET data from sheet and deserialize the response, populating the table if successful.
        let requestManager = AFHTTPRequestOperationManager()
        requestManager.responseSerializer = AFJSONResponseSerializer()
        requestManager.GET(url,
            parameters:nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Async response: \(responseObject)")
                let records = (responseObject?["records"] as AnyObject?) as? [AnyObject]
                if records?.count > 0 {
                    // Refresh table using acquired status.
                    self.brotherData = records![0] as? [String: AnyObject]
                } else {
                    // Fail gracefully.
                    self.nameLabel.text = "No Spreadsheet data for \(firstName) \(lastName)"
                    self.nameLabel.backgroundColor = UIColor.redColor()
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("HTTPRequest Error: " + error.localizedDescription)
                self.nameLabel.text = "Unable to download Spreadsheet data."
                self.nameLabel.backgroundColor = UIColor.redColor()
            }
        )
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        
        if brotherData == nil {
            return 0
        } else {
            /* 0: Summary
             * 1: Service
             * 2: Fellowship
             * 3: Membership */
            return 4
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Default to zero rows when there is no data.
        if brotherData == nil {
            return 0
        }
        
        // Return the number of rows in the section.
        var numRows: Int
        switch section {
        case 0:
            // Total Completion; Service Completion; Fellowship Completion; Membership Completion
            numRows = 4
        case 1:
            // Hours; Mandatory; Publicity; Hosting
            numRows = 4
        case 2:
            // Points; Hosting
            numRows = 2
        case 3:
            // Points; Pledge Comp.; Bro Comp.
            numRows = 3
        default:
            numRows = 0
        }
        return numRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Summary"
        case 1:
            return "Service"
        case 2:
            return "Fellowship"
        case 3:
            return "Membership"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequirementCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var requirement: (String, String)?
        switch indexPath.section {
        case 0:
            requirement = summaryStatus(indexPath.row)
        case 1:
            requirement = serviceStatus(indexPath.row)
        case 2:
            requirement = fellowshipStatus(indexPath.row)
        case 3:
            requirement = membershipStatus(indexPath.row)
        default:
            println("BrotherStatus: invalid section")
        }
        
        let reqNameLabel  = cell.viewWithTag(1) as UILabel,
            reqValueLabel = cell.viewWithTag(2) as UILabel
        
        if let (reqName, reqValue) = requirement {
            reqNameLabel.text  = reqName
            reqValueLabel.text = reqValue
            refreshValueTextColor(reqValueLabel)
        }

        return cell
    }
    
    // MARK: status values for row indices
    
    func summaryStatus(row: Int) -> (String, String)? {
        var reqName: String?, reqValue: String?
        
        switch row {
        case 0:
            if let complete = (brotherData?["Complete"] as AnyObject?) as? Bool {
                reqName = "Everything"
                reqValue = completionLabelString(complete)!
            }
        case 1:
            if let complete = (brotherData?["Service"] as AnyObject?) as? Bool {
                reqName = "Service"
                reqValue = completionLabelString(complete)!
            }
        case 2:
            if let complete = (brotherData?["Fellowship"] as AnyObject?) as? Bool {
                reqName = "Fellowship"
                reqValue = completionLabelString(complete)!
            }
        case 3:
            if let complete = (brotherData?["Membership"] as AnyObject?) as? Bool {
                reqName = "Membership"
                reqValue = completionLabelString(complete)!
            }
        default:
            reqName  = nil
            reqValue = nil
        }
        
        if reqName != nil && reqValue != nil {
            return (reqName!, reqValue!)
        } else {
            return nil
        }
    }
    
    func serviceStatus(row: Int) -> (String, String)? {
        var reqName: String?, reqValue: String?
        
        switch row {
        case 0:
            let hours: AnyObject? = brotherData?["Service_Hours"],
            requiredHours: AnyObject? = brotherData?["Required_Service_Hours"]
            if hours != nil && requiredHours != nil {
                reqName = "Service Hours"
                reqValue = "\(hours!) of \(requiredHours!)"
            }
        case 1:
            if let complete = (brotherData?["Large_Group_Project"] as AnyObject?) as? Bool {
                reqName = "Large Group"
                reqValue = completionLabelString(complete)!
            }
        case 2:
            if let complete = (brotherData?["Publicity"] as AnyObject?) as? Bool {
                reqName = "Publicity"
                reqValue = completionLabelString(complete)!
            }
        case 3:
            if let complete = (brotherData?["Service_Hosting"] as AnyObject?) as? Bool {
                reqName = "Service Hosting"
                reqValue = completionLabelString(complete)!
            }
        default:
            reqName  = nil
            reqValue = nil
        }
        
        if reqName != nil && reqValue != nil {
            return (reqName!, reqValue!)
        } else {
            return nil
        }
    }
    
    func fellowshipStatus(row: Int) -> (String, String)? {
        var reqName: String?, reqValue: String?
        
        switch row {
        case 0:
            let points: AnyObject? = brotherData?["Fellowship_Points"],
                requiredPoints: AnyObject? = brotherData?["Required_Fellowship"]
            if points != nil && requiredPoints != nil {
                reqName = "Fellowship Points"
                reqValue = "\(points!) of \(requiredPoints!)"
            }
        case 1:
            if let complete = (brotherData?["Fellowship_Hosting"] as AnyObject?) as? Bool {
                reqName = "Fellowship Hosting"
                reqValue = completionLabelString(complete)!
            }
        default:
            reqName  = nil
            reqValue = nil
        }
        
        if reqName != nil && reqValue != nil {
            return (reqName!, reqValue!)
        } else {
            return nil
        }
    }
    
    func membershipStatus(row: Int) -> (String, String)? {
        var reqName: String?, reqValue: String?
        
        switch row {
        case 0:
            let hours: AnyObject? = brotherData?["Meetings_Attended_(Current_Month)"],
                requiredHours: AnyObject? = brotherData?["Required_Meetings_(Current_Month)"]
            if hours != nil && requiredHours != nil {
                reqName = "Meetings this Month"
                reqValue = "\(hours!) of \(requiredHours!)"
            }
        case 1:
            if let complete = (brotherData?["Brother_Comp"] as AnyObject?) as? Bool {
                reqName = "Brother Component"
                reqValue = completionLabelString(complete)!
            }
        case 2:
            if let complete = (brotherData?["Pledge_Comp"] as AnyObject?) as? Bool {
                reqName = "Pledge Component"
                reqValue = completionLabelString(complete)!
            }
        default:
            reqName  = nil
            reqValue = nil
        }
        
        if reqName != nil && reqValue != nil {
            return (reqName!, reqValue!)
        } else {
            return nil
        }
    }
    
    // MARK: formatting for values
    
    let reqCompleteText = "COMPLETE", reqIncompleteText = "INCOMPLETE"
    
    func completionLabelString(completionStatus: Bool?) -> String? {
        if let status = completionStatus {
            return status ? reqCompleteText : reqIncompleteText
        } else {
            return nil
        }
    }
    
    func refreshValueTextColor(label: UILabel?) -> () {
        if let value = label?.text {
            switch value {
            case reqCompleteText:
                label?.textColor = colorFromRgb(0, g: 153, b: 102)
            case reqIncompleteText:
                label?.textColor = UIColor.redColor()
            default:
                label?.textColor = colorFromRgb(0, g: 128, b: 255)
            }
        }
    }
    
    func colorFromRgb(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1.0)
    }
}
