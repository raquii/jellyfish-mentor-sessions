# Week 12: Authorization and Role-Based Access Control

- [Week 12: Authorization and Role-Based Access Control](#week-12-authorization-and-role-based-access-control)
  - [Authorization: Role-Based Access Control](#authorization-role-based-access-control)
    - [ActiveRecord::Enums](#activerecordenums)
    - [Adding RBAC to Our App](#adding-rbac-to-our-app)
      - [Define the Enum in the `User` Model](#define-the-enum-in-the-user-model)
      - [Using the Enum](#using-the-enum)
    - [Role-Based Access in Controllers](#role-based-access-in-controllers)
  - [Restricting Who Can Do What To What](#restricting-who-can-do-what-to-what)
    - [Add a Helper Method](#add-a-helper-method)
    - [Use the Helper in Views to Protect Rendering](#use-the-helper-in-views-to-protect-rendering)
    - [Protect Controller Actions](#protect-controller-actions)
  - [RBAC-Related Ruby Gems](#rbac-related-ruby-gems)

## Authorization: Role-Based Access Control

Once users are authenticated, the next critical step is **authorization** — determining what each user is allowed to do within your application. A common and scalable approach to managing permissions is **Role-Based Access Control** (RBAC).

RBAC organizes users into roles (such as `admin`, `editor`, or `viewer`), and assigns permissions to those roles rather than to individual users. This makes it easier to manage access across large systems, reduce duplication, and enforce consistent security policies.

### [ActiveRecord::Enums](https://api.rubyonrails.org/classes/ActiveRecord/Enum.html)

An **enum** in Rails is a way to map symbolic names (like `:admin`, `:user`, `:guest`) to integer values in the database. This lets you store compact data (as integers) while working with meaningful labels in your application code.

Given this in a model:

```ruby
enum role: { user: 0, admin: 1 }
```

Rails provides:

1. Predicate methods:
   `user.admin?` → `true` or `false`

2. Setter and getter:
   `user.role = :admin`
   `user.role` → `"admin"`

3. Scopes:
   `User.admin` → all users with the admin role

---

### Adding RBAC to Our App

Generate a migration:

```bash
rails generate migration AddRoleToUsers role:integer
```

Then run the migration:

```bash
rails db:migrate
```

#### Define the Enum in the `User` Model

Open `app/models/user.rb` and add:

```ruby
class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
end
```

This defines named roles that are stored as integers in the database.

#### Using the Enum

You can now use enum helpers:

```ruby
user = User.create(role: :user)

user.admin?    # => false
user.user?   # => true

user.role      # => "user"
user.role = :admin
user.save
```

Scopes are also available:

```ruby
User.admin    # returns all admin users
User.user   # returns all user users
```

### Role-Based Access in Controllers

Use conditionals to restrict access:

```ruby
before_action :require_admin

def require_admin
  redirect_to root_path unless current_user&.admin?
end
```

## Restricting Who Can Do What To What

In a typical Rails app with User and Post models, we want to apply role-based and ownership-based access control. A user should only be able to edit or delete a post if they:

1. are an admin, or
2. are the author of that post

We want to guard against that, and leverage our RBAC at the same time.

### Add a Helper Method

**Helper methods** in Rails are methods used to extract reusable logic for views. They make your view templates cleaner, more readable, and easier to maintain.

Rails encourages keeping business logic in models and controllers, and keeping views as simple as possible. When you find logic creeping into your views (like conditionals, formatting, or permission checks), it's a good candidate for a helper method.

By default, Rails includes:

- `app/helpers/application_helper.rb` – shared across all views
- Controller-specific helpers, like `posts_helper.rb` for views related to `PostsController`

We are going to add an method to `PostsHelper` to control access to the management-tasks for `Posts`

```ruby
# app/helpers/posts_helper.rb
module PostsHelper
  def can_manage_post?(user, post)
    user&.admin? || post.user_id == user&.id
  end
end
```

This method returns true if the user is an admin or the author of the post.

### Use the Helper in Views to Protect Rendering

In post card view, we will wrap the edit/delete links with the permission check:

```ruby
# app/views/posts/_post_card.html.erb
<% if can_manage_post?(current_user, post) %>
  <div class="post-actions">
    <%= link_to "Edit", edit_post_path(post), class: 'button' %>
    <%= link_to "Delete", post_path(post), data: { turbo_method: :delete }, class: 'button delete' %>
  </div>
<% end %>
```

### Protect Controller Actions

In addition to protecting our views, we also need to protect our endpoints. This ensures that unauthorized users can’t access restricted actions by bypassing the UI.

```ruby
# app/controllers/posts_controller.rb
before_action :set_post, only: [:edit, :update, :destroy]
before_action :authorize_post!, only: [:edit, :update, :destroy]

private

def authorize_post!
  unless current_user&.admin? || @post.user_id == current_user&.id
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end
end
```

## RBAC-Related Ruby Gems

- [cancancan](https://github.com/CanCanCommunity/cancancan)
- [Pundit](https://github.com/varvet/pundit)