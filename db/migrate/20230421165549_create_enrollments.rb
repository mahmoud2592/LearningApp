class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.references :talent, foreign_key: true
      t.references :learning_path, foreign_key: true
      t.date :enrollment_date

      t.timestamps
    end

    add_index :enrollments, [:talent_id, :learning_path_id], unique: true
  end
end
