//
//  SocialSearchResultsDelegate.swift
//  ios
//
//  Created by System Administrator on 11/5/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import Parse

protocol SocialSearchResultsDelegate{
    func followButtonTapped(userToFollow:PFUser, cell:ResultsViewCell)
    func unfollowButtonTapped(userToUnfollow:PFUser, followActivity:PFObject, cell:ResultsViewCell)
}