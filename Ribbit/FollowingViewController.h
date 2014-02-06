//
//  FriendsViewController.h
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FollowingViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *facebookFriends;

- (void)retrieveFacebookFriends:(PFUser *)user completion:(void(^)(NSArray *))completion;


@end
