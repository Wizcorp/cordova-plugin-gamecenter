//
//  GameCenterPlugin.h
//  Detonate
//
//  Created by Marco Piccardo on 04/02/11.
//  Copyright 2011 Eurotraining Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import <GameKit/GameKit.h>

@interface GameCenterPlugin : CDVPlugin <GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate> {
}

- (void)authenticateLocalPlayer:(CDVInvokedUrlCommand*)command;
- (void)reportScore:(CDVInvokedUrlCommand*)command;
- (void)showLeaderboard:(CDVInvokedUrlCommand*)command;
- (void)showAchievements:(CDVInvokedUrlCommand*)command;
- (void)reportAchievementIdentifier:(CDVInvokedUrlCommand*)command;

@end
