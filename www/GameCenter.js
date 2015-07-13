    var GameCenter = function() {
        this.onshow = null;
        this.onhide = null;
    }
    
    GameCenter.prototype = {
        authenticate: function(s, f) {
            cordova.exec(s, f, "GameCenterPlugin", "authenticateLocalPlayer", []);
        },
    
        showLeaderboard: function(category) {
            cordova.exec(null, null, "GameCenterPlugin", "showLeaderboard", [category]);
        },
    
        reportScore: function(category, score, s, f) {
            cordova.exec(s, f, "GameCenterPlugin", "reportScore", [category, score]);
        },
    
        showAchievements: function() {
            cordova.exec(null, null, "GameCenterPlugin", "showAchievements", []);
        },
    
        reportAchievement: function(category, s, f) {
            cordova.exec(s, f, "GameCenterPlugin", "reportAchievementIdentifier", [category, 100]);
        },
     
        _viewDidShow: function() {
            if (typeof this.onshow === 'function') { this.onshow(); }
        },
     
        _viewDidHide: function() {
            if (typeof this.onhide === 'function') { this.onhide(); }
        }
    };
    
    
    var gameCenter = new GameCenter();
    module.exports = gameCenter;
