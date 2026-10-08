###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
###

describe "activeFilterChipsDirective", () ->
    scope = compile = null

    beforeEach ->
        module "templates"
        module "taigaComponents"

        inject ($rootScope, $compile) ->
            scope = $rootScope.$new()
            compile = $compile

    it "binds filters to its controller", () ->
        scope.filters = [{key: "tag", name: "Tag", mode: "include"}]
        scope.removeFilter = sinon.spy()

        element = compile(
            "<tg-active-filter-chips filters='filters' on-remove='removeFilter(filter)'></tg-active-filter-chips>"
        )(scope)
        scope.$apply()

        expect(element.isolateScope().vm.filters).to.deep.equal(scope.filters)
