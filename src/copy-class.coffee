
getProto = Object.getPrototypeOf ? (obj) -> obj.__proto__


copyClass = 

    ###*
    copy class

    @method copy
    @param {Function} originalClass
    @param {String} [name] name of the new class (IE does not support)
    @param {Function} [parentClass]
    ###
    copy: (originalClass, name, parentClass) ->

        # name of the class. default: original class's name
        name ?= originalClass.name ? 'IEdoesNotSupportFunctionName'

        args = ('a' + i for i in [1..originalClass.length]).join(', ')

        # copy function
        newClass = (new Function("""
            return function (call) {
                return function #{name}(#{args}) {
                    return call.apply(this, arguments)
                };
            };
        """)())(originalClass)


        # copy static properties
        for own key, value of originalClass
            newClass[key] = value


        # copy instance properties
        F = ->

        if parentClass
            F:: = parentClass.prototype
        else
            F:: = getProto originalClass.prototype

        newClass:: = new F()
        newClass::[k] = v for own k,v of originalClass.prototype
        newClass.prototype.constructor = newClass


        return newClass


module.exports = copyClass
