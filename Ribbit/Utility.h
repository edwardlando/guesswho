//
//  Utility.h
//  GuessWho
//
//  Created by Edward Lando on 8/23/13.
//  Copyright (c) 2013 GuessWho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PAPUtility.h"
#import "PAPCache.h"


@interface Utility : NSObject

+ (void)loginWithFacebook:(void (^)(BOOL, NSError* error))completion;

@end
