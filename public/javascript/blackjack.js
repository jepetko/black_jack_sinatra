(function(angular) {
    "use strict";

    angular.module('blackjack',['ngResource'])
    .controller('NameCtrl', ['$scope', function($scope) {

    }])
    .factory('Players', ['$resource', function($resource) {
        return $resource('players.json/:id', null, {'get': {'isArray': true}});
    }])
    .factory('Dealers', ['$resource', function($resource) {
        return $resource('dealers.json/:id', null);
    }])
    .controller('PlayCtrl',['$scope', '$http', 'Players', 'Dealers', function($scope, $http, Players, Dealers) {
        $scope.kickOff = function() {
            $http.get('/start')
            .success(function(data, status, headers, config) {
                $scope.init();
            });
        };
        $scope.draw = function(answer) {
            $http.get('/draw', {params: {answer: answer}})
            .success(function(data, status, headers, config) {
                $scope.init();
            });
        };
        $scope.init = function() {
            $scope.players = Players.get();
            $scope.dealer = Dealers.get();
        };
        $scope.init();
    }]);
})(angular);
