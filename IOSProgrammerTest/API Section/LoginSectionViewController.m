//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Adds secure entry to password text field
    self.password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
        // building PHP request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:5.0f];
        
        [request setHTTPMethod:@"POST"];
        NSMutableString *post = [NSMutableString string];
        [post appendFormat:@"&%@=%@", @"username", self.userName.text];
        [post appendFormat:@"&%@=%@", @"password", self.password.text];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
    // sending request on SECONDARY QUEUE
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSError *error = nil;
        NSURLResponse* response = nil;
        NSData *outData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        // start the timer
        NSTimeInterval startTimer = [NSDate timeIntervalSinceReferenceDate];
        
        // Get MAIN queue back
        dispatch_async(dispatch_get_main_queue(), ^{

            // check the time on the timer (in miliseconds)
            NSTimeInterval elapsedTimer = ([NSDate timeIntervalSinceReferenceDate] - startTimer) * 1000;
            
            // Cenvert JSON into NSDictionary
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:outData options:0 error:NULL];
            // Create in UIAlert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dictionary valueForKey:@"code"]
                                                                           message: [NSString stringWithFormat:@"%@\n\nAPI call took %f milliseconds",[dictionary valueForKey:@"message"], elapsedTimer]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            // Create UIAlertAction
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // If login is successful, bring back to main screen
                if ([[dictionary valueForKey:@"code"] isEqualToString: @"Success"]) [self backAction:nil];
            }];
            [alert addAction:dismiss];
            [self presentViewController:alert animated:YES completion:nil];
            
        });
    }); 
}

// Dismissing keyboard on "Done"
- (IBAction)dismissKeyboard:(id)sender;
{
    [self.userName becomeFirstResponder];
    [self.userName resignFirstResponder];
    
    [self.password becomeFirstResponder];
    [self.password resignFirstResponder];
}
// Changing status bar color to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
