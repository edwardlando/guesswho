//
//  TextMessageViewController.h
//  GuessWho
//
//  Created by Edward Lando on 8/24/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostViewController : UITableViewController

// @property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSMutableDictionary *postStatus; // Post status maps from users to status

- (IBAction)savePost:(id)sender;
- (IBAction)cancelTextMessage:(id)sender;

@end
