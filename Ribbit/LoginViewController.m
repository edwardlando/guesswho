//
//  LoginViewController.m
//  GuessWho
//
//  Created by Edward Lando on 8/10/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "LoginViewController.h"
#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "Utility.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    
    // Facebook
    self.title = @"Facebook Profile";
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController pushViewController:[[InboxViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
    }
}




// Regular login
- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    [Utility loginWithFacebook:^(BOOL success, NSError* error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        PFUser *user = [PFUser currentUser];
        
        if (!user) {
            if (!error) {    
                
            }
            else {
                
            }
        } else if (user.isNew) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            
            
            
            NSLog(@"User with facebook logged in!");
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }
        
        
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    
    
}



@end
