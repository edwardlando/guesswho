//
//  EditFriendsViewController.m
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "EditFollowingViewController.h"

@interface EditFollowingViewController ()

@end

@implementation EditFollowingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    [self retrieveFacebookFriends:[PFUser currentUser] completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.facebookFriends count]; // or facebookFriends
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Show only Facebook friends who don't have the app
    PFUser *user = [self.facebookFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = [user valueForKey:@"name"];
    
    // create an inviteSent method
//    if ([self inviteSent:user]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] name];
    }
    
    return cell;
    

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //PFRelation *friendsRelation = [self.currentUser relationforKey:@"friendsRelation"];
    
    // Not a PFUser!
    
    PFUser *user = [[self chooseAppropriateArray] objectAtIndex:indexPath.row];
    
    [self sendFacebookInvite:user completion:nil];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
   // Add for search table view
    
}

// Code from PARSE

/*
- (void)cell:(PAPFindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}

- (void)shouldToggleFollowFriendForCell:(PAPFindFriendsCell*)cell {
    PFUser *cellUser = cell.user;
    if ([cell.followButton isSelected]) {
        // Unfollow
        cell.followButton.selected = NO;
        [Utility unfollowUserEventually:cellUser];
    } else {
        // Follow
        cell.followButton.selected = YES;
        [Utility followUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserFollowingChangedNotification object:nil];
            } else {
                cell.followButton.selected = NO;
            }
        }];
    }
}
 */

// Code from PARSE

#pragma mark - Helper methods



- (void)sendFacebookInvite:(PFUser *)user completion:(void (^)(NSArray *))completion {
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // send to the Facebook Id of the recipient
                                     [user valueForKey:@"id"], @"to",
                                     nil];
                                    NSLog(@"id %@", [user valueForKey:@"fbId"]);
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                  message:[NSString stringWithFormat:@"I'd like to play Peekaboo with you."]
                  title:nil
                  parameters:params
                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                      if (error) {
                          NSLog(@"Error sending request.");
                      }
                      else {
                          if (result == FBWebDialogResultDialogNotCompleted) {
                              // Case B: User clicked the "x" icon
                              NSLog(@"User canceled request.");
                          }
                          else {
                              NSLog(@"Request Sent.");
                          }
                      }
    }];
    
    
}


- (void)retrieveFacebookFriends:(PFUser *)user completion:(void(^)(NSArray *))completion {
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            NSMutableArray *facebookFriends = [NSMutableArray arrayWithCapacity:friendObjects.count];
            //NSLog(@"array: %@", friendObjects);
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject valueForKey:@"id"]]; // add them here to my FB friends
                [facebookFriends addObject:friendObject];
                self.facebookFriends = facebookFriends;
            }
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.friends = [objects mutableCopy];
                NSLog(@"array: %@", self.friends);
            }];
            
            [self.tableView reloadData];
            
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}




// Search bar
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSArray *searchResults = [[NSArray alloc] init];
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    searchResults = [self.facebookFriends filteredArrayUsingPredicate:resultPredicate];
    self.searchResults = searchResults;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSArray*)chooseAppropriateArray
{
    if ([self.searchDisplayController.searchBar.text length] == 0) {
        return self.facebookFriends;
    }
    else {
        return self.searchResults;
    }
}
    
@end
