//
//  FriendsViewController.m
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "FollowingViewController.h"
#import "EditFollowingViewController.h"

@interface FollowingViewController ()

@end

@implementation FollowingViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    // Fetch Facebook friends
    [self retrieveFacebookFriends:[PFUser currentUser] completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"first_name"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEditFriends"]) {
        EditFollowingViewController *viewController = (EditFollowingViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [user valueForKey:@"name"];
    
    return cell;
}

- (void)retrieveFacebookFriends:(PFUser *)user completion:(void(^)(NSArray *))completion {
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            NSMutableArray *facebookFriends = [NSMutableArray arrayWithCapacity:friendObjects.count];
            PFRelation *friendsRelation = [user relationforKey:@"friendsRelation"];
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
                self.friends = objects;
                
                // Add friendsRelation to Parse backend
                for(PFUser *friend in self.friends) {
                    [friendsRelation addObject:friend];
                }
                
                [user saveInBackground];
                [self.tableView reloadData];
                

                NSLog(@"array: %@", self.friends);
            }];
            
            [self.tableView reloadData];
            
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



@end
