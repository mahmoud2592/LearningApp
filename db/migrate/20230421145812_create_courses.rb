class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :video_url
      t.integer :duration
      t.integer :difficulty
      t.float :price
      t.boolean :published, default: false
      t.integer :learning_path_id
      t.integer :author_id

      t.timestamps
    end
  end
end
