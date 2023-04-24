class AddLearningPathCourseRefToEnrollments < ActiveRecord::Migration[7.0]
  def up
    add_reference :enrollments, :learning_path_course, null: false, foreign_key: true
  end

  def down
    remove_reference :enrollments, :learning_path_course
  end
end
