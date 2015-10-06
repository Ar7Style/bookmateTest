//
//  TranslateViewController.h
//  BookmateTranslator
//
//  Created by Tareyev Gregory on 06.10.15.
//  Copyright (c) 2015 Tareyev Gregory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslateViewController : UIViewController <UITextFieldDelegate> {
    bool isKeyboardShow;
    NSString* textTotranslate;
}
- (IBAction)englishButtonPressed:(id)sender;
- (IBAction)russianButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *translatedText;
@property (weak, nonatomic) IBOutlet UITextField *chosenText;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@property(strong, nonatomic, readwrite) NSString* textToTranslate;

@end
