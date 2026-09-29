###
# This source code is licensed under the terms of the
# GNU Affero General Public License found in the LICENSE file in
# the root directory of this source tree.
#
# Copyright (c) 2021-present Kaleidos INC
###

DropdownProjectListDirective = (rootScope, currentUserService, projectsService, projectService, pinnedProjectsService) ->
    link = (scope, el, attrs, ctrl) ->
        scope.vm = {}

        scope.vm.pinnedProjects = Immutable.List()
        scope.vm.projects = Immutable.List()
        scope.vm.hasProjects = false

        refreshProjects = ->
            projects = currentUserService.projects.get("all") or Immutable.List()

            scope.vm.pinnedProjects = projects.filter (project) ->
                pinnedProjectsService.isPinned(project.get("id"))

            scope.vm.projects = projects.filter (project) ->
                !pinnedProjectsService.isPinned(project.get("id"))

            scope.vm.hasProjects = projects.size > 0

        pinnedProjectsService.load().then refreshProjects

        taiga.defineImmutableProperty(scope.vm, "currentProject",
            () ->
                if projectService.project
                    return projectService.project.get('id')

                return null
        )

        scope.vm.newProject = ->
            projectsService.newProject()

        scope.vm.isPinned = (project) ->
            return pinnedProjectsService.isPinned(project.get("id"))

        scope.vm.togglePinned = (project, event) ->
            event.preventDefault()
            event.stopPropagation()

            pinnedProjectsService.toggle(project.get("id"))
            refreshProjects()

        updateLinks = ->
            el.find(".dropdown-project-list ul li a").data("fullUrl", "")

        rootScope.$on "dropdown-project-list:updated", ->
            refreshProjects()
            updateLinks()

    directive = {
        templateUrl: "navigation-bar/dropdown-project-list/dropdown-project-list.html"
        scope: {
            active: "="
        }
        link: link
    }

    return directive

DropdownProjectListDirective.$inject = [
    "$rootScope",
    "tgCurrentUserService",
    "tgProjectsService",
    "tgProjectService",
    "tgPinnedProjectsService"
]

angular.module("taigaNavigationBar").directive("tgDropdownProjectList", DropdownProjectListDirective)
