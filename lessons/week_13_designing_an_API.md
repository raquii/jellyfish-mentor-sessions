
# Week 13: Designing an API

## Schema Review

Let's review the basic associations in our app.

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_many :posts, inverse_of: :author, dependent: :destroy
  has_many :comments, inverse_of: :author, dependent: :destroy
end

# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :comments, as: :commentable, dependent: :destroy
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: "User"
end
```

---

## What is an API?

<!-- We talked about this previously in Week 6 -->

**API** stands for **Application Programming Interface**. It’s a way for different software systems to communicate with one another.

In the context of web development, an API typically refers to a set of HTTP endpoints that allow clients—like browsers, mobile apps, or third-party servers—to access or manipulate data.

For example, a front-end application can send a `GET` request to `/api/v1/posts`, and your Rails backend will return a list of posts as a JSON response.

APIs:

- Expose structured data, usually in formats like **JSON** or **XML**
- Use standard HTTP verbs: `GET`, `POST`, `PUT/PATCH`, `DELETE`
- Are stateless: each request is independent
- Often follow **REST** (Representational State Transfer) conventions

---

## API vs Application Controllers

Rails' `ApplicationController` is built with browser-based interactions in mind (e.g., CSRF protection, session handling).

For APIs:

- You don’t use `flash` messages  
- You want to respond with **JSON only**

Create a base controller for your API:

```ruby
# app/controllers/api/base_controller.rb
class Api::BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: "Resource not found" }, status: :not_found
  end
end
```

Then inherit from this in your versioned controllers:

```ruby
# app/controllers/api/posts_controller.rb
class Api::PostsController < Api::BaseController
  def index
    posts = Post.includes(:author, :comments).all
    render json: posts.as_json(include: { author: { only: :name }, comments: { only: [:id, :body] } })
  end

  def show
    post = Post.find(params[:id])
    render json: post.as_json(include: { author: { only: :name }, comments: { only: [:id, :body] } })
  end
end
```

<!-- That looks pretty bad, lets make it better -->

---

## Why Namespace the API?

Namespacing helps organize your controllers, especially when your app also serves HTML pages.

Instead of mixing UI logic with API logic, we use namespaced paths like:

```
/api/posts
/api/comments
```

This is useful for:

- Versioning (e.g., planning a `v2` API without breaking `v1`)
- Cleaner separation of concerns
- Easier testing and maintenance

---

## Directory Structure

Use the following directory structure for your controllers:

```
app/controllers/
  api/
    posts_controller.rb
    comments_controller.rb
    users_controller.rb
```

---

## Routing with Namespaces

Use Rails routing to organize your API:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :posts, only: [:index, :show, :create]
    resources :comments, only: [:create]
    resources :users, only: [:show]
  end
end
```

---

## Serializers

For better control of JSON structure, use a gem like [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) or [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)

```ruby
# app/serializers/post_serializer.rb
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  belongs_to :author, serializer: UserSerializer
  has_many :comments
end

# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
end

# app/serializers/comment_serializer.rb
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body
  belongs_to :author, serializer: UserSerializer
end
```

Then in your controller:

```ruby
render json: PostSerializer.new(@posts)
```
