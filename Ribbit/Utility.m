//
//  Utility.m
//  GuessWho
//
//  Created by Edward Lando on 8/23/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "Utility.h"

@implementation Utility

// PARSE code

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:@"Activity"];
    [followActivity setObject:[PFUser currentUser] forKey:@"ActivityFromUser"];
    [followActivity setObject:user forKey:@"ActivityToUser"];
    [followActivity setObject:@"Follow" forKey:@"Activity"];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[PAPCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:@"Activity"];
    [followActivity setObject:[PFUser currentUser] forKey:@"ActivityFromUser"];
    [followActivity setObject:user forKey:@"ActivityToUser"];
    [followActivity setObject:@"Follow" forKey:@"Activity"];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[PAPCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    for (PFUser *user in users) {
        [PAPUtility followUserEventually:user block:completionBlock];
        [[PAPCache sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"ActivityFromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"ActivityToUser" equalTo:user];
    [query whereKey:@"Activity" equalTo:@"Follow"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    [[PAPCache sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users {
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"ActivityFromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"ActivityToUser" containedIn:users];
    [query whereKey:@"Activity" equalTo:@"Follow"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (PFObject *activity in activities) {
            [activity deleteEventually];
        }
    }];
    for (PFUser *user in users) {
        [[PAPCache sharedCache] setFollowStatus:NO user:user];
    }
}

// PARSE code

+ (void)loginWithFacebook:(void (^)(BOOL, NSError*))completion {

    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];

    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
      
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
                
                if (completion) {
                    completion(NO, error);
                }
                
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
                
                
                if (completion) {
                    completion(NO, error);
                }

            }
        } else if (user.isNew) {
            // When your user logs in, immediately get and store its Facebook ID
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"fbId"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"username"]
                                             forKey:@"username"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                             forKey:@"name"];
                    if ([result objectForKey:@"email"] != nil) {
                        [[PFUser currentUser] setObject:[result objectForKey:@"email"]
                                                 forKey:@"email"];
                    }
                    [[PFUser currentUser] saveInBackground];
                }
            }];
            NSLog(@"User with facebook signed up and logged in!");
            
            if (completion) {
                completion(YES, error);
            }
            
           
        } else {
            
            if (completion) {
                completion(YES, error);
            }
            
            NSLog(@"User with facebook logged in!");
            
        }
    }];

 
}



@end
