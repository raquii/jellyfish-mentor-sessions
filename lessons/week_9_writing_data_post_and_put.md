# Week 9: Writing Data with POST and PUT, Using Partials and Forms, and Validations

- [Week 9: Writing Data with POST and PUT, Using Partials and Forms, and Validations](#week-9-writing-data-with-post-and-put-using-partials-and-forms-and-validations)
  - [Writing Data: `POST` and `PUT`](#writing-data-post-and-put)
  - [Forms, Partials](#forms-partials)
    - [Creating a Form](#creating-a-form)
    - [Using Partials](#using-partials)
  - [Validations](#validations)

## Writing Data: `POST` and `PUT`

- `POST` - used to create a resource (`#create` action)
- `PUT` - used to edit a resource (`#update` action)

## Forms, Partials

### Creating a Form

```ruby
# app/views/posts/new.html.erb

<h1 class="page-title">New Post</h1>
<%= form_with model: @post, html: { class: "post-form" } do |form| %>
  <div class="form-group">
    <%= form.label :title, class: "form-label" %>
    <%= form.text_field :title, class: "form-input" %>
  </div>

  <div class="form-group">
    <%= form.label :body, class: "form-label" %>
    <%= form.text_area :body, rows: 6, class: "form-input" %>
  </div>

  <div class="form-actions">
    <%= form.submit "Save Post", class: "form-submit" %>
  </div>
<% end %>
```

### Using Partials

Partials are reusable view fragments that allow us to keep our view files DRY *(Don't Repeat Yourself)*.

To create a partial, generate a view file that is prefixed with an `_` underscore, eg. `app/views/posts/_form.html.erb`

```ruby
# app/views/posts/_form.html.erb

<%= form_with model: @post, html: { class: "post-form" } do |form| %>
  <div class="form-group">
    <%= form.label :title, class: "form-label" %>
    <%= form.text_field :title, class: "form-input" %>
  </div>

  <div class="form-group">
    <%= form.label :body, class: "form-label" %>
    <%= form.text_area :body, rows: 6, class: "form-input" %>
  </div>

  <div class="form-actions">
    <%= form.submit "Save Post", class: "form-submit" %>
  </div>
<% end %>
```

To include a partial in a view, use the `#render` method

```ruby
# app/views/posts/new.html.erb
<h1 class="page-title">New Post</h1>
<%= render "form" %>
```

Your partial can receive local variables, called `locals`, as a hash:

```ruby
# app/views/posts/show.html.erb

<h1 class="page-title"><%= @post %></h1>
<%= render partial: "post_card", locals: { post: @post } %>
<%= link_to "Edit", edit_post_path(@post) %>
```

## Validations

- Resource: [ActiveRecord Validations](https://guides.rubyonrails.org/active_record_validations.html)

**Active Record validations** are built-in ActiveRecord mechanisms that help ensure only valid data is saved to your database. They are defined in your model classes (e.g., `Post`, `User`) and automatically run before `#create`, `#update`, or `#save`.

Without validations, you might save records with missing or incorrect data (e.g. an empty title).

```ruby
class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end
```
