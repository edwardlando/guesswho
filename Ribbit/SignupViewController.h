//
//  SignupViewController.h
//  GuessWho
//
//  Created by Edward Lando on 8/10/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)signup:(id)sender;

@end
