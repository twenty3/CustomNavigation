//
//  CustomNavigationController.h
//
//  Created by 23 on 7/6/13.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UIViewController

@property(nonatomic,readonly,strong) UIViewController* topCustomViewController;

- (void)pushCustomViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popCustomViewControllerAnimated:(BOOL)animated;




@end



@interface UIViewController (CustomNavigationController)

- (CustomNavigationController*) customNavigationController;
    // return the containing custom navigation controller for this view controller (if any)

@end