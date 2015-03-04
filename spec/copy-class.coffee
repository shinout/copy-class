
assert = require 'power-assert'

copyClass = require '../src/copy-class'

describe 'copy-class', ->
    describe 'copy', ->

        class ParentClass

            constructor: ->
                @parentConstructed = true

            @staticProp: 1
            @staticPropToBeOverridden: 'parent'
            @staticObjPropInParent:
                key: 'value'

            instanceProp: 1
            instanceMethod: ->
                return 'instanceMethodInParent'

            instanceMethodToBeOverridden: ->
                return 12


        class OriginalClass extends ParentClass

            constructor: ->
                super()
                @originalConstructed = true

            @originalStaticProp: 2
            @staticPropToBeOverridden: 'original'
            @staticObjProp:
                key: 'originalValue'

            instanceMethodToBeOverridden: ->
                return @title

            originalInstanceMethod: ->
                return 'originalInstanceMethod'


        it 'has the name the same as orignal by default', ->
            ClonedClass = copyClass.copy(OriginalClass)
            assert(ClonedClass.name is 'OriginalClass')

        it 'can set name with the second argument', ->
            ClonedClass = copyClass.copy(OriginalClass, 'abcd')
            assert(ClonedClass.name is 'abcd')


        it 'has original Class\'s own static properties', ->
            ClonedClass = copyClass.copy(OriginalClass)

            assert(ClonedClass.originalStaticProp is 2)
            assert(ClonedClass.staticPropToBeOverridden is 'original')
            assert(ClonedClass.staticObjProp.key is 'originalValue')
            assert(ClonedClass.staticObjProp is OriginalClass.staticObjProp)


        it 'calls constructors (parent and original)', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()
            assert(obj.parentConstructed is true)
            assert(obj.originalConstructed is true)


        it 'copies prototypes of original class', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()
            obj.title = 'hello'

            assert(obj.originalInstanceMethod() is 'originalInstanceMethod')
            assert(obj.instanceMethodToBeOverridden() is 'hello')

        it 'inherits prototypes of parent class', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()
            obj.title = 'hello'

            assert(obj.instanceProp is 1)
            assert(obj.instanceMethod() is 'instanceMethodInParent')


        it 'inherits prototypes of parent class', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()
            obj.title = 'hello'

            assert(obj.instanceProp is 1)
            assert(obj.instanceMethod() is 'instanceMethodInParent')


        it 'can define new static props', ->
            ClonedClass = copyClass.copy(OriginalClass)
            ClonedClass.foo = 'bar'
            assert(ClonedClass.foo is 'bar')
            assert(OriginalClass.foo is undefined)


        it 'can override static props', ->
            ClonedClass = copyClass.copy(OriginalClass)
            ClonedClass.originalStaticProp = 123
            assert(ClonedClass.originalStaticProp is 123)
            assert(OriginalClass.originalStaticProp isnt 123)


        it 'can override instance props', ->
            ClonedClass = copyClass.copy(OriginalClass)
            ClonedClass::originalInstanceMethod = ->
                return 'hello'

            obj = new ClonedClass()

            assert(obj.originalInstanceMethod() is 'hello')

            orig = new OriginalClass()
            assert(orig.originalInstanceMethod() isnt 'hello')


        it 'has constructor', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()

            assert(obj.constructor is ClonedClass)

            orig = new OriginalClass()
            assert(orig.constructor is OriginalClass)


        it 'has constructor which is not enumerable', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj  = new ClonedClass()
            orig = new OriginalClass()
            assert(ClonedClass.prototype.propertyIsEnumerable 'constructor')
            assert(OriginalClass.prototype.propertyIsEnumerable 'constructor')
            assert(not obj.propertyIsEnumerable 'constructor')
            assert(not orig.propertyIsEnumerable 'constructor')


        it 'has the same keys as original object', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj = new ClonedClass()
            orig = new OriginalClass()

            assert(Object.keys(obj).length is Object.keys(orig).length)


        it 'prototype has the same key-value', ->
            ClonedClass = copyClass.copy(OriginalClass)
            assert Object.keys(ClonedClass.prototype).length is Object.keys(OriginalClass.prototype).length


        it 'is not an instance of original class', ->
            ClonedClass = copyClass.copy(OriginalClass)
            obj  = new ClonedClass()

            assert obj instanceof ClonedClass
            assert obj not instanceof OriginalClass

        it 'not class of original object', ->
            ClonedClass = copyClass.copy(OriginalClass)
            orig = new OriginalClass()
            assert orig instanceof OriginalClass
            assert orig not instanceof ClonedClass
