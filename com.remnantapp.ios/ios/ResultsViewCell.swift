//
//  ResultsViewCell.swift
//  ios
//
//  Created by System Administrator on 11/3/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse

class ResultsViewCell: UITableViewCell {
    
    var associatedUser:PFUser?
    var followActivity:PFObject?
    var socialSearchResultsDelegate = SocialSearchResultsDelegate?()
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        
        if(followActivity != nil){
            socialSearchResultsDelegate?.unfollowButtonTapped(associatedUser!, followActivity: followActivity!, cell: self)
            followActivity = nil
        }
        else{
            socialSearchResultsDelegate?.followButtonTapped(associatedUser!, cell: self)
        }

    }
    
    func loadFromPFObject(searchResult: NSDictionary){
        associatedUser = searchResult["user"] as? PFUser
        followActivity = searchResult["followActivity"] as? PFObject
        
        usernameLabel.text = associatedUser!["username"] as? String
        
        if(followActivity != nil){
            followButton.setTitle("unfollow", forState: UIControlState.Normal)
        }
        else{
            followButton.setTitle("follow", forState: UIControlState.Normal)
        }
        
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(){
        followButton.setBackgroundImage(UIImage(named: "greyButtonHighlight"), forState: UIControlState.Highlighted)
    }
}
