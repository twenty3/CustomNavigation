//
//  CustomNavigationPushSegue.m
//
//  Created by 23 on 7/7/13.
//

#import "CustomNavigationPushSegue.h"
#import "CustomNavigationController.h"

@implementation CustomNavigationPushSegue

- (void)perform
{
    // Get the navigation controller of the source controller
    // and tell it to push the destination
    CustomNavigationController* navigationController = [self.sourceViewController customNavigationController];
    
    [navigationController pushCustomViewController:self.destinationViewController animated:YES];
    
}

@end
