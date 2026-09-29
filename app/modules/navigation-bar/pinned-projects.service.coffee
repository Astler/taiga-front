###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
###

class PinnedProjectsService
    @.$inject = [
        "tgResources"
        "$tgStorage"
        "$q"
    ]

    constructor: (@resources, @storage, @q) ->
        @key = "pressf-pinned-projects"
        @ids = []
        @loaded = false

    _normalize: (ids) ->
        normalized = _.map ids or [], (id) -> parseInt(id, 10)
        return _.uniq(_.filter(normalized, (id) -> !_.isNaN(id)))

    _storeLocal: () ->
        @storage.set(@key, @ids)

    load: () ->
        return @q.when(@ids) if @loaded

        @loaded = true
        @ids = @_normalize(@storage.get(@key))

        return @resources.user.getUserStorage(@key)
            .then (ids) =>
                @ids = @_normalize(ids)
                @_storeLocal()
                return @ids
            .catch () => @ids

    getIds: () ->
        return @ids

    isPinned: (projectId) ->
        return parseInt(projectId, 10) in @ids

    toggle: (projectId) ->
        projectId = parseInt(projectId, 10)

        if @isPinned(projectId)
            @ids = _.without(@ids, projectId)
        else
            @ids.push(projectId)

        @_storeLocal()

        return @resources.user.setUserStorage(@key, @ids)
            .catch () => @resources.user.createUserStorage(@key, @ids)
            .catch () -> null

angular.module("taigaNavigationBar").service("tgPinnedProjectsService", PinnedProjectsService)
