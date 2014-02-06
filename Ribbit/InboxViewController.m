//
//  InboxViewController.m
//  GuessWho
//
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "InboxViewController.h"
#import "PostViewController.h"
#import "Utility.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTokenIfNeeded];
    
   }

- (void) refreshTokenIfNeeded {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
            [self queryPosts];
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The Facebook session was invalidated");
            [PFUser logOut];
            [self refreshTokenIfNeeded];
            
            
        } else {
            NSLog(@"Some other error: %@", error);
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
    // Return the number of rows in the section.
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *post = [self.posts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [post objectForKey:@"authorName"]; 
    
    return cell;
}

- (void) queryPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    // get following and the all their posts
    // [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            // We found posts!
            self.posts = objects;
            [self.tableView reloadData];
            NSLog(@"Retrieved %d messages", [self.posts count]);
        }
    }];

}


- (PFQuery *)queryForTable {
    // Query for the friends the current user is following
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:@"Activity"];
    [followingActivitiesQuery whereKey:@"Activity" equalTo:@"Follow"];
    [followingActivitiesQuery whereKey:@"ActivityFromUser" equalTo:[PFUser currentUser]];
    
    // Using the activities from the query above, we find all of the posts written by
    // the friends the current user is following
    PFQuery *postsFromFollowedUsersQuery = [PFQuery queryWithClassName:@"Posts"];
    [postsFromFollowedUsersQuery whereKey:@"PostAuthor" matchesKey:@"ActivityToUser" inQuery:followingActivitiesQuery];
    [postsFromFollowedUsersQuery whereKeyExists:@"Post"];
    
    // We create a second query for the current user's posts
    PFQuery *postsFromCurrentUserQuery = [PFQuery queryWithClassName:@"Posts"];
    [postsFromCurrentUserQuery whereKey:@"PostAuthor" equalTo:[PFUser currentUser]];
    [postsFromCurrentUserQuery whereKeyExists:@"Post"];
    
    // We create a final compound query that will find all of the posts that were
    // written by the user's friends or by the user
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:postsFromFollowedUsersQuery, postsFromCurrentUserQuery, nil]];
    [query includeKey:@"PostAuthor"];
    [query orderByDescending:@"createdAt"];
    return query;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPost = [self.posts objectAtIndex:indexPath.row];
  
    [self performSegueWithIdentifier:@"showPost" sender:self];
        
        // Message status
        NSMutableDictionary *messageStatus = [self.selectedPost objectForKey:@"messageStatus"];
        PFUser *currentUser = [PFUser currentUser];
    
        [self.selectedPost saveInBackground];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showPost"]) { // used to be showImage
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        PostViewController *postViewController = (PostViewController *)segue.destinationViewController;
        postViewController.text = self.selectedPost;
    }
}

@end
