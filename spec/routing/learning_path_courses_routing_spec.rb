require 'rails_helper'
RSpec.describe "LearningPaths", type: :routing do
  describe "nested courses routes" do
    it "routes to courses#index" do
      expect(get: "/learning_paths/1/courses").to route_to("courses#index", learning_path_id: "1")
    end

    it "routes to courses#create" do
      expect(post: "/learning_paths/1/courses").to route_to("courses#create", learning_path_id: "1")
    end

    it "routes to courses#destroy" do
      expect(delete: "/learning_paths/1/courses/1").to route_to("courses#destroy", learning_path_id: "1", id: "1")
    end
  end
end
