# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110629015229) do

  create_table "audit_logs", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.string   "request_uri",    :null => false
    t.string   "remote_addr",    :null => false
    t.string   "description",    :null => false
    t.datetime "created_at",     :null => false
    t.string   "auditable_type"
    t.integer  "auditable_id"
  end

  add_index "audit_logs", ["user_id"], :name => "index_audit_logs_on_user_id"

  create_table "clients", :force => true do |t|
    t.string  "name",                                                      :null => false
    t.string  "address_1",                                                 :null => false
    t.string  "address_2"
    t.string  "city",                                                      :null => false
    t.string  "state",       :limit => 2,                                  :null => false
    t.string  "postal_code", :limit => 10
    t.decimal "lat",                       :precision => 15, :scale => 10
    t.decimal "lng",                       :precision => 15, :scale => 10
  end

  add_index "clients", ["name"], :name => "index_clients_on_name", :unique => true

  create_table "computer_monitors", :force => true do |t|
    t.string   "cm_type"
    t.string   "size"
    t.string   "brand"
    t.string   "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpu_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpu_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpu_hard_drive_serials", :force => true do |t|
    t.string   "name"
    t.integer  "cpu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpu_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpus", :force => true do |t|
    t.string   "cpu_type"
    t.string   "brand"
    t.string   "serial"
    t.string   "cpu_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_versions", :force => true do |t|
    t.integer  "document_id",                                :null => false
    t.string   "name",                                       :null => false
    t.string   "description"
    t.integer  "version",                     :default => 1, :null => false
    t.string   "filename",                                   :null => false
    t.string   "sha1",          :limit => 40,                :null => false
    t.string   "content_type",                               :null => false
    t.integer  "size",                                       :null => false
    t.datetime "created_at",                                 :null => false
    t.integer  "created_by_id",                              :null => false
  end

  add_index "document_versions", ["document_id"], :name => "index_document_versions_on_document_id"

  create_table "documents", :force => true do |t|
    t.integer  "folder_id",                                   :null => false
    t.integer  "root_folder_id",                              :null => false
    t.string   "name",                                        :null => false
    t.string   "description"
    t.integer  "version",                      :default => 1, :null => false
    t.string   "filename",                                    :null => false
    t.string   "sha1",           :limit => 40,                :null => false
    t.string   "content_type",                                :null => false
    t.integer  "size",                                        :null => false
    t.datetime "created_at",                                  :null => false
    t.integer  "created_by_id",                               :null => false
  end

  add_index "documents", ["folder_id"], :name => "index_documents_on_folder_id"
  add_index "documents", ["root_folder_id"], :name => "index_documents_on_root_folder_id"

  create_table "equipment", :force => true do |t|
    t.string   "type",          :null => false
    t.string   "type_name",     :null => false
    t.integer  "pickup_id",     :null => false
    t.integer  "client_id",     :null => false
    t.string   "tracking",      :null => false
    t.string   "serial"
    t.string   "mfg"
    t.string   "model"
    t.string   "comments"
    t.string   "grade"
    t.integer  "recycling"
    t.integer  "value"
    t.string   "processor"
    t.string   "hard_drive"
    t.string   "ram"
    t.integer  "page_count"
    t.string   "screen_size"
    t.string   "mfg_date"
    t.string   "disposition"
    t.string   "customer"
    t.string   "asset_tag"
    t.string   "country"
    t.string   "location"
    t.string   "piu"
    t.string   "dws_cart"
    t.string   "cpu"
    t.string   "monitors"
    t.string   "bob"
    t.string   "bob_cable"
    t.datetime "created_at"
    t.integer  "created_by_id"
  end

  add_index "equipment", ["client_id"], :name => "index_equipment_on_client_id"
  add_index "equipment", ["pickup_id"], :name => "index_equipment_on_pickup_id"
  add_index "equipment", ["serial"], :name => "index_equipment_on_serial"
  add_index "equipment", ["tracking"], :name => "index_equipment_on_tracking", :unique => true
  add_index "equipment", ["type"], :name => "index_equipment_on_type"
  add_index "equipment", ["type_name"], :name => "index_equipment_on_type_name"

  create_table "feedbacks", :force => true do |t|
    t.integer  "pickup_id",                                              :null => false
    t.integer  "client_user_id",                                         :null => false
    t.string   "value",                     :limit => 40,                :null => false
    t.integer  "complete",                  :limit => 1,  :default => 0, :null => false
    t.integer  "contacted_promptly",        :limit => 1
    t.integer  "complete_audit_timely",     :limit => 1
    t.integer  "appropriate_communication", :limit => 1
    t.integer  "customer_service_needs",    :limit => 1
    t.text     "comments"
    t.integer  "solution_owner_contact",    :limit => 1
    t.text     "references"
    t.integer  "updated_by_id"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["client_user_id"], :name => "index_feedbacks_on_client_user_id"
  add_index "feedbacks", ["pickup_id"], :name => "index_feedbacks_on_pickup_id"
  add_index "feedbacks", ["value"], :name => "index_feedbacks_on_value", :unique => true

  create_table "flash_hard_drive_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flash_hard_drives", :force => true do |t|
    t.string   "brand"
    t.string   "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.integer "folderable_id",   :null => false
    t.string  "folderable_type", :null => false
    t.integer "parent_id"
    t.integer "root_folder_id"
    t.string  "name",            :null => false
    t.string  "description"
  end

  create_table "loose_hard_drive_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loose_hard_drives", :force => true do |t|
    t.string   "brand"
    t.string   "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magnetic_media_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magnetic_medias", :force => true do |t|
    t.string   "mm_type"
    t.string   "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miscellaneous_equipment_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miscellaneous_equipment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miscellaneous_equipments", :force => true do |t|
    t.string   "serial"
    t.string   "me_type"
    t.string   "brand"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitor_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitor_sizes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pallets", :force => true do |t|
    t.string   "number"
    t.text     "description"
    t.string   "weight"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pickup_id"
  end

  create_table "password_tickets", :force => true do |t|
    t.integer  "user_id",                  :null => false
    t.string   "value",      :limit => 40, :null => false
    t.datetime "expires_at",               :null => false
  end

  add_index "password_tickets", ["user_id"], :name => "index_password_tickets_on_user_id", :unique => true
  add_index "password_tickets", ["value"], :name => "index_password_tickets_on_value", :unique => true

  create_table "peripherals", :force => true do |t|
    t.string   "ptype"
    t.string   "brand"
    t.string   "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peripherals_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peripherals_hard_drive_serials", :force => true do |t|
    t.string   "name"
    t.integer  "peripheral_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickup_locations", :force => true do |t|
    t.string  "name",                                 :null => false
    t.integer "client_id",                            :null => false
    t.integer "client_user_id",                       :null => false
    t.string  "address_1",                            :null => false
    t.string  "address_2"
    t.string  "city",                                 :null => false
    t.string  "state",                  :limit => 2,  :null => false
    t.string  "postal_code",            :limit => 10
    t.decimal "lat"
    t.decimal "lng"
    t.integer "solution_owner_user_id"
  end

  add_index "pickup_locations", ["client_id"], :name => "index_pickup_locations_on_client_id"
  add_index "pickup_locations", ["client_user_id"], :name => "index_pickup_locations_on_client_user_id"
  add_index "pickup_locations", ["name"], :name => "index_pickup_locations_on_name"

  create_table "pickups", :force => true do |t|
    t.integer  "pickup_location_id",     :null => false
    t.integer  "client_id",              :null => false
    t.string   "name"
    t.string   "status",                 :null => false
    t.string   "pickup_type"
    t.string   "special_request"
    t.string   "quantity"
    t.date     "pickup_date"
    t.string   "pickup_time"
    t.string   "site_contact_name"
    t.string   "client_reference"
    t.integer  "solution_owner_user_id", :null => false
    t.integer  "client_user_id",         :null => false
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.date     "notification_date"
    t.string   "pickup_date_range"
    t.string   "facility"
    t.string   "arrival_time"
    t.string   "departure_time"
    t.string   "number_of_men"
    t.text     "crew_members"
  end

  add_index "pickups", ["client_id"], :name => "index_pickups_on_client_id"
  add_index "pickups", ["name"], :name => "index_pickups_on_name"
  add_index "pickups", ["notification_date"], :name => "index_pickups_on_notification_date"
  add_index "pickups", ["pickup_date"], :name => "index_pickups_on_pickup_date"
  add_index "pickups", ["pickup_location_id"], :name => "index_pickups_on_pickup_location_id"
  add_index "pickups", ["status"], :name => "index_pickups_on_status"

  create_table "system_emails", :force => true do |t|
    t.integer  "pickup_id",  :null => false
    t.integer  "user_id",    :null => false
    t.string   "subject",    :null => false
    t.text     "body"
    t.datetime "created_at"
  end

  add_index "system_emails", ["pickup_id"], :name => "index_system_emails_on_pickup_id"

  create_table "tasks", :force => true do |t|
    t.integer  "pickup_id",                           :null => false
    t.integer  "num",                    :limit => 1, :null => false
    t.string   "name",                                :null => false
    t.string   "status",                              :null => false
    t.string   "comments"
    t.datetime "updated_at"
    t.integer  "solution_owner_user_id"
  end

  add_index "tasks", ["name"], :name => "index_tasks_on_name"
  add_index "tasks", ["num"], :name => "index_tasks_on_num"
  add_index "tasks", ["pickup_id"], :name => "index_tasks_on_pickup_id"
  add_index "tasks", ["status"], :name => "index_tasks_on_status"

  create_table "tv_brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tv_sizes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tvs", :force => true do |t|
    t.string   "brand"
    t.string   "size"
    t.string   "serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "type",                                                   :null => false
    t.integer  "client_id"
    t.string   "login",                                                  :null => false
    t.string   "email",                                                  :null => false
    t.string   "name",                                                   :null => false
    t.string   "title"
    t.string   "phone"
    t.string   "time_zone"
    t.datetime "last_login"
    t.text     "breadcrumbs"
    t.integer  "admin",                     :limit => 1,  :default => 0, :null => false
    t.integer  "inactive",                  :limit => 1,  :default => 0, :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["type"], :name => "index_users_on_type"

end
