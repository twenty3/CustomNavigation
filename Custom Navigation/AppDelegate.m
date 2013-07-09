//
//  AppDelegate.m
//  Custom Navigation
//
//  Created by 23 on 7/6/13.
//  Copyright (c) 2013 Aged and Distilled. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    return YES;
}

#pragma mark - Actions

// These actions are here so any of the generic UIViewControllers in this test project
// can send button actions to first responder 

- (IBAction)nextButtonTapepd:(id)sender
{
    if ( [self.window.rootViewController isKindOfClass:[CustomNavigationController class]] )
    {
        CustomNavigationController* navigationController = (CustomNavigationController*)self.window.rootViewController;
        [navigationController.topCustomViewController performSegueWithIdentifier:@"CustomNavigationPushSegue" sender:sender];
    }
}

- (IBAction)backButtonTapped:(id)sender
{
    CustomNavigationController* navigationController = (CustomNavigationController*)self.window.rootViewController;
    [navigationController popCustomViewControllerAnimated:YES];
}

@end
