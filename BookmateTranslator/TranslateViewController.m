//
//  TranslateViewController.m
//  BookmateTranslator
//
//  Created by Tareyev Gregory on 06.10.15.
//  Copyright (c) 2015 Tareyev Gregory. All rights reserved.
//

#import "TranslateViewController.h"

@interface TranslateViewController () {
    NSString* _textToTranslate;
}

@end

@implementation TranslateViewController

@synthesize textToTranslate = _textToTranslate;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * userCache = [NSUserDefaults standardUserDefaults];
    _chosenText.text = [userCache valueForKey:@"selectedText"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self translateTextOnLanguage:@"ru"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.navigationController.view.clipsToBounds=YES;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height <= 568) // <= iphone 5
        {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(willShowKeyboard) name:UIKeyboardDidShowNotification object:nil];
            [center addObserver:self selector:@selector(willHideKeyboard) name:UIKeyboardWillHideNotification object:nil];
        }
   
    }
    
    
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dismissKeyboard {
    [_chosenText resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Iterate through your subviews, or some other custom array of views
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}

#pragma mark - Keyboard Notification

- (void)willShowKeyboard{
    if (!isKeyboardShow){
        isKeyboardShow = true;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-216.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
- (void)backgroundTouchedHideKeyboard:(id)sender
{
    [self.chosenText resignFirstResponder];
    
}

- (void)willHideKeyboard{
    isKeyboardShow = false;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+216.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    //[self.emailField resignFirstResponder];
    [self.chosenText resignFirstResponder];
}

#pragma mark - translation logic

-(void)translateTextOnLanguage:(NSString *)language {
    textTotranslate = _chosenText.text;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://translate.yandex.net/api/v1.5/tr.json/translate"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
      [request setHTTPMethod:@"POST"];
    NSString* postString = [NSString stringWithFormat:@"key=trnsl.1.1.20150930T074032Z.cb21f79f9c2cb0c6.290b8003dc75a4edce017c8a5baa8103fb2471c5&text=%@&lang=%@&options=1", textTotranslate, language];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *fetchedArr = [json objectForKey:@"text"];
            _translatedTextView.text = fetchedArr[0];
            [_translatedTextView sizeToFit];
                    });
        }
    }];
    
    [postDataTask resume];
}

- (IBAction)englishButtonPressed:(id)sender {
     [self translateTextOnLanguage:@"en"];
}

- (IBAction)russianButtonPressed:(id)sender {
    [self translateTextOnLanguage:@"ru"];
}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.chosenText])
    {
        [self.chosenText becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
