# Week 8: Display Data and ERB

- [Week 8: Display Data and ERB](#week-8-display-data-and-erb)
  - [Displaying Data](#displaying-data)
    - [Creating the route](#creating-the-route)
    - [Creating the Controller](#creating-the-controller)
    - [Coming up with a layout](#coming-up-with-a-layout)
    - [Working with ERB](#working-with-erb)
      - [ERB Syntax Overview](#erb-syntax-overview)
      - [Writing the Template](#writing-the-template)

## Displaying Data

Personally, I prefer to understand how the data you receive will be shaped before beginning to imagine how to build the page. Let's look at our Post data.

When we last left off, we had defined the routes for the `Post` model, and set up some controller actions for them that rendered the Posts as `json`.

For now, we are going to focus on the **`#index`** action for `Post`.

If we navigate to our `/posts` endpoint right now, we'll see something like this:

```json
[
  {
    "id": 1,
    "title": "A Title",
    "body": "Fine. heres a body",
    "created_at": "2025-04-10T00:31:23.340Z",
    "updated_at": "2025-04-10T00:31:23.340Z",
    "author_id": 1
  },
  {
    "id": 2,
    "title": "This is a new post",
    "body": "this is a new body",
    "created_at": "2025-04-17T00:45:41.393Z",
    "updated_at": "2025-04-17T00:45:41.393Z",
    "author_id": 1
  },
]
```

But what if we want to show the data in a more fun, appealing way? We're ready to learn a bit more about the **View** part of our Model-View-Controller application.

Before we do, let's refresh our steps from last time:

### Creating the route

Let's create some route for the Post Model. In `config/routes.rb`, we will add a definition for the routes:

```ruby
resources :posts
```

This creates all of the CRUD routes for the `Post` model. We could just create the route for the `#index` action by specifying `only: :index` after the `resources :posts` definition, however, we know we want to support the other CRUD actions, too.

> **Remember**: An `#index` route should return a collection of resources. (See [Week 6](#week-6---april-16-2025) for a refresher)

### Creating the Controller

We will create a controller action to handle this route in the `PostsController` (`/app/controllers/posts_controller.rb`)

We want to retreive all of the `Post` records, with the newest records showing first.

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end
end
```

### Coming up with a layout

This is what your lesson refers to as *wireframing*. You can do this using tools like Figma or Moqup, or by hand with pen and paper.

It is nice to have a general sense of how the page should be laid out before you start writing your view. In the enterprise world, a UX designer will provide an developer with designs for the page they are expected to build.

![alt text](image.png)
> [Image Credit](https://www.behance.net/gallery/96544243/Bandsintown-Mobile-App-Redesign?tracking_source=project_owner_other_projects)

![alt text](image-1.png)

### Working with ERB

After we are sure of the layout, we can start to write our view template. Out of the box, Rails ships with **ERB**, or Embedded Ruby, as its templating language for defining views.

ERB lets us write Ruby code within an HTML file, which Rails uses to generate dynamic content for our application.

#### ERB Syntax Overview

An ERB file is *mostly HTML,* but there are two important syntax distinctions to note about using ERB:

1. `<% %>` - Run Ruby code without output
   This is used for control flow, loops, and conditionals, where we do not wish the output to render anything, itself

   ```erb
   <% @posts.each do |post| %>
    ...
   <% end %>
   ```

2. `<%= %>` — Run Ruby Code and output the result
   This inserts the result of our Ruby code into the HTML

   ```erb
   <h2><%= @post.title %></h2>
   ```

#### Writing the Template

> 💡 **FYI**: You may have noticed the `@var` we declared in the controller. The instance variables we declare in our controllers are available in our views. This means we can call `@posts` in our ERB file, and receive the value stored under that variable.

```erb
<h1 class="page-title">Posts</h1>

<div class="posts-list">
  <% @posts.each do |post| %>
    <div class="post-card">
      <h2 class="post-title"><%= post.title %></h2>
      <div class="post-meta">
        By: <%= post.author %> (<em><%= post.created_at.strftime("%B %d, %Y") %></em>)
      </div>
      <div class="post-body">
        <%= truncate(post.body, length: 200) %>
      </div>
    </div>
  <% end %>
</div>
```