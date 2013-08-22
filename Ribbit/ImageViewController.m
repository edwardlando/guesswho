//
//  ImageViewController.m
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "ImageViewController.h"
#import "GuessFriendViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    
//    NSString *senderName = [self.message objectForKey:@"senderName"];
//    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
//    self.navigationItem.title = title;
    self.navigationItem.title = @"Message from ?";
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    if ([self respondsToSelector:@selector(timeout)]) {
//        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
//    }
//    else {
//        NSLog(@"Error: selector missing!");
//    }
//}

// Passing the sender name to guessFriendViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGuessFriend"]) {
        GuessFriendViewController *viewController = (GuessFriendViewController *)segue.destinationViewController;
        NSString *senderName = [self.message objectForKey:@"senderName"];
        viewController.senderName = senderName;
    }
}

#pragma mark - Helper methods

- (void)timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
