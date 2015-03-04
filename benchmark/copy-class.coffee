copy = require('../src/copy-class').copy

class OriginalClass

nStaticProps = 10
nInstanceMethods = 10

i = 0
while i < nStaticProps
    OriginalClass['prop' + i] = i++

i = 0
while i < nInstanceMethods
    OriginalClass::['method' + (i++)] = -> 'str'


N = 10000
times = [0..N]

# class generation
console.time 'class-generation:extends'
for i in times
    class abc extends OriginalClass
console.timeEnd 'class-generation:extends'

console.time 'class-generation:copy'
for i in times
    abc = copy OriginalClass
console.timeEnd 'class-generation:copy'

# instance generation
ClonedClass = copy OriginalClass
class ExtendedClass extends OriginalClass


N = 1000000
times = [0..N]

console.time 'instance-generation:original'
for i in times
    obj = new OriginalClass()
console.timeEnd 'instance-generation:original'

console.time 'instance-generation:extends'
for i in times
    obj = new ExtendedClass()
console.timeEnd 'instance-generation:extends'

console.time 'instance-generation:copy'
for i in times
    obj = new ClonedClass()
console.timeEnd 'instance-generation:copy'



