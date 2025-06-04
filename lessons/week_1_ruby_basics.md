# Week 1: An Introduction to Ruby

- [Week 1: An Introduction to Ruby](#week-1-an-introduction-to-ruby)
  - [Variables in Ruby](#variables-in-ruby)
    - [Type Safety in Ruby](#type-safety-in-ruby)
  - [Outputting to the Console](#outputting-to-the-console)
  - [String Interpolation](#string-interpolation)
  - [Ruby Methods](#ruby-methods)
    - [What is a Method?](#what-is-a-method)
    - [Declaring Methods](#declaring-methods)
    - [Method Invocation](#method-invocation)
    - [Default Arguments](#default-arguments)
    - [Implicit Return](#implicit-return)
  - [Scope in Ruby](#scope-in-ruby)
  - [Ruby Blocks](#ruby-blocks)
  - [Classes](#classes)
  - [Instances](#instances)

## Variables in Ruby

We can declare and assign a variable in Ruby like so:

```ruby
first_variable = 7
```

That's it. There is no `const`, `let`, or `var`.

Note the naming convention for Ruby variables use ***snake case***, where words are separated with an underscore (`_`).

### Type Safety in Ruby

Similar to JavaScript, Ruby is a **dynamically-typed language**, meaning variables can change their data type at runtime and these types do not need to be explicitly defined.

However, unlike JavaScript, Ruby data types will not be implicitly coerced into other data types, and will raise errors when attempting to perform operations on inappropriate data types. You may hear this referred to as Ruby being **"strongly typed"**.

Compare the following identical operation in each language:

**JavaScript**:

```js
// dynamic reassignment of a variable to a different data type
let num = 1
num = "one"
// loose typing allows an integer to be coerced to a string
console.log(num + 1)
// => "one1"
```

**Ruby**:

```ruby
# dynamic reassignment of a variable to a different data type
num = 1
num = "one"
# raises an error because you can't add a string to an integer
puts num + 1
#=>:2:in `+': no implicit conversion of Integer into String (TypeError)
```

## Outputting to the Console

In ruby, there is no `console.log`. Instead, the `puts` and `print` methods output values to the console.

The difference between them being that the `puts` method adds a new line to the end:

```ruby
2.times { puts "Hello World!" }
# > Hello World!
# > Hello World!
2.times { print "Hello World!" }
# > Hello World!Hello World!
```

## String Interpolation

In JavaScript, we do string interpolation using backticks and dollar sign:

```js
let name = "Maria"
console.log(`Hello, ${name}.`)
// => Hello, Maria.
```

In Ruby, string interpolation uses double quotes and a hash symbol:

```ruby
name = "Maria"
puts "Hello, #{name}."
# => Hello, Maria.
```

## Ruby Methods

### What is a Method?

A **function** is a set of instructions for a task.

A **method** is also a set of instructions for a task, associated with an object.

Since Ruby is an object-oriented programming language and *everything* is an object, Ruby only has **methods**!

### Declaring Methods

Methods are declared with the keyword `def`:

```ruby
def say_hello
  puts "Hello"
end
```

Like other blocks in Ruby, methods are closed with the `end` keyword.

### Method Invocation

In JavaScript, we are required to include parenthesis when invoking a function or method

```js
function sayHello() {
  console.log('Hello!')
}

sayHello()
// => Hello!
```

In Ruby, parenthesis to invoke methods are optional, provided that the argument is the last thing on the line. In fact, when a method has no arguments, using parenthesis goes against Ruby convention!

```ruby
def say_hello
  puts "Hello!"
end

say_hello
# => Hello!
```

So, while this is technically valid:

```ruby
say_hello()
```

It is best avoided in Ruby.

On the other hand, when a method takes parameters, omitting the parenthesis is unconventional, as it often makes the code more difficult to read.

```ruby
def say_hello_to(name)
  puts "Hello, #{name}!"
end

say_hello_to("Maria")
# => Hello, Maria!
```

There are occasional exceptions to this standard, one of which you have seen many times in this lesson already: `puts`!

`puts` is a method that is often invoked without wrapping its argument(s) in parenthesis, and you may encounter other examples of this approach in your journey into Ruby, so while we recommend you stick to conventional style, it's good to understand that the option exists.

### Default Arguments

To define a method that optionally takes an argument, we can assign a default value to the parameter:

```ruby
def say_hello(name = "Friend")
  puts "Hello, #{name}"
end

say_hello("Maria")
# => "Hello, Maria"
say_hello
# => "Hello, Friend"
```

### Implicit Return

In Ruby, everything has a return value. This is known as **Implicit Return**.

For variables, their return value is the value they store:

```ruby
num = 1
# => 1
str = "Hello"
# => "Hello"
```

Methods return the *value of their last statement*:

```ruby
def add(x,y)
  x + y
end

add(1,1)
# => 2
```

The `return` keyword does exist in Ruby, but it should only be used when you need to **explicitly return** from somewhere else in a method.

The most common use-case for explicit return is in a **Guard Clause**-- a statement that *guards* the rest of a method from evaluating by immediately `return`ing, based on the result of a conditional statement:

```ruby
def add(x,y)
  # returns nil if x or y is something other than an integer
  return unless x.is_a?(Integer) && y.is_a?(Integer)

  x + y
end

add("dog", 2)
# => nil
```

Implicit return is a rather unique part of the Ruby language and it can be easy to write methods that are returning something unexpected. Take a look at this example:

```ruby
my_dog = {
  name: "Sombra",
  age: 12
}

def update_age(dog_hash)
  dog_hash[:age] += 1
end

update_age(my_dog)
```

What do you think `update_age` returns? Try it out in `irb` to see if you were right.

## Scope in Ruby

In programming, **Scope** is a concept to describe the visibility of objects: What other objects (variables, methods, instances) have access to a specific object and its data. In Ruby, there are four types of scope:

- Global-level
- Class-level
- Instance-level
- Local-level

We will talk more about class and instance variables later in this lesson.

## Ruby Blocks

A **Block** is an encapsulated piece of code. In Ruby, we declare multi-line blocks with `do...end`:

```ruby
3.times do
  puts "hello, from a multi-line block!"
end
```

Single-line blocks are defined with curly brackets instead of `do...end`:

```ruby
3.times { puts "hello, from a single-line block." }
```

Block arguments are passed between pipe (`|`) characters:

```ruby
string_array = ["first", "second", "third"]

string_array.each do |str|
  puts str
end
```

Blocks can receive multiple arguments:

```ruby
num_array = [1, 2, 3]

num_array.each_with_index do |element, index|
  puts "#{element} is at #{index} in num_array"
end
```

A method can even explicitly accept a block as a parameter:

```ruby
def greet(&block)
  puts "Before block execution"
  block.call("Hello from the block!")  # Calling the block
  puts "After block execution"
end

greet do |message|
  puts message  # This is the block passed to the method
end
```

```ruby
my_array = [1, 2, 3, 4, 5, 6]

my_array.each_slice(2) do |first, second|
  puts "First: #{first}, second: #{second}"
end

my_array.each_slice(3) do |first, second, third|
  puts "First: #{first}, second: #{second}, third: #{third}"
end

my_array.map do |element|
  element * 2
end
```

## Classes

A class is like a blueprint that defines how to build an object, and has the ability to create those objects.

We define a class with the keyword `class`

```ruby
class Person
end
```

To create an instance (object) of a class, we will use the method `#new`

```ruby
person = Person.new
another_person = Person.new
person.object_id
another_person.object_id
# note that the object_id's are different!
```

## Instances

Let's go a bit deeper.

Classes can define class methods, which are called on the class itself, and instance methods, which are called on instances of that class.

```ruby
class Person
 # class methods are defined with `self.`
  def self.say_hello
  puts "Hello from #{self}."
  end
  # instance method
 def say_hello
   puts "Hello from #{self}."
 end
end
```

Similarly, classes and instances can store variables that are unique to them.

Class variables are less commonly defined and can be tricky to manage, so we will skip them for now.

Instance variables are what make instances feel unique. We define an instance variable in ruby with the `@` prefix:

```ruby
class Person
 # class methods are defined with `self.`
 def self.say_hello
  puts "Hello from #{self}."
 end
 # intialize is a special method in a ruby class that is called by `.new`
 # you can define arguments accepted by `intialize` that you may want to assign to instance variables later
 def initialize(name)
  @name = name
 end
 
 # instance method
 def say_hello
   puts "Hello from #{@name}."
 end
end
```

We can access instance variables inside of instance methods OR through getter/setter methods

```ruby
class Person
 # class methods are defined with `self.`
 def self.say_hello
  puts "Hello from #{self}."
 end
 # intialize is a special method in a ruby class that is called by `.new`
 # you can define arguments accepted by `intialize` that you may want to assign to instance variables later
 def initialize(name)
  @name = name
 end
 
 # getter GETS the value from the instance variable
 def name
  @name
 end
 
 # setter SETS the value to the instance variable
 def name=(name)
  @name = name
 end
 
 # instance method
 def say_hello
   puts "Hello from #{@name}."
 end
end
```

Natively, Ruby provides getters and setters through the macros `attr_reader` (getter-only), `attr_writer`(setter-only), and `attr_accessor` (both)

```ruby
class Person
 # class methods are defined with `self.`
 def self.say_hello
  puts "Hello from #{self}."
 end
 
 attr_accessor :name
 
 # intialize is a special method in a ruby class that is called by `.new`
 # you can define arguments accepted by `intialize` that you may want to assign to instance variables later
 def initialize(name)
  @name = name
 end
 
 # instance method
 def say_hello
   puts "Hello from #{@name}."
 end
end
```
