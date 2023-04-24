class RemoveCompletedAtFromLearningPathCourse < ActiveRecord::Migration[7.0]
  def up
    remove_column :learning_path_courses, :completed_at
  end

  def down
    add_column :learning_path_courses, :completed_at, :date, null: true
  end
end
