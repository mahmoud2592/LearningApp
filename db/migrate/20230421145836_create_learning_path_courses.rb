class CreateLearningPathCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_path_courses do |t|
      t.integer :learning_path_id
      t.integer :course_id
      t.integer :sequence
      t.boolean :required, default: true
      t.integer :status, default: 0
      t.datetime :start_date
      t.datetime :end_date
      t.integer :rating
      t.datetime :completed_at

      t.timestamps
    end

    # Two indexes are also added to improve performance when querying the course-talent
    # table based on either the course or talent.
    add_index :learning_path_courses, :learning_path_id
    add_index :learning_path_courses, :course_id
  end
end
