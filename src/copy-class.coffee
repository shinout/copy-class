
getProto = Object.getPrototypeOf ? (obj) -> obj.__proto__


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


        # copy static properties
        for own key, value of originalClass
            newClass[key] = value


        # copy instance properties
        F = ->
        F:: = getProto originalClass.prototype
        newClass:: = new F()
        newClass::[k] = v for own k,v of originalClass.prototype
        newClass.prototype.constructor = newClass


        return newClass


module.exports = copyClass
