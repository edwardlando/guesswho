//
//  GuessFriendViewController.h
//  GuessWho
//
//  Created by Edward Lando on 8/22/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GuessFriendViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSString *senderName;

@end
