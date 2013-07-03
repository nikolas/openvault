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

ActiveRecord::Schema.define(:version => 20130703164600) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "user_type"
  end

  create_table "domain_terms", :force => true do |t|
    t.string "model"
    t.string "term"
  end

  add_index "domain_terms", ["model", "term"], :name => "terms_by_model_and_term"

  create_table "domain_terms_local_authorities", :id => false, :force => true do |t|
    t.integer "domain_term_id"
    t.integer "local_authority_id"
  end

  add_index "domain_terms_local_authorities", ["domain_term_id", "local_authority_id"], :name => "dtla_by_ids2"
  add_index "domain_terms_local_authorities", ["local_authority_id", "domain_term_id"], :name => "dtla_by_ids1"

  create_table "local_authorities", :force => true do |t|
    t.string "name"
  end

  create_table "local_authority_entries", :force => true do |t|
    t.integer "local_authority_id"
    t.string  "label"
    t.string  "uri"
  end

  add_index "local_authority_entries", ["local_authority_id", "label"], :name => "entries_by_term_and_label"
  add_index "local_authority_entries", ["local_authority_id", "uri"], :name => "entries_by_term_and_uri"

  create_table "mosaic_items", :force => true do |t|
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "link_title"
  end

  create_table "searches", :force => true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "subject_local_authority_entries", :force => true do |t|
    t.string "label"
    t.string "lowerLabel"
    t.string "url"
  end

  add_index "subject_local_authority_entries", ["lowerLabel"], :name => "entries_by_lower_label"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "guest",                  :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "postal_code"
    t.string   "country"
    t.boolean  "mla_updates"
    t.boolean  "terms_and_conditions"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
