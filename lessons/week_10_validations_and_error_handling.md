# Week 10: Validations and Error Handling

- [Week 10: Validations and Error Handling](#week-10-validations-and-error-handling)
  - [Validations Review](#validations-review)
  - [Error Handling](#error-handling)
    - [Error Handling with `begin` / `rescue`](#error-handling-with-begin--rescue)
      - [Optional: `else` and `ensure`](#optional-else-and-ensure)
    - [Raising Exceptions](#raising-exceptions)
    - [Error Handling in Controllers](#error-handling-in-controllers)
    - [Rendering Errors to Users](#rendering-errors-to-users)
      - [Model#errors](#modelerrors)
      - [ActionDispatch::Flash](#actiondispatchflash)
      - [Hotwire/Turbo Error Rendering Problems](#hotwireturbo-error-rendering-problems)

## Validations Review

- What is the difference between `#create` and `#create!`?
- Adding validations to our models
- Validator methods
  - `#valid?`
  - `#save?`
- [`ActiveModel::Dirty`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html)

## Error Handling

### Error Handling with `begin` / `rescue`

Ruby provides built-in exception handling using a `begin` block followed by one or more `rescue` clauses. This allows you to handle runtime errors gracefully.

```ruby
begin
  # Code that might raise an error
rescue SomeErrorClass => e
  # Code that runs if that specific error occurs
end
```

You can handle different types of exceptions separately:

```ruby
begin
  risky_operation
rescue ArgumentError
  puts "There was an argument error."
rescue RuntimeError
  puts "There was a runtime error."
rescue => e
  puts "Some other error occurred: #{e.class} - #{e.message}"
end
```

In this example, if none of the earlier specific errors match, the final `rescue => e` clause catches any other kind of exception.

#### Optional: `else` and `ensure`

`else` runs if no exceptions are raised, while `ensure` always runs, whether an exception occurs or not.

```ruby
begin
  puts "Trying something..."
  # code here
rescue => e
  puts "Error: #{e.message}"
else
  puts "No errors encountered."
ensure
  puts "This will always run."
end
```

Ruby implicitly wraps the body of a method in a `begin ... end` block behind the scenes, so you don't need to add `begin` to `rescue` inside a method:

```ruby
def divide(a, b)
  result = a / b
rescue ZeroDivisionError
  puts "You can't divide by zero."
end
```

### Raising Exceptions

You can raise an exception manually using `raise`:

```ruby
raise "Something went wrong"
```

Or with a specific exception type:

```ruby
raise ArgumentError, "Invalid argument provided"
```

### Error Handling in Controllers

We have a couple of options for handling errors in our controllers. If we want to use `!` methods, we will need to `rescue` from errors in the controller methods:

```ruby
def update
  @post = Post.find(params[:id])
  @post.update!(post_params)

  redirect_to @post
rescue ActiveRecord::RecordInvalid => e
  render :edit
end
```

Alternatively, we can check for errors in the controller on the model instance using `#valid?`

```ruby
def update
  @post = Post.find(params[:id])
  @post.update(post_params)

  if @post.valid?
    redirect_to @post, notice: "Post created successfully."
  else
    render :edit
  end
end
```

### Rendering Errors to Users

To render errors in our views, we have a couple of options:

- `Model#errors`
- [`ActionDispatch::Flash`](https://api.rubyonrails.org/classes/ActionDispatch/Flash.html)

#### Model#errors

To render the errors from a model in a view, we need to set up the controller to catch the errors and handle them separately from a success.

> REMEMBER: `#new` makes a `POST` request to `#create`, while `#edit` makes a `PUT` request to `#update`

In our `#create` action:

```ruby
def create
  @post = current_user.posts.create!(post_params)

  redirect_to @post
rescue ActiveRecord::RecordInvalid => e
  @post = e.record
  render :new, status: :unprocessable_entity
end
```

In the `new.html.erb` view, we need to have some conditional rendering for an error notification, that renders only when `#errors` are present on our `Post` instance.

Since we are using a partial, `_form.html.erb`, we will make the change there so that it also works for our `#edit` view:

```ruby
<%= form_with model: post, data: { turbo: false }, html: { class: "post-form" } do |form| %>

  <% if post.errors.any? %>
    <div class="form-errors">
      <h2><%= pluralize(post.errors.count, "error") %> prohibited this post from being saved:</h2>
      <ul>
        <% post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <%# ...  %>
<% end %>
```

#### ActionDispatch::Flash

ActionDispatch::Flash allows us to pass information between Controller actions, and can be used for a number of things beyond error handling, including success notifications, or generic notices.

To render errors using `Flash`, we need to add the error to the `FlashHash` in the controller so that our view template can render it.

> **NOTE:** This is an **alternative** to the above example-- You do not need to, *nor should you*, do both. Pick the one you like and stay consistent!

We will use the `#update` action this time:

```ruby
def update
  @post = Post.find(params[:id])
  @post.update!(post_params)

  redirect_to @post
rescue ActiveRecord::RecordInvalid => e
  @post = e.record
  render :edit, status: :unprocessable_entity
end
```

#### Hotwire/Turbo Error Rendering Problems

⚠️ IMPORTANT!: Starting in Rails 7, Rails ships with Hotwire, which breaks some of the idioms for rendering errors. You may come across instructions for displaying `flash` errors or displaying the `Model#errors` in the view that do not cover this change.

To display errors in a Full-Stack Rails app running Rails >=7, you must either:

Return `:unprocessable_entity` as the status in the controller:

```ruby
def update
  @my_model = MyModel.find(params[:id])
  @my_model.update!(my_model_params)

  redirect_to @my_model
rescue ActiveRecord::RecordInvalid => e
  @post = e.record
  render :edit, status: :unprocessable_entity
end
```

Or, add `data: { turbo: false }` to your `form` declaration in the view:

```ruby
<%= form_with model: @my_model, data: { turbo: false } do |form| %>
# ...
```

We can also rescue at a higher level in our controllers to "DRY" our error handling with `rescue_from`

```ruby
class PostsController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

  private

  def render_invalid(e)
    
  end
end
```
