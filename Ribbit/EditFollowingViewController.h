//
//  EditFriendsViewController.h
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utility.h"

@interface EditFollowingViewController : UITableViewController

//@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) NSMutableArray *facebookFriends;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSArray *searchResults;

- (BOOL)isFriend:(PFUser *)user;
- (void)retrieveFacebookFriends:(PFUser *)user completion:(void(^)(NSArray *))completion;
- (void)sendFacebookInvite:(PFUser *)user completion:(void(^)(NSArray *))completion;



@end
