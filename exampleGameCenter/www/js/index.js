/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready')
        // NOTE: You ** MUST ** successfully authenticate before making any other game center calls
        window.gameCenter.onshow = function() { console.log("gamecenter triggered onshow!" ); };
        window.gameCenter.onhide = function() { console.log("gamecenter triggered onhide!" ); };
        window.gameCenter.authenticate( app.authSuccess, app.authFailure );
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },
    
    // -------------------------------------
    // BEGIN Game Center sample code
    // -------------------------------------
    scoreSuccess: function() {
        window.gameCenter.showLeaderboard("MY_GAME_LEADERBOARD_ID");
        console.log("GameCenter score reported");
    },
    
    scoreFailure: function(result) {
        console.log("GameCenter score failure:\n" + result);
    },
     
    achievementSuccess: function() {
        window.gameCenter.showAchievements();
        console.log("GameCenter get achievement success");
    },
     
    achievementFailure: function(result) {
        console.log("GameCenter get achievement failure:\n" + result);
    },
     
    authSuccess: function() {
        console.log("GameCenter Authentication success");
        window.gameCenter.reportScore("MY_GAME_LEADERBOARD_ID", 345, app.scoreSuccess, app.scoreFailure);
        //window.gameCenter.reportAchievement("MAGICAL_STAR_ACHIEVEMENT_ID", app.achievementSuccess, app.achievementFailure);
        //window.gameCenter.reportAchievement("FIREBALL_ACHIEVEMENT_ID", app.achievementSuccess, app.achievementFailure);
    },
    
    authFailure: function(result) {
        console.log("GameCenter Authentication failure:\n" + result + "\nPlease sign in using the Game Center application");
    }
    // -------------------------------------
    // END Game Center sample code
    // -------------------------------------
};
