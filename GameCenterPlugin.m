//
//  GameCenterPlugin.m
//  Detonate
//
//  Created by Marco Piccardo on 04/02/11.
//  Copyright 2011 Eurotraining Engineering. All rights reserved.
//

#import "GameCenterPlugin.h"
#import <Cordova/CDVViewController.h>

@implementation GameCenterPlugin

- (void)authenticateLocalPlayer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        }
        else
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];
        }
    }];
}

- (void)reportScore:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *callbackId = [arguments objectAtIndex:0];

    NSString *category = (NSString*) [arguments objectAtIndex:1];
    int64_t score = [[arguments objectAtIndex:2] integerValue];

    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;

    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (!error)
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];
        }
    }];
}

- (void)showLeaderboard:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.category = (NSString*) [arguments objectAtIndex:1];
        CDVViewController* cont = (CDVViewController*)[super viewController];
        [cont presentViewController:leaderboardController animated:YES completion:^{
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
        }];
    }
}

- (void)showAchievements:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil)
    {
        achievements.achievementDelegate = self;
        CDVViewController* cont = (CDVViewController*)[super viewController];
        [cont presentViewController:achievements animated:YES completion:^{
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
        }];
    }
    [achievements release];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    CDVViewController* cont = (CDVViewController*)[super viewController];
    [cont dismissModalViewControllerAnimated:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    CDVViewController* cont = (CDVViewController*)[super viewController];
    [cont dismissModalViewControllerAnimated:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
}

- (void)reportAchievementIdentifier:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    
    NSString *identifier = (NSString*) [arguments objectAtIndex:1];
    float percent = [[arguments objectAtIndex:2] floatValue];

    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if (!error)
            {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];
            }
        }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to alloc GKAchievement"];
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];
    }
}

@end
