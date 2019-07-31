# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111024154009) do

  create_table "documents", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "project_id"
  end

  create_table "feeds", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.boolean  "deal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_types_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "project_type_id"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mentor_id"
    t.string   "status"
    t.datetime "date_accepted"
    t.datetime "date_completed"
    t.integer  "project_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "university_id"
    t.string   "university_other"
    t.text     "essay_prompt"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "universities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                      :default => "", :null => false
    t.string   "encrypted_password",          :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "skype_id"
    t.integer  "SAT_score"
    t.string   "university_other"
    t.string   "paypal_account"
    t.text     "bio"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.boolean  "is_mentor"
    t.integer  "university_id"
    t.boolean  "admin"
    t.string   "mentor_status"
    t.boolean  "active_mentor"
    t.integer  "ACT_score"
    t.integer  "GMAT_score"
    t.integer  "LSAT_score"
    t.integer  "MCAT_score"
    t.integer  "GRE_score"
    t.text     "clubs",                       :limit => 255
    t.text     "awards",                      :limit => 255
    t.date     "graduation",                  :limit => 255
    t.decimal  "gpa"
    t.string   "other_accepted_universities"
    t.string   "writing_sample_file_name"
    t.string   "writing_sample_content_type"
    t.integer  "writing_sample_file_size"
    t.datetime "writing_sample_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
