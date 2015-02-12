(function(angular) {
    "use strict";

    angular.module('blackjack',['ngResource'])
    .controller('NameCtrl', ['$scope', function($scope) {

    }])
    .factory('Players', ['$resource', function($resource) {
        return $resource('players.json/:id', null, {'get': {'isArray': true}});
    }])
    .controller('PlayCtrl',['$scope', '$http', 'Players', function($scope, $http, Players) {
        $scope.areFirstCardsGiven = function() {
            var firstPlayer = $scope.players[0];
            if(!firstPlayer) {
                return false;
            }
            return firstPlayer.cards && firstPlayer.cards.length >= 0;
        };
        $scope.canPlayerDraw = function(player) {
            return player.cards && player.cards.length >= 2 && player.busted === false;
        };
        $scope.isGameOver = function() {
            if(this.lastResponse != null) {
                if(this.lastResponse.state === 'done') {
                    return true;
                }
            }
            return false;
        };
        $scope.buildCardPath = function(card) {
            return 'images/cards/' + (card.sort + '_' + card.type + '.jpg').toLowerCase();
        };
        $scope.kickOff = function() {
            $http.get('/start')
            .success(function(data, status, headers, config) {
                $scope.lastResponse = data;
                $scope.init();
            });
        };
        $scope.replay = function() {
            if(typeof $scope.ownName !== 'undefined') {
                $scope.lastResponse = null;
                $http.get('/replay')
                .success(function(data,status,headers,config) {
                    $scope.init();
                });
            }
        };
        $scope.draw = function(answer) {
            $http.get('/draw', {params: {answer: answer}})
            .success(function(data, status, headers, config) {
                $scope.lastResponse = data;
                $scope.init();
            });
        };
        $scope.init = function() {
            $scope.players = Players.get();
        };
        $scope.init();
    }]);
})(angular);
