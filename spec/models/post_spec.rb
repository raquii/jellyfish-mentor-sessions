require 'rails_helper'

RSpec.describe Post, type: :model do
  context "validations" do
    let(:user) { User.create(name: "Test User") }
    it "with valid attributes" do
      post = Post.new(title: "Sample Title", body: "Sample body", author: user)
      expect(post).to be_valid
    end

    it "without a title" do
      post = Post.new(title: nil, body: "Sample body", author: user)
      expect(post).not_to be_valid
    end

    it "without content" do
      post = Post.new(title: "Sample Title", body: nil, author: user)
      expect(post).not_to be_valid
    end

    it "with title longer than #{Post::MAX_TITLE_LENGTH}" do
      post = Post.new(title: "a" * 256, body: "Sample body", author: user)
      expect(post).not_to be_valid
    end

    it "with body longer than #{Post::MAX_BODY_LENGTH}" do
      post = Post.new(title: "Sample Title", body: "a" * 5001, author: user)
      expect(post).not_to be_valid
    end

    it "without an author" do
      post = Post.new(title: "Sample Title", body: "Sample body")
      expect(post).not_to be_valid
    end
  end

  context "#print_post" do
    let(:user) { User.create(name: "Test User") }
    subject(:post) { Post.create(title: "Sample Title", body: "Sample body", author: user) }

    it "outputs the post details" do
      expect(post.print_post).to include("Title: Sample Title")
      expect(post.print_post).to include("Body: Sample body")
      expect(post.print_post).to include("By: Test User")
    end
  end
end
