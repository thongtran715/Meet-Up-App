//
//  ParseHelper.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/8/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    // Get Message from other users send to us
    static func getMessageFromOthersUser( completionBlock : PFQueryArrayResultBlock)
    {
        
        let userShareQuery = UserSharePost.query()
        userShareQuery?.whereKey("toUser", equalTo: PFUser.currentUser()!)
        userShareQuery?.includeKey("fromPost")
        userShareQuery?.orderByDescending("createdAt")
        userShareQuery?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // Get message from this user
    static func getMessageFromCurrentUser(completionBlock: PFQueryArrayResultBlock)
    {
        // 1 main query
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 5
        let query = PFQuery.orQueryWithSubqueries([ postsFromThisUser!])
        
        query.includeKey("user")
        // 6
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    //fetching all users
    static func getAllUsers(completionBlock: PFQueryArrayResultBlock) ->PFQuery {
        
        let query = PFUser.query()!
        query.whereKey("username", notEqualTo: (PFUser.currentUser()?.username!)!)
        query.orderByAscending("username")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    
    // deleting images related to the post
    static func deleteImages(post : Post) {
        let query = imageHolder.query()
        query?.whereKey("fromPost", equalTo: post)
        query?.findObjectsInBackgroundWithBlock({ (results, error) in
            
            if let results = results {
                for result in results {
                    result.deleteInBackgroundWithBlock({ (success, error) in
                        if success {
                            
                        }
                        else
                        {
                            print(error?.localizedDescription)
                        }
                    })
                }
            }
        })
    }
    
    // searching for specific user
    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        /*
         NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
         Regex can be slow on large datasets. For large amount of data it's better to store
         lowercased username in a separate column and perform a regular string compare.
         */
        let query = PFUser.query()!.whereKey("username",
                                             matchesRegex: searchText, modifiers: "i")
        
        query.whereKey("username",
                       notEqualTo: PFUser.currentUser()!.username!)
        
        query.orderByAscending("username")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    // unsubcribe the post from another user 
    static func unRelatedToShare(toUser: PFUser, post: Post, fromUser: PFUser)
    {
        let querry = PFQuery(className: "userShare")
        querry.whereKey("toUser", equalTo: toUser)
        querry.whereKey("fromPost", equalTo: post)
        querry.whereKey("fromUser", equalTo: fromUser)
        querry.findObjectsInBackgroundWithBlock { (results, error) in
            let results = results ?? []
            for follow in results
            {
                follow.deleteInBackgroundWithBlock({ (success, error) in
                    if success {
                        
                    } else {
                        print((error?.localizedDescription)!)
                    }
                })
            }
        }
    }
    
    static func getPictureProfile(completionBlock : PFDataResultBlock) {
        if  PFUser.currentUser()!["profileImage"] != nil {
            let avatarFile = PFUser.currentUser()!["profileImage"] as! PFFile
            avatarFile.getDataInBackgroundWithBlock(completionBlock)
    }
       
}
  
}
extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}