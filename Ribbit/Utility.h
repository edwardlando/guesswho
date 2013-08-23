//
//  Utility.h
//  GuessWho
//
//  Created by Edward Lando on 8/23/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Utility : NSObject

+ (NSString *)setMessageSender:(PFObject *)message;

@end
