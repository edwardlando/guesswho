//
//  GuessFriendViewController.m
//  GuessWho
//
//  Created by Edward Lando on 8/22/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import "GuessFriendViewController.h"
#import <Parse/Parse.h>

@interface GuessFriendViewController ()

@end

@implementation GuessFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    
    if ([user.username isEqualToString:self.senderName]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Yay!"
                                                            message:@"You guessed right!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        // TO DO should also now show the name of the sender in the inbox
 
    } 
    
    // Guessed wrong
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Doh!"
                                                            message:@"Nope, that's not it. Someone else sent you this!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
        
        
    

    
}

@end
