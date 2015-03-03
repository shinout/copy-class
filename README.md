# copy-class

copy class in CoffeeScript

(which means "copy constructor in JavaScript")



## installation

```bash
npm install copy-class
```


## usage

```coffee

class OriginalClass
    @staticProp: 123

    instanceMethod: ->
        return 'hello'

AnotherClass = require('copy-class').copy(OriginalClass, 'AnotherClass')
AnotherClass.prototype.instanceMethod = ->
    return 'another hello'


new OriginalClass().instanceMethod() # hello
new AnotherClass().instanceMethod() # another hello
```

the second argument of copy is the constructor name.

By default it is the original class name. ('OriginalClass' in this example)


## when to use this???

The time when you want to add some features to already-existing class without changing the name of the class.
It's very rare case, but Remember me when you want to use me.

### vs extends
extends cannot set the same constructor name.


## performance

tested with 100 static props and 100 instance methods:

1. class creation is almost the same as "extends"
2. instance creation is almost the same as "extends"

you can try benchmark by
```bash
$ cake benchmark
```
