//
//  InboxViewController.h
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utility.h"

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) PFObject *selectedPost;

- (IBAction)logout:(id)sender;

- (void)queryPosts;


@end
