//
//  LoginViewController.h
//  GuessWho
//
//  Created by Edward Lando on 8/10/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)login:(id)sender;
- (IBAction)loginButtonTouchHandler:(id)sender;

@end
