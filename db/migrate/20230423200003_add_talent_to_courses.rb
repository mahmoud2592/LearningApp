class AddTalentToCourses < ActiveRecord::Migration[7.0]
  def up
    add_reference :courses, :talent, foreign_key: { to_table: :talents }
  end

  def down
    removereference :courses, :talent
  end
end
