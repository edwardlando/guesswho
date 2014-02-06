//
//  TextInputViewController.m
//  Peekaboo
//
//  Created by Edward Lando on 8/24/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import "TextInputViewController.h"

@implementation TextInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load keyboard
    [self.textView becomeFirstResponder];
}

- (void) textMessageFinished {
    if ([self.textView.text length] == 0) {  
        // Alert user that they are sending blank message
    }
    else {
        [self.delegate textInputViewController:self didFinishWithText:self.textView.text];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)cancel:(id)sender {
    [self.delegate textInputViewControllerDidCancel:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)goOnToChooseRecipients:(id)sender {
    [self textMessageFinished];
}
@end
