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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140812180957) do

  create_table "areas", force: true do |t|
    t.string   "areaname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", force: true do |t|
    t.string   "zoho_contact_person_id"
    t.integer  "contact_id"
    t.string   "auth_token"
    t.string   "gender"
    t.string   "salutation"
    t.date     "birthday"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "rut"
    t.string   "email"
    t.string   "password"
    t.string   "phone"
    t.string   "mobile"
    t.boolean  "is_primary_contact"
    t.boolean  "zoho_enabled"
    t.boolean  "moodle_enabled"
    t.float    "test_score"
    t.integer  "course_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_statuses", force: true do |t|
    t.string   "statusname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_types", force: true do |t|
    t.string   "typename"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "zoho_contact_id"
    t.string   "contact_name"
    t.string   "company_name"
    t.integer  "payment_terms"
    t.string   "payment_terms_label"
    t.string   "currency_id"
    t.string   "website"
    t.string   "rut"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "zip"
    t.string   "phone"
    t.integer  "zoho_default_template_id"
    t.string   "notes"
    t.boolean  "zoho_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "context_types", force: true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "contexts", force: true do |t|
    t.integer  "typeid"
    t.integer  "instanceid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_features", force: true do |t|
    t.integer  "course_id"
    t.string   "feature_name"
    t.string   "feature_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_group_reports", force: true do |t|
    t.integer  "groupid"
    t.integer  "userid"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "institution"
    t.string   "department"
    t.string   "username"
    t.date     "lastaccess"
    t.integer  "total_sessions"
    t.integer  "current_sessions"
    t.integer  "p_sessions"
    t.integer  "a_sessions"
    t.integer  "t_sessions"
    t.decimal  "avg_inclasswork",     precision: 5, scale: 2
    t.decimal  "avg_attitude",        precision: 5, scale: 2
    t.decimal  "grade_coursegroup",   precision: 5, scale: 2
    t.decimal  "grade_homework",      precision: 5, scale: 2
    t.decimal  "grade_writing_tests", precision: 5, scale: 2
    t.decimal  "grade_tests_teg",     precision: 5, scale: 2
    t.decimal  "grade_tests",         precision: 5, scale: 2
    t.decimal  "grade_oral_tests",    precision: 5, scale: 2
    t.integer  "assignments_ontime"
    t.integer  "total_assignments"
    t.date     "created_at"
    t.datetime "updated_at"
  end

  create_table "course_levels", force: true do |t|
    t.string   "course_level"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_members", force: true do |t|
    t.integer  "course_id"
    t.integer  "web_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_sessions", force: true do |t|
    t.integer  "courseid"
    t.datetime "startdatetime"
    t.datetime "enddatetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_statuses", force: true do |t|
    t.string   "statusname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_types", force: true do |t|
    t.string   "typename"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "coursename"
    t.string   "description"
    t.integer  "course_level_id"
    t.integer  "students_qty"
    t.string   "mode"
    t.integer  "teacher_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zoho_product_id"
    t.integer  "coursetemplateid"
    t.integer  "course_status_id"
    t.date     "start_date"
    t.string   "location"
    t.integer  "moodleid"
    t.integer  "course_type_id"
  end

  create_table "diagnostic_tests", force: true do |t|
    t.integer  "contact_person_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "last_request_message_checks", force: true do |t|
    t.integer  "requestid"
    t.integer  "userid"
    t.datetime "last_check_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modalities", force: true do |t|
    t.string   "modalityname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moodle_courses", force: true do |t|
    t.integer  "moodleid"
    t.string   "coursename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moodle_group_assignations", force: true do |t|
    t.integer  "groupid"
    t.integer  "m_courseid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moodle_groups", force: true do |t|
    t.string   "groupname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "userid"
    t.string   "subject",    limit: 100
    t.text     "message"
    t.integer  "seen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_prices", force: true do |t|
    t.string   "modality"
    t.integer  "students_qty"
    t.integer  "hours_amt"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "valid_until"
    t.boolean  "deleted",      default: false
  end

  create_table "request_default_titles", force: true do |t|
    t.integer  "area_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_notes", force: true do |t|
    t.integer  "requestid"
    t.integer  "userid"
    t.string   "subject"
    t.text     "message"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_priorities", force: true do |t|
    t.string   "description", limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_statuses", force: true do |t|
    t.string   "description", limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "tagid"
    t.integer  "userid"
    t.string   "subject",             limit: 100
    t.integer  "receiverid"
    t.integer  "areaid"
    t.integer  "priorityid"
    t.integer  "statusid"
    t.text     "request",             limit: 2147483647
    t.date     "duedate"
    t.date     "resolved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.datetime "last_msg_datetime"
  end

  create_table "role_assignations", force: true do |t|
    t.integer  "contextid"
    t.integer  "userid"
    t.integer  "roleid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "rolename"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "userid"
    t.string   "tagname",    limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reports", force: true do |t|
    t.integer  "userid"
    t.string   "firstname",           limit: 45
    t.string   "lastname",            limit: 45
    t.string   "institution",         limit: 45
    t.string   "department",          limit: 45
    t.string   "username",            limit: 45
    t.integer  "courseid"
    t.string   "coursename",          limit: 45
    t.integer  "roleid"
    t.string   "rolename",            limit: 45
    t.datetime "lastaccess"
    t.integer  "total_sessions"
    t.integer  "current_sessions"
    t.integer  "p_sessions"
    t.integer  "a_sessions"
    t.integer  "t_sessions"
    t.float    "avg_inclasswork"
    t.float    "avg_attitude"
    t.float    "grade_course"
    t.float    "grade_homework"
    t.float    "grade_writing_tests"
    t.float    "grade_tests_teg"
    t.float    "grade_tests"
    t.float    "grade_oral_tests"
    t.integer  "assignments_ontime"
    t.integer  "total_assignments"
    t.datetime "created_at"
  end

  create_table "users", force: true do |t|
    t.string   "firstname",    limit: 45
    t.string   "lastname",     limit: 45
    t.string   "username",     limit: 45
    t.string   "auth_token"
    t.integer  "permissionid"
    t.string   "password"
    t.string   "institution",  limit: 45
    t.string   "department",   limit: 45
    t.string   "email",        limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_users", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "facebook_email"
    t.string   "email"
    t.string   "password"
    t.string   "gender"
    t.string   "phone"
    t.string   "mobile"
    t.string   "location"
    t.string   "facebook_location"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "provider"
    t.string   "zoho_contact_person_id"
    t.string   "zoho_contact_id"
    t.integer  "moodle_id"
    t.boolean  "zoho_enabled",           default: false
    t.boolean  "moodle_enabled",         default: false
    t.integer  "test_score"
    t.integer  "course_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zoho_default_templates", force: true do |t|
    t.string   "invoice_template_id"
    t.string   "estimate_template_id"
    t.string   "creditnote_template_id"
    t.string   "invoice_email_template_id"
    t.string   "estimate_email_template_id"
    t.string   "creditnote_email_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zoho_invoices", force: true do |t|
    t.integer  "customer_id"
    t.string   "zoho_contact_id"
    t.string   "zoho_invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zoho_leads", force: true do |t|
    t.string   "lead_source"
    t.string   "company"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.string   "email"
    t.string   "title"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zoho_organization_data", force: true do |t|
    t.string   "authtoken"
    t.string   "organization_name"
    t.string   "service"
    t.string   "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
