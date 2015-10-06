//
//  TextViewController.h
//  BookmateTranslator
//
//  Created by Tareyev Gregory on 03.10.15.
//  Copyright (c) 2015 Tareyev Gregory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

-(void) getRandomText;
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
-(BOOL)canBecomeFirstResponder;

@end
