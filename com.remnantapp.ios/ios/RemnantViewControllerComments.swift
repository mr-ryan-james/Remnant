//
//  RemnantViewControllerComments.swift
//  ios
//
//  Created by System Administrator on 11/18/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import Parse

extension RemnantViewController{
    
    
    func setupCommentsTable(){
        //self.commentsContainerLabel.preferredMaxLayoutWidth = self.view.frame.width
        DataAccessLayer.getCommentsForRemnant(remnantId!).then { (commentsFromParse:[PFObject]?) -> Void in
            self.comments = commentsFromParse!
            
            self.renderComments()
            
        }.error { (error:ErrorType) -> Void in
            UIUtility.ShowAlert(self, title: "Error", message: "There was an error loading the remnant comments. \(error)")
        }
        
    }
    
    func renderComments(){
        let commentString = NSMutableAttributedString()
        for comment in self.comments{
            
            let user = (comment["fromUser"] as! PFUser)
            
            user.fetchIfNeededInBackgroundWithBlock({ (toUser:PFObject?, error:NSError?) -> Void in
                let username = toUser!["username"] as! String
                let commentContent = comment["content"] as! String
                
                commentString.appendAttributedString(self.getColoredText(username , description: "\(commentContent)\r\n", color: UIColor.blueColor()))
            })
            

        }
        
        self.commentsContainerLabel.attributedText = commentString
        
    }
    
    
    @IBAction func addCommentTapped(sender: AnyObject) {
        
        let trimmedComment = commentTextView.text.trim()
        if(trimmedComment == ""){
            return
        }
        
        commentTextView.text = ""



        DataAccessLayer.addComment(selectedRemnant!.objectId!, toUserId: (selectedRemnant!["user"] as! PFUser).objectId!, comment: trimmedComment).then({ (comment:PFObject?) -> Void in
            print("comment added successfully")
            self.comments.append(comment!)
            self.renderComments()
            
        }).error { (error:ErrorType) -> Void in
            UIUtility.ShowAlert(self, title: "Error", message: "There was an error loading the remnant. \(error)")
        }
        
    }
}

