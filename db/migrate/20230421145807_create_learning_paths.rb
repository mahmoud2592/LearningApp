class CreateLearningPaths < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_paths do |t|
      t.string :name
      t.text :description
      t.integer :duration_in_weeks, default: 1
      t.integer :difficulty_level
      t.boolean :published, default: false
      t.integer :views_count, default: 0
      t.integer :courses_count, default: 0
      t.timestamps
    end
  end
end
