# Week 2: Ruby and Rails Basics: Method Naming, Classes, Relationships, and SQL

- [Week 2: Ruby and Rails Basics: Method Naming, Classes, Relationships, and SQL](#week-2-ruby-and-rails-basics-method-naming-classes-relationships-and-sql)
  - [Method Naming Conventions in Ruby](#method-naming-conventions-in-ruby)
    - [Methods Ending in `!`](#methods-ending-in-)
      - [Example](#example)
    - [Methods Ending in `?`](#methods-ending-in--1)
      - [Example](#example-1)
  - [Classes and Instances: A Review](#classes-and-instances-a-review)
    - [What is a Class?](#what-is-a-class)
    - [What is an Instance?](#what-is-an-instance)
  - [Modeling Relationships in Rails](#modeling-relationships-in-rails)
    - [Common Association Types](#common-association-types)
      - [`belongs_to`](#belongs_to)
      - [`has_many`](#has_many)
  - [SQL: Structured Query Language](#sql-structured-query-language)
    - [Key Concepts](#key-concepts)
    - [What SQL Is Used For](#what-sql-is-used-for)
  - [Rails vs SQL](#rails-vs-sql)
    - [Create a table](#create-a-table)
    - [Create records](#create-records)
    - [Update records](#update-records)

## Method Naming Conventions in Ruby

Ruby uses special naming conventions for certain types of methods to communicate their behavior more clearly.

### Methods Ending in `!`

* A method ending in an exclamation mark (`!`) is often referred to as a **destructive method**.
* These methods typically perform the same operation as their non-bang counterparts but with additional side effects:

  * They may modify the object in-place (mutation).
  * In Active Record, `!` methods usually **raise errors** when something goes wrong.

#### Example

```ruby
user.save       # Returns false if the user couldn't be saved
user.save!      # Raises ActiveRecord::RecordInvalid if saving fails
```

### Methods Ending in `?`

* Methods ending in a question mark (`?`) are **predicate methods**.
* They return a boolean value (`true` or `false`).

#### Example

```ruby
user.active?    # Returns true if the user is active, otherwise false
```

---

## Classes and Instances: A Review

### What is a Class?

* A class is a **blueprint** or definition for an object.
* In Rails, a class corresponds to a **table** in the database.

```ruby
class User < ApplicationRecord
end
```

### What is an Instance?

* An instance (also called an object) is a **realized version** of a class.
* In Rails, each instance corresponds to a **row** in the database table.

```ruby
user = User.new(name: "Alice")
```

---

## Modeling Relationships in Rails

Relationships describe how rows in one table relate to rows in another. This is also known as **cardinality**.

* Relationships are often visualized with **Entity-Relationship Diagrams (ERDs)**.
* In Rails, these relationships are expressed using Active Record associations.

### Common Association Types

#### `belongs_to`

Indicates a one-to-many relationship. The model with `belongs_to` holds the foreign key.

```ruby
class Comment < ApplicationRecord
  belongs_to :post
end
```

#### `has_many`

Indicates the inverse of `belongs_to`—a model has many related records.

```ruby
class Post < ApplicationRecord
  has_many :comments
end
```

These associations reflect the cardinality between instances (e.g., one post can have many comments).

---

## SQL: Structured Query Language

SQL is the standard language used to **interact with relational databases**.

### Key Concepts

* SQL allows for the creation, modification, querying, and deletion of data.
* It is used across many relational database systems:
  * SQLite
  * MySQL
  * PostgreSQL (PSQL)
  * Oracle

### What SQL Is Used For

* Creating tables and defining schema
* Inserting, updating, and deleting data
* Querying records using `SELECT`, `WHERE`, `JOIN`, etc.

## Rails vs SQL

Anything Rails can do with our data models, SQL can do natively, because *secretly*, our Rails app is calling SQL for us under the hood!

You can see SQL being performed by your rails app in the log lines that print in the Rails console.

### Create a table

**Rails**:

```ruby
# db/migrate/20250319234716_create_posts.rb

class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :body
      t.timestamps
    end
  end
end
```

**SQL**:

```sql
CREATE TABLE posts (
    id INTEGER PRIMARY KEY
    title TEXT
    body TEXT
    updated_at DATETIME
    created_at DATETIME
);
```

### Create records

**Rails**:

```ruby
Post.create!(title: 'This is a Title', body: 'This is a body')
```

**SQL**:

```sql
INSERT INTO posts ("title", "body", "updated_at", "created_at") VALUES ('This is a Title', 'This is a body', '2025-03-19 00:00:00', '2025-03-19 00:00:00');
```

### Update records

**Rails**:

```ruby
comment = Comment.first
comment.update!(post_id: 2)
```

**SQL**:

```sql
UPDATE "comments" SET "post_id" = 2, "updated_at" = '2025-03-20 00:20:56.993542' WHERE "comments"."id" = 1;
```