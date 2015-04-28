//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()
@property (weak, nonatomic) IBOutlet UIView *icon;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property float draggingOffsetX;
@property float draggingOffsetY;

@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)spinButtonPressed:(UIButton *)sender
{
    [self numberOfSpins:1];
}

// Spinning
-(void) numberOfSpins: (int)times
{
    // rotation is 360 degree spin
    int rotations = times * 2;
    float timeFrame = 0.5 * times;
    
    [UIView animateWithDuration:timeFrame animations:^{
        for (int i = 1; i <= rotations; i++) {
            self.icon.transform = CGAffineTransformRotate(self.icon.transform, M_PI);
        }
    }];
}

// Dragging
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.mainView];
    
    if (CGRectContainsPoint(self.icon.frame, touchLocation))
    {
        self.icon.center  = CGPointMake(touchLocation.x-self.draggingOffsetX, touchLocation.y-self.draggingOffsetY);
    }
}
// Setting values to make dragging smooth (without centering on the touch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.mainView];
    
    self.draggingOffsetX = touchLocation.x - self.icon.center.x;
    self.draggingOffsetY = touchLocation.y - self.icon.center.y;
}
// Changing status bar color to white
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
