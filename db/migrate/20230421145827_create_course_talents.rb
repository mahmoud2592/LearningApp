class CreateCourseTalents < ActiveRecord::Migration[7.0]
  def change
    create_table :course_talents do |t|
      t.integer :course_id
      t.integer :talent_id
      t.timestamps
    end

    # Two indexes are also added to improve performance when querying the course-talent
    # table based on either the course or talent.
    add_index :course_talents, :course_id
    add_index :course_talents, :talent_id
  end
end
