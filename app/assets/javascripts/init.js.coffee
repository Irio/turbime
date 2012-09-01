jQuery ->
    body = $(document.body)
    controllerClass = body.data("controller-class")
    controllerName = body.data("controller-name")
    action = body.data("action")

    exec = (controllerClass, controllerName, action) ->
        namespace = App

        if controllerClass
            railsNamespace = controllerClass.split("::").slice(0, -1)
        else
            railsNamespace = []

        for name in railsNamespace
            namespace = namespace[name] if namespace

        if namespace and controllerName
            controller = namespace[controllerName]
            if controller and View = controller[action]
                App.currentView = window.view = new View()

    execFilter = (filterName) ->
        if App.Common and _.isFunction(App.Common[filterName])
            App.Common[filterName]()

    execFilter('init')
    exec(controllerClass, controllerName, action)
    execFilter('finish')

    $.ajaxSetup
        dataType: 'html'

    return
