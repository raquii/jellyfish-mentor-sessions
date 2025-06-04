
# Week 3: Rails Fundamentals: Associations, Migrations, and Object-Oriented Programming

- [Week 3: Rails Fundamentals: Associations, Migrations, and Object-Oriented Programming](#week-3-rails-fundamentals-associations-migrations-and-object-oriented-programming)
  - [Active Record Associations](#active-record-associations)
    - [Types of Associations](#types-of-associations)
      - [One-to-Many Relationship](#one-to-many-relationship)
      - [One-to-One Relationship](#one-to-one-relationship)
      - [Many-to-Many Relationship](#many-to-many-relationship)
        - [Example: Teachers and Students](#example-teachers-and-students)
        - [Example: Doctors and Patients (Appointments as join table)](#example-doctors-and-patients-appointments-as-join-table)
      - [Polymorphic Relationships](#polymorphic-relationships)
    - [Object Relational Mapper (ORM)](#object-relational-mapper-orm)
  - [Active Record Migrations](#active-record-migrations)
    - [Common Commands](#common-commands)
  - [Object-Oriented Programming (OOP)](#object-oriented-programming-oop)
    - [Building Blocks of OOP](#building-blocks-of-oop)
      - [Abstraction](#abstraction)
      - [Polymorphism](#polymorphism)
      - [Inheritance](#inheritance)
      - [Encapsulation](#encapsulation)
    - [Learn More](#learn-more)

## Active Record Associations

Rails uses **Active Record** to handle database interactions through model classes. Associations allow models to relate to one another, simplifying complex data relationships.

### Types of Associations

#### One-to-Many Relationship

A single record in one model is associated with many records in another.

* **Example**: A `User` has many `Posts`, and each `Post` belongs to a `User`.

```ruby
class User < ApplicationRecord
  has_many :posts
end

class Post < ApplicationRecord
  belongs_to :user
end
```

#### One-to-One Relationship

Each record in a model has exactly one associated record in another model.

* **Example**: A `Person` has one `DriversLicense`.

```ruby
class Person < ApplicationRecord
  has_one :drivers_license
end

class DriversLicense < ApplicationRecord
  belongs_to :person
end
```

#### Many-to-Many Relationship

Records in one model can be associated with many records in another, and vice versa. This typically uses a **join table**.

##### Example: Teachers and Students

* Join table: `students_teachers`

```ruby
class Student < ApplicationRecord
  has_many :students_teachers
  has_many :teachers, through: :students_teachers
end

class Teacher < ApplicationRecord
  has_many :students_teachers
  has_many :students, through: :students_teachers
end

class StudentsTeacher < ApplicationRecord
  belongs_to :student
  belongs_to :teacher
end
```

##### Example: Doctors and Patients (Appointments as join table)

```ruby
class Doctor < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end

class Patient < ApplicationRecord
  has_many :appointments
  has_many :doctors, through: :appointments
end

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
end
```

#### Polymorphic Relationships

Polymorphic associations allow a model to belong to more than one other model using a single association.

* **Example**: A `Comment` can belong to both a `Post` and a `Photo`.

```ruby
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class Post < ApplicationRecord
  has_many :comments, as: :commentable
end

class Photo < ApplicationRecord
  has_many :comments, as: :commentable
end
```

* [More on Polymorphic Associations](https://guides.rubyonrails.org/association_basics.html#polymorphic-associations)

### Object Relational Mapper (ORM)

Active Record is Rails' built-in ORM (Object Relational Mapper), allowing you to interact with the database using Ruby objects.

* Automatically provides methods to:

  * Query the database (`.find`, `.where`, `.first`)
  * Work with associations (`user.posts`, `post.user`)
  * Persist changes (`.save`, `.destroy`)

This allows you to avoid raw SQL in most use cases.

---

## Active Record Migrations

Migrations are a way to version-control your database schema. They allow you to create, update, and rollback changes to your schema using Ruby.

### Common Commands

* Run pending migrations:

  ```bash
  bin/rails db:migrate
  ```

* Rollback the last migration:

  ```bash
  bin/rails db:rollback
  ```

* Generate a new migration:

  ```bash
  bin/rails generate migration AddColumnToTable
  ```

* Generate a model:

  ```bash
  bin/rails generate model ModelName attribute:type
  ```

* Generate a scaffold (model, controller, views, and migration):

  ```bash
  bin/rails generate scaffold ResourceName attribute:type
  ```

Migrations are database-agnostic, making it easy to work across environments.

---

## Object-Oriented Programming (OOP)

Ruby is a fully object-oriented language. Rails leverages this by using OOP principles extensively.

### Building Blocks of OOP

#### Abstraction

Hides complex implementation details and exposes only what’s necessary through a clean interface.

* **Example**: Calling `.save` on a model without needing to know the underlying SQL.

#### Polymorphism

Allows objects of different classes to respond to the same method call in ways specific to their class.

* **Example**: A `commentable` could be a `Post` or `Photo`, both responding to `.title`.

#### Inheritance

Classes can inherit behavior and attributes from other classes.

```ruby
class Animal
  def speak
    "Hello"
  end
end

class Dog < Animal
  def speak
    "Woof"
  end
end
```

#### Encapsulation

Restricts direct access to some of an object's internal state and behavior.

* Keeps implementation details hidden, typically using getters and setters.

```ruby
class Account
  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def balance
    @balance
  end
end
```

### Learn More

* [Introduction to Object Oriented Programming](https://www.geeksforgeeks.org/introduction-of-object-oriented-programming)
