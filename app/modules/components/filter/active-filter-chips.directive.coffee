###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
###

ActiveFilterChipsDirective = () ->
    return {
        scope: {
            filters: "<",
            onRemove: "&"
        },
        bindToController: true,
        controller: angular.noop,
        controllerAs: "vm",
        templateUrl: "components/filter/active-filter-chips.html"
    }

angular.module("taigaComponents").directive("tgActiveFilterChips", [ActiveFilterChipsDirective])
