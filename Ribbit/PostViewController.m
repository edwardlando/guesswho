//
//  TextMessageViewController.m
//  GuessWho
//
//  Created by Edward Lando on 8/24/13.
//  Copyright (c) 2013 Peekaboo. All rights reserved.
//

#import "PostViewController.h"
#import "TextInputViewController.h"

@interface PostViewController () < TextInputViewControllerDelegate > 

@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.postStatus = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    // Segue
    [self performSegueWithIdentifier:@"textInput" sender:self];
    
  }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* navigationController = (UINavigationController*)[segue destinationViewController]; // casting
    TextInputViewController* textInput = (TextInputViewController*)navigationController.topViewController;
    textInput.delegate = self;
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
    cell.textLabel.text = user.username;
 
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [self.recipients addObject:user.objectId];
//        [self.messageStatus setValue:@"unread" forKey:user.objectId];
    }
    else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        [self.recipients removeObject:user.objectId];
    }

}

#pragma mark - Delegate (Protocol)

- (void) textInputViewControllerDidCancel:(TextInputViewController *)textInputViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textInputViewController:(TextInputViewController *)textInputViewController didFinishWithText:(NSString *)text {
    self.text = text;
}

#pragma mark - IBActions

- (IBAction)savePost:(id)sender {
    [self uploadPost];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)cancelPost:(id)sender {
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - Helper methods

- (void)uploadPost {
   
    PFObject *post = [PFObject objectWithClassName:@"Post"];
 
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please try posting again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            // Create a post
            [post setObject:[PFUser currentUser] forKey:@"PostAuthor"];
            [post setObject:self.text forKey:@"text"];
            
//            [post setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
//            [post setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                        message:@"Please try sending your message again."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    // Everything was successful!
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset {
    self.text = nil;
}




@end
