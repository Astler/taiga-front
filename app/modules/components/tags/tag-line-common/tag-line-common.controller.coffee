###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

trim = @.taiga.trim

module = angular.module('taigaCommon')

class TagLineCommonController

    @.$inject = [
        "tgTagLineService"
    ]

    constructor: (@tagLineService) ->
        @.disableColorSelection = false
        @.newTag = {name: "", color: null}
        @.colorArray = []
        @.addTag = false

    checkPermissions: () ->
        hasPermissions = @tagLineService.checkPermissions(@.project.my_permissions, @.permissions)
        return hasPermissions

    isArchived: () ->
        return @.project.archived_code

    _createColorsArray: (projectTagColors) ->
        @.colorArray =  @tagLineService.createColorsArray(projectTagColors)

    displayTagInput: () ->
        @.addTag = true

    hasTag: (name) ->
        normalizedName = trim(name).toLowerCase()

        return _.some @.tags, (tag) ->
            tagName = if _.isArray(tag) then tag[0] else tag
            trim(tagName).toLowerCase() == normalizedName

    availableTagOptions: () ->
        query = trim(@.newTag.name).toLowerCase()

        return _.filter @.colorArray, (tag) =>
            name = tag[0]
            matchesQuery = !query.length || name.toLowerCase().indexOf(query) != -1

            matchesQuery && !@.hasTag(name)

    addNewTag: (name, color) ->
        name = trim(name)

        @.newTag.name = ""
        @.newTag.color = null

        return if not name.length || @.hasTag(name)

        if @.disableColorSelection
            @.onAddTag({name: name, color: color}) if name.length
        else
            if @.project.tags_colors[name]
                color = @.project.tags_colors[name]
            @.onAddTag({name: name, color: color})

    selectColor: (color) ->
        @.newTag.color = color

module.controller("TagLineCommonCtrl", TagLineCommonController)
