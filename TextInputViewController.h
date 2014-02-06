//
//  TextInputViewController.h
//  Peekaboo
//
//  Created by Edward Lando on 8/24/13.
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextInputViewController;

@protocol TextInputViewControllerDelegate <NSObject>

- (void) textInputViewController:(TextInputViewController*) textInputViewController didFinishWithText:(NSString*) text;
- (void) textInputViewControllerDidCancel:(TextInputViewController *)textInputViewController;

@end

@interface TextInputViewController : UIViewController

@property (nonatomic, weak) id < TextInputViewControllerDelegate > delegate;


@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)goOnToChooseRecipients:(id)sender;
- (IBAction)cancel:(id)sender;




@end
