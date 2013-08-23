//
//  Utility.m
//  GuessWho
//
//  Created by Edward Lando on 8/23/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *)setMessageSender:(PFObject *)message {
    NSMutableDictionary *messageStatus = [message objectForKey:@"messageStatus"];
    PFUser *currentUser = [PFUser currentUser];
    NSString *outputString = [NSString new];
    
    // If guessedRight show name
    if ([[messageStatus valueForKey:currentUser.objectId ] isEqualToString:@"guessedRight"]) {
        outputString = [message objectForKey:@"senderName"]; // Need to make it for unique message
    }
    // If guessedWrong show X
    else if ([[messageStatus valueForKey:currentUser.objectId ] isEqualToString:@"guessedWrong"]) {
        outputString  = @"X";
    }
    // If unread show ?
    else {
        outputString  = @"?";
    }
    
    return outputString;
}

@end
