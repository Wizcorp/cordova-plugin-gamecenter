cordova-plugin-gamecenter
===========================

* A plugin to integrate Game Center in a Cordova iOS app/game.
* Please read [Game Center Programming Guide](http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/GameKit_Guide/GameCenterOverview/GameCenterOverview.html) and the [iTunes Connect Developer Guide](https://itunesconnect.apple.com/docs/iTunesConnect_DeveloperGuide.pdf).

## Install ##

With Cordova CLI: 

`cordova plugin add https://github.com/Wizcorp/cordova-plugin-gamecenter`

## Sample Code ##

### Authentication

`gameCenter.authenticate(Function success, Function failure);`

### Showing the leaderboard

`gameCenter.showLeaderboard(String category, Function success, Function failure);`

### Showing the Achievements board

`gameCenter.showAchievements(Function success, Function failure);`

### Getting view show/hide events


	window.gameCenter.onshow = function() { console.log("onshow!" )}

	window.gameCenter.onhide = function() { console.log("onhide!" )}

### Report a score

`gameCenter.reportScore(String category, int score, Function success, Function failure);`

### Report an achievement

`gameCenter.reportAchievement(String category, Function success, Function failure);`

** For a working example see the project in `platforms/ios/` folder (remember to change your bundleId). **

# FAQ #

> I don't see my Leaderboard / Achievements in the popup!

Check you have configured your bundle id corectly.
