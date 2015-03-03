

copyClass = 

    copy: (originalClass, name) ->

        # name of the class. default: original class's name
        name ?= originalClass.name ? 'IEdoesNotSupportFunctionName'

        # copy function
        newClass = (new Function("""
            return function (call) {
                return function #{name}() {
                    return call.apply(this, arguments)
                };
            };
        """)())(originalClass)


        # inherit static properties
        for own key, value of originalClass
            newClass[key] = value


        # inherit instance properties
        F = ->
        F.prototype = originalClass.prototype
        newClass.prototype = new F()
        newClass.prototype.constructor = newClass

        return newClass


module.exports = copyClass
