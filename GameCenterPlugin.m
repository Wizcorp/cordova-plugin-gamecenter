//
//  GameCenterPlugin.m
//  Detonate
//
//  Created by Marco Piccardo on 04/02/11.
//  Copyright 2011 Eurotraining Engineering. All rights reserved.
//

#import "GameCenterPlugin.h"
#import <Cordova/CDVViewController.h>

@interface GameCenterPlugin ()
@property (nonatomic, retain) GKLeaderboardViewController *leaderboardController;
@property (nonatomic, retain) GKAchievementViewController *achievementsController;
@end

@implementation GameCenterPlugin

- (void)dealloc
{
    self.leaderboardController = nil;
    self.achievementsController = nil;
    
    [super dealloc];
}

- (void)authenticateLocalPlayer:(CDVInvokedUrlCommand*)command
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript: [pluginResult toSuccessCallbackString:command.callbackId]];
        }
        else
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self writeJavascript: [pluginResult toErrorCallbackString:command.callbackId]];
        }
    }];
}

- (void)reportScore:(CDVInvokedUrlCommand*)command
{
    NSString *category = (NSString*) [command.arguments objectAtIndex:0];
    int64_t score = [[command.arguments objectAtIndex:1] integerValue];

    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;

    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (!error)
        {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript: [pluginResult toSuccessCallbackString:command.callbackId]];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self writeJavascript: [pluginResult toErrorCallbackString:command.callbackId]];
        }
    }];
}

- (void)showLeaderboard:(CDVInvokedUrlCommand*)command
{
    if ( self.leaderboardController == nil ) {
        self.leaderboardController = [[GKLeaderboardViewController alloc] init];
        self.leaderboardController.leaderboardDelegate = self;
    }

    self.leaderboardController.category = (NSString*) [command.arguments objectAtIndex:0];
    CDVViewController* cont = (CDVViewController*)[super viewController];
    [cont presentViewController:self.leaderboardController animated:YES completion:^{
        [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
    }];
}

- (void)showAchievements:(CDVInvokedUrlCommand*)command
{
    if ( self.achievementsController == nil ) {
        self.achievementsController = [[GKAchievementViewController alloc] init];
        self.achievementsController.achievementDelegate = self;
    }

    CDVViewController* cont = (CDVViewController*)[super viewController];
    [cont presentViewController:self.achievementsController animated:YES completion:^{
        [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
    }];
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

- (void)reportAchievementIdentifier:(CDVInvokedUrlCommand*)command
{
    NSString *identifier = (NSString*) [command.arguments objectAtIndex:0];
    float percent = [[command.arguments objectAtIndex:1] floatValue];

    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if (!error)
            {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self writeJavascript: [pluginResult toSuccessCallbackString:command.callbackId]];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                [self writeJavascript: [pluginResult toErrorCallbackString:command.callbackId]];
            }
        }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to alloc GKAchievement"];
        [self writeJavascript: [pluginResult toErrorCallbackString:command.callbackId]];
    }
}

@end
