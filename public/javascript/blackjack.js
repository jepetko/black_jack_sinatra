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
    .controller('PlayCtrl',['$scope', 'Players', 'Dealers', function($scope, Players, Dealers) {
        $scope.players = Players.get();
        $scope.dealer = Dealers.get();
    }]);
})(angular);
