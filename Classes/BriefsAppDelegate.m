//
//  BriefsAppDelegate.m
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BriefsAppDelegate.h"
#import "BFSceneViewController.h"
#import "BFMainViewController.h"
#import "BFDataManager.h"
#import "BFPagedBrowseViewController.h"

@implementation BriefsAppDelegate

@synthesize navigationController, window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL hasLaunchedBefore = [[NSUserDefaults standardUserDefaults] boolForKey:kBFHasLaunchedBefore];
    if (!hasLaunchedBefore) {

        // if App is launching for the first time

        [[BFDataManager sharedBFDataManager] load];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBFHasLaunchedBefore];
    }

    BFMainViewController *controller = [BFMainViewController alloc];
    if (launchOptions) {
        NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        controller = [controller initWithExternalURL:url];
    }

    else {
        // no url sent, going to default for now
        // TODO: Need to flesh out rest of the launch states.
        controller = [controller initWithState:BFMainViewDefaultState];
    }

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.delegate = self;
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    [window addSubview:[self.navigationController view]];
    [window makeKeyAndVisible];
    [controller release];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[BFDataManager sharedBFDataManager] save];
}

- (void)dealloc
{
    [navigationController release];
    [window release];
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)nav willShowViewController:(UIViewController *)view
                    animated:(BOOL)animated
{
    if ([view isKindOfClass:[BFSceneViewController class]]) {
        [nav setNavigationBarHidden:YES animated:YES];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [nav setNavigationBarHidden:NO animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)nav didShowViewController:(UIViewController *)view
                    animated:(BOOL)animated
{
    if ([view isKindOfClass:[BFSceneViewController class]]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////

@end
