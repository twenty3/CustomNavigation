//
//  CustomNavigationController.m
//
//  Created by 23 on 7/6/13.


#import "CustomNavigationController.h"

#import <QuartzCore/QuartzCore.h>

const NSTimeInterval kCustomNavigationPushAnimationDuration = 0.33;
const NSTimeInterval kCustomNavigationPopAnimationDuration = 0.33;

@interface CustomNavigationController ()<UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *customContainerView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic,strong) NSMutableArray* controllerStack;
@property (assign, nonatomic, getter=isPoppingTopItem) BOOL poppingTopItem;

@end

@implementation CustomNavigationController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    self.controllerStack = [NSMutableArray new];
    self.poppingTopItem = NO;
}

- (NSString*) classAsString
{
    return NSStringFromClass( [self class] );
}

#pragma mark - UIViewController

- (void)viewDidLoad
{    
    self.navigationBar.delegate = self;
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect viewFrame = self.view.frame;
    
    CGRect navigationBarFrame = self.navigationBar.frame;
    
    CGRect contentFrame = self.customContainerView.frame;
    contentFrame.size.height = viewFrame.size.height - navigationBarFrame.size.height;
    contentFrame.origin.y = CGRectGetMaxY(navigationBarFrame);
    self.customContainerView.frame = contentFrame;    
}

#pragma mark - Content Layout

- (void) resizeContentView:(UIView*)view
{
    CGRect contentBounds = self.customContainerView.bounds;
    view.frame = contentBounds;
}

- (CGPoint) positionLeftOfContentForView:(UIView*)view
{
    CGPoint origin = view.frame.origin;
    CGRect contentBounds = self.customContainerView.bounds;
    origin.x = (contentBounds.origin.x - view.frame.size.width);
    
    return origin;
}

- (CGPoint) positionRightOfContentForView:(UIView*)view
{
    CGPoint origin = view.frame.origin;
    CGRect contentBounds = self.customContainerView.bounds;
    origin.x = CGRectGetMaxX(contentBounds);
    
    return origin;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"CustomNavigationRootViewEmbedSegue"] )
    {
        [self pushController:segue.destinationViewController];
        UINavigationItem* navigationItem = [segue.destinationViewController navigationItem];
        if ( navigationItem != nil)
        {
            [self.navigationBar setItems:@[navigationItem]];
        }
    }
}


#pragma mark - Navigation

- (UIViewController*) topCustomViewController
{
    return self.controllerStack.lastObject;
}

- (void) pushController:(UIViewController*)viewController
{
    // For debugging layout:
    //viewController.view.layer.borderColor = [UIColor orangeColor].CGColor;
    //viewController.view.layer.borderWidth = 3.0;

    @try
    {
        [self.controllerStack addObject:viewController];
    }
    @catch (NSException *exception)
    {
        if ( [exception isKindOfClass:[NSInvalidArgumentException class]] )
        {
            NSLog(@"%@: Tried to push a nil view controller onto the stack", [self classAsString]);
        }
        
        @throw exception;
    }
}

- (UIViewController*) popController
{
    UIViewController* poppedController = self.controllerStack.lastObject;
    if ( self.controllerStack.count <= 1)
    {
        NSLog( @"%@: Can't pop the root view controller", [self classAsString] );
        return nil;
    }
    
    @try
    {
        [self.controllerStack removeLastObject];
    }
    @catch (NSException *exception)
    {
        if ( [exception isKindOfClass:[NSRangeException class]] )
        {
            NSLog(@"%@: Tried to pop view controller with an empty stack", [self classAsString]);
        }
        @throw exception;
    }
    
    return poppedController;
}

- (void)pushCustomViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addChildViewController:viewController];
    if ( viewController.navigationItem )
    {
        [self.navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
    }
    
    [self resizeContentView:viewController.view];

    UIView* fromView = self.topCustomViewController.view;
    UIView* toView = viewController.view;
    
    CGRect toViewFrame = toView.frame;
    toViewFrame.origin = [self positionRightOfContentForView:toView];
    toView.frame = toViewFrame;
    
    CGRect fromViewFrame = fromView.frame;
    CGRect fromViewFinalFrame = {[self positionLeftOfContentForView:fromView], fromViewFrame.size};
    CGRect toViewFinalFrame = {CGPointZero, toViewFrame.size};
    
    [self transitionFromViewController:self.topCustomViewController
                      toViewController:viewController
                              duration:kCustomNavigationPushAnimationDuration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                fromView.frame = fromViewFinalFrame;
                                toView.frame = toViewFinalFrame;
                            }
                            completion:^(BOOL finished) {
                                [self pushController:viewController];
                            }];
}

- (UIViewController *)popCustomViewControllerAnimated:(BOOL)animated
{
    [self popNavigationItemAnimated:animated];
    return [self popViewControllerAndViewAnimated:animated];
}

- (UIViewController*)popViewControllerAndViewAnimated:(BOOL)animated
{
    UIViewController* currentController = [self popController];
    if (currentController != nil)
    {
        UIView* fromView = currentController.view;
        UIView* toView = self.topCustomViewController.view;
        
        CGRect toViewFrame = toView.frame;
        toViewFrame.origin = [self positionLeftOfContentForView:toView];
        toView.frame = toViewFrame;
        
        CGRect fromViewFrame = fromView.frame;
        CGRect fromViewFinalFrame = {[self positionRightOfContentForView:fromView], fromViewFrame.size};
        CGRect toViewFinalFrame = {CGPointZero, toViewFrame.size};
        
        [self transitionFromViewController:currentController
                          toViewController:self.topCustomViewController
                                  duration:kCustomNavigationPopAnimationDuration
                                   options:0 animations:^{
                                       fromView.frame = fromViewFinalFrame;
                                       toView.frame = toViewFinalFrame;
                                   } completion:^(BOOL finished) {
                                       [currentController removeFromParentViewController];
                                   }];
    }
    return currentController;
}

- (UINavigationItem*)popNavigationItemAnimated:(BOOL)animated
{
    self.poppingTopItem = YES;
    UINavigationItem* poppedItem = [self.navigationBar popNavigationItemAnimated:animated];
    self.poppingTopItem = NO;
    
    return poppedItem;
}

#pragma mark - UINavigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar*)navigationBar shouldPopItem:(UINavigationItem *)item
{    
    // We can use this delegate method to catch the default back button action
    // the navigation bar will use for any view controller that has not
    // specified a custom back button
    if ( self.navigationBar == navigationBar && !self.isPoppingTopItem )
    {
        [self popViewControllerAndViewAnimated:YES];
    }

    return YES;
}

@end

#pragma mark - 

@implementation UIViewController (CustomNavigationController)

- (CustomNavigationController*) customNavigationController
{
    CustomNavigationController* navigationController = nil;
    
    UIViewController* parentController = self.parentViewController;
    while (parentController != nil)
    {
        if ( [parentController isKindOfClass:[CustomNavigationController class]] )
        {
            navigationController = (CustomNavigationController*)parentController;
            break;
        }
        else
        {
            parentController = parentController.parentViewController;
        }
    }
    
    return navigationController;
}

@end

