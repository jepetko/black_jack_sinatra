(function(angular) {
    "use strict";

    angular.module('blackjack',[])
    .controller('NameCtrl', ['$scope', function($scope) {

    }])
    .module('Players', ['$resource', function($resource) {
        return $resource('players/:id', null);
    }])
    .controller('PlayCtrl',['$scope', function($scope) {

    }]);
})(angular);
