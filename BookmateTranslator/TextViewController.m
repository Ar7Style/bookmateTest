//
//  TextViewController.m
//  BookmateTranslator
//
//  Created by Tareyev Gregory on 03.10.15.
//  Copyright (c) 2015 Tareyev Gregory. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController () 
@end

@implementation TextViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getRandomText];
   
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action: @selector(translate:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(translate:)) {
        if (_textView.selectedRange.length > 0) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)canBecomeFirstResponder { return YES; }


#pragma mark - text handling

-(void)translate:(id)translate {
    
    //UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *selectedText = [_textView textInRange:_textView.selectedTextRange];
    NSUserDefaults * userCache = [NSUserDefaults standardUserDefaults];
    [userCache setValue:selectedText forKey:@"selectedText"];
    //NSLog([userCache valueForKey:@"selectedText"]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *BMTranslateViewController = (UIViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"BMTranslateViewController"];
    
    [self.navigationController pushViewController:BMTranslateViewController animated:YES];
    
}



#pragma mark - getting the text

- (NSString *)cleanString:(NSString *)stringWithSpecialCharacters // forgot the regular expression :D
{
    NSString *temp = [stringWithSpecialCharacters stringByReplacingOccurrencesOfString:@"</ul>" withString:@""];
    NSString *temp1 = [temp stringByReplacingOccurrencesOfString:@"<li>" withString:@""];
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"<ul>" withString:@""];
    NSString *text = [temp2 stringByReplacingOccurrencesOfString:@"</li>" withString:@""];
    return text;
}

-(void) getRandomText
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://randomtext.me/api/gibberish/ul-5/5-105/"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                NSString * stringWithSpecialCharacters = json[@"text_out"];
                                                                NSString *text;
                                                                text = [self cleanString:stringWithSpecialCharacters];
                                                                
                                                                _textView.text = text;
                                                            });
                                                          }
                                                    }];
    [dataTask resume];
}



@end
