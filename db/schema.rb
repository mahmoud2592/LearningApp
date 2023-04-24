# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_24_115356) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_talents", force: :cascade do |t|
    t.integer "course_id"
    t.integer "talent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false
    t.index ["course_id"], name: "index_course_talents_on_course_id"
    t.index ["talent_id"], name: "index_course_talents_on_talent_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.string "video_url"
    t.integer "duration"
    t.integer "difficulty"
    t.float "price"
    t.boolean "published", default: false
    t.integer "learning_path_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "talent_id"
    t.index ["talent_id"], name: "index_courses_on_talent_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "talent_id"
    t.bigint "learning_path_id"
    t.date "enrollment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "learning_path_course_id", null: false
    t.boolean "completed", default: false, null: false
    t.date "completed_at"
    t.index ["learning_path_course_id"], name: "index_enrollments_on_learning_path_course_id"
    t.index ["learning_path_id"], name: "index_enrollments_on_learning_path_id"
    t.index ["talent_id", "learning_path_id"], name: "index_enrollments_on_talent_id_and_learning_path_id", unique: true
    t.index ["talent_id"], name: "index_enrollments_on_talent_id"
  end

  create_table "learning_path_courses", force: :cascade do |t|
    t.integer "learning_path_id"
    t.integer "course_id"
    t.integer "sequence"
    t.boolean "required", default: true
    t.integer "status", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_learning_path_courses_on_course_id"
    t.index ["learning_path_id"], name: "index_learning_path_courses_on_learning_path_id"
  end

  create_table "learning_paths", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "duration_in_weeks", default: 1
    t.integer "difficulty_level"
    t.boolean "published", default: false
    t.integer "views_count", default: 0
    t.integer "courses_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "category"
    t.integer "level"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "courses", "talents"
  add_foreign_key "enrollments", "learning_path_courses"
  add_foreign_key "enrollments", "learning_paths"
  add_foreign_key "enrollments", "talents"
end
