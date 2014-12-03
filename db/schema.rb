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

ActiveRecord::Schema.define(version: 20141202131801) do

  create_table "areas", force: true do |t|
    t.string   "areaname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendar_holydays", force: true do |t|
    t.date     "date"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classroom_availabilities", force: true do |t|
    t.integer  "sort_order"
    t.integer  "classroom_id"
    t.integer  "weekday"
    t.time     "start_hour"
    t.integer  "duration"
    t.integer  "prime"
    t.boolean  "enabled",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classroom_matchings", force: true do |t|
    t.string   "matching_array"
    t.string   "matching_label"
    t.boolean  "enabled",        default: true
    t.integer  "category_id",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_department_vs", id: false, force: true do |t|
    t.string "institution", default: "", null: false
    t.string "department",  default: "", null: false
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

  create_table "course_alarm_parameters", force: true do |t|
    t.string   "param_name"
    t.string   "param_description"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_attendance_reports", force: true do |t|
    t.integer  "courseid"
    t.string   "coursename"
    t.integer  "total_sessions"
    t.integer  "current_booked_sessions"
    t.integer  "current_taken_sessions"
    t.datetime "last_taken_session_date"
    t.float    "avg_attendance_ratio"
    t.float    "std_dev_assistance"
    t.date     "created_at"
  end

  create_table "course_classrooms", force: true do |t|
    t.integer  "course_id"
    t.integer  "classroom_matching_id"
    t.date     "course_start_date"
    t.date     "course_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_current_alarms", force: true do |t|
    t.integer  "userid"
    t.integer  "courses_failing_grades"
    t.integer  "courses_failing_attendance"
    t.integer  "courses_late_sessions"
    t.integer  "teachers_low_performance"
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

  create_table "course_grades_reports", force: true do |t|
    t.integer  "courseid"
    t.integer  "categoryid"
    t.string   "categoryname"
    t.integer  "itemid"
    t.string   "itemname"
    t.integer  "sortorder"
    t.datetime "last_modification"
    t.integer  "hidden"
    t.integer  "locked"
    t.float    "mean_grade"
    t.float    "std_dev_grade"
    t.integer  "gradetype"
    t.date     "created_at"
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

  create_table "course_mode_zoho_product_maps", force: true do |t|
    t.string   "product_name"
    t.string   "zoho_product_id"
    t.integer  "course_mode_id"
    t.string   "price"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_modes", force: true do |t|
    t.string   "mode_name"
    t.string   "description"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_observations", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.string   "subject"
    t.text     "message"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_session_types", force: true do |t|
    t.string   "type_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_session_weekdays", force: true do |t|
    t.integer  "course_id"
    t.integer  "order"
    t.integer  "day_number"
    t.string   "session_start_hour"
    t.integer  "course_classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_sessions", force: true do |t|
    t.integer  "commerce_course_id"
    t.integer  "moodle_course_id"
    t.datetime "startdatetime"
    t.datetime "enddatetime"
    t.integer  "session_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_statuses", force: true do |t|
    t.string   "statusname"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_template_sessions", force: true do |t|
    t.integer  "course_template_id"
    t.integer  "session_number"
    t.integer  "session_type_id"
    t.integer  "page"
    t.string   "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_templates", force: true do |t|
    t.integer  "course_level_id"
    t.string   "name"
    t.integer  "total_sessions"
    t.boolean  "starting_book",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deleted",         default: 0
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
    t.integer  "current_students_qty",  default: 0
    t.string   "mode"
    t.integer  "main_teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zoho_product_id"
    t.integer  "course_template_id"
    t.integer  "course_status_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "classroom_matching_id"
    t.string   "discount_pct"
    t.integer  "discount_factor"
    t.integer  "location_id",           default: 1
    t.integer  "moodleid"
    t.integer  "course_type_id"
  end

  create_table "dashboard_courses_vs", id: false, force: true do |t|
    t.integer  "courseid",                limit: 8,   default: 0,    null: false
    t.string   "coursename",              limit: 254, default: "",   null: false
    t.boolean  "visible",                             default: true, null: false
    t.integer  "status_id"
    t.datetime "start_date"
    t.date     "end_date"
    t.integer  "total_sessions"
    t.integer  "current_booked_sessions"
    t.integer  "current_taken_sessions"
    t.datetime "last_taken_session_date"
    t.float    "avg_attendance_ratio"
    t.float    "std_dev_assistance"
    t.float    "mean_grade"
    t.float    "std_dev_grade"
    t.integer  "gradetype"
    t.date     "created_at"
  end

  create_table "diagnostic_tests", force: true do |t|
    t.integer  "contact_person_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feriados", force: true do |t|
    t.date "fecha", null: false
  end

  create_table "last_request_message_checks", force: true do |t|
    t.integer  "requestid"
    t.integer  "userid"
    t.datetime "last_check_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moodle_course_session_vs", id: false, force: true do |t|
    t.integer  "id",            limit: 8,          default: 0, null: false
    t.integer  "courseid",      limit: 8,          default: 0
    t.datetime "session_date"
    t.integer  "duration",      limit: 8,          default: 0, null: false
    t.datetime "last_taken"
    t.integer  "last_taken_by", limit: 8,          default: 0, null: false
    t.datetime "time_modified"
    t.text     "description",   limit: 2147483647,             null: false
  end

  create_table "moodle_course_vs", id: false, force: true do |t|
    t.integer  "moodleid",              limit: 8,   default: 0,    null: false
    t.string   "coursename",            limit: 254, default: "",   null: false
    t.string   "shortname",                         default: "",   null: false
    t.boolean  "visible",                           default: true, null: false
    t.string   "sence_idnumber",        limit: 100, default: "",   null: false
    t.datetime "start_date"
    t.integer  "summitid",                          default: 0
    t.integer  "course_template_id"
    t.integer  "course_status_id"
    t.integer  "location_id",                       default: 1
    t.date     "summit_start_date"
    t.date     "end_date"
    t.integer  "students_qty"
    t.integer  "current_students_qty",              default: 0
    t.integer  "main_teacher_id"
    t.integer  "classroom_matching_id"
  end

  create_table "moodle_courses", force: true do |t|
    t.integer  "moodleid"
    t.integer  "course_template_id"
    t.integer  "status_id"
    t.integer  "location_id"
    t.date     "end_date"
    t.boolean  "sence"
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

  create_table "moodle_role_assignation_vs", id: false, force: true do |t|
    t.integer "id",       limit: 8, default: 0,  null: false
    t.integer "userid",   limit: 8, default: 0,  null: false
    t.integer "courseid", limit: 8, default: 0,  null: false
    t.integer "roleid",   limit: 8, default: 0,  null: false
    t.string  "rolename",           default: ""
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

  create_table "request_attachments", force: true do |t|
    t.integer  "request_id"
    t.string   "attached_file_file_name"
    t.string   "attached_file_content_type"
    t.integer  "attached_file_file_size"
    t.datetime "attached_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_default_titles", force: true do |t|
    t.integer  "area_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_enabled_areas", force: true do |t|
    t.integer  "area_id"
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
    t.string   "term_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_statuses", force: true do |t|
    t.string   "description", limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_tag_categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_tags", force: true do |t|
    t.integer  "category_id",     default: 1
    t.integer  "area_id"
    t.integer  "default_user_id"
    t.string   "tagname"
    t.text     "default_msg"
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

  create_table "sence_attendance_reports", force: true do |t|
    t.string   "sence_idnumber"
    t.integer  "course_id"
    t.string   "user_idnumber"
    t.integer  "p_sessions"
    t.integer  "current_sessions"
    t.integer  "current_course_seconds"
    t.integer  "current_user_seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sence_attendances", force: true do |t|
    t.string   "codigo_sence"
    t.string   "sence_idnumber"
    t.string   "institution"
    t.string   "user_name"
    t.string   "user_rut"
    t.integer  "course_total_hours"
    t.date     "session_date"
    t.time     "session_start_time"
    t.time     "session_end_time"
    t.time     "block_time"
    t.time     "user_attendance_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_attendance_reports", force: true do |t|
    t.integer  "userid"
    t.integer  "courseid"
    t.string   "acronym",     limit: 1
    t.integer  "statusid"
    t.integer  "inclasswork"
    t.integer  "attitude"
    t.string   "description"
    t.datetime "timetaken"
    t.integer  "sessionid"
    t.datetime "sessiondate"
    t.datetime "lasttaken"
    t.integer  "lasttakenby"
    t.integer  "pagenum"
    t.date     "created_at"
  end

  create_table "student_general_attendance_reports", force: true do |t|
    t.integer "userid"
    t.integer "courseid"
    t.integer "present_sessions"
    t.integer "absent_sessions"
    t.integer "total_sessions"
    t.date    "created_at"
  end

  create_table "student_grades_reports", force: true do |t|
    t.integer "userid"
    t.integer "courseid"
    t.integer "categoryid"
    t.string  "categoryname"
    t.integer "itemid"
    t.string  "itemname"
    t.integer "sortorder"
    t.integer "hidden"
    t.float   "finalgrade"
    t.integer "gradetype"
    t.date    "created_at"
  end

  create_table "student_vs", id: false, force: true do |t|
    t.integer "id",                limit: 8,          default: 0,           null: false
    t.string  "auth",              limit: 20,         default: "manual",    null: false
    t.boolean "confirmed",                            default: false,       null: false
    t.boolean "policyagreed",                         default: false,       null: false
    t.boolean "deleted",                              default: false,       null: false
    t.boolean "suspended",                            default: false,       null: false
    t.integer "mnethostid",        limit: 8,          default: 0,           null: false
    t.string  "username",          limit: 100,        default: "",          null: false
    t.string  "password",                             default: "",          null: false
    t.string  "idnumber",                             default: "",          null: false
    t.string  "firstname",         limit: 100,        default: "",          null: false
    t.string  "lastname",          limit: 100,        default: "",          null: false
    t.string  "email",             limit: 100,        default: "",          null: false
    t.boolean "emailstop",                            default: false,       null: false
    t.string  "icq",               limit: 15,         default: "",          null: false
    t.string  "skype",             limit: 50,         default: "",          null: false
    t.string  "yahoo",             limit: 50,         default: "",          null: false
    t.string  "aim",               limit: 50,         default: "",          null: false
    t.string  "msn",               limit: 50,         default: "",          null: false
    t.string  "phone1",            limit: 20,         default: "",          null: false
    t.string  "phone2",            limit: 20,         default: "",          null: false
    t.string  "institution",                          default: "",          null: false
    t.string  "department",                           default: "",          null: false
    t.string  "address",                              default: "",          null: false
    t.string  "city",              limit: 120,        default: "",          null: false
    t.string  "country",           limit: 2,          default: "",          null: false
    t.string  "lang",              limit: 30,         default: "en",        null: false
    t.string  "theme",             limit: 50,         default: "",          null: false
    t.string  "timezone",          limit: 100,        default: "99",        null: false
    t.integer "firstaccess",       limit: 8,          default: 0,           null: false
    t.integer "lastaccess",        limit: 8,          default: 0,           null: false
    t.integer "lastlogin",         limit: 8,          default: 0,           null: false
    t.integer "currentlogin",      limit: 8,          default: 0,           null: false
    t.string  "lastip",            limit: 45,         default: "",          null: false
    t.string  "secret",            limit: 15,         default: "",          null: false
    t.integer "picture",           limit: 8,          default: 0,           null: false
    t.string  "url",                                  default: "",          null: false
    t.text    "description",       limit: 2147483647
    t.integer "descriptionformat", limit: 1,          default: 1,           null: false
    t.boolean "mailformat",                           default: true,        null: false
    t.boolean "maildigest",                           default: false,       null: false
    t.integer "maildisplay",       limit: 1,          default: 2,           null: false
    t.boolean "autosubscribe",                        default: true,        null: false
    t.boolean "trackforums",                          default: false,       null: false
    t.integer "timecreated",       limit: 8,          default: 0,           null: false
    t.integer "timemodified",      limit: 8,          default: 0,           null: false
    t.integer "trustbitmask",      limit: 8,          default: 0,           null: false
    t.string  "imagealt"
    t.string  "lastnamephonetic"
    t.string  "firstnamephonetic"
    t.string  "middlename"
    t.string  "alternatename"
    t.string  "calendartype",      limit: 30,         default: "gregorian", null: false
    t.string  "name",              limit: 201
  end

  create_table "system_parameters", force: true do |t|
    t.string   "param_name"
    t.string   "description"
    t.string   "param_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_vs", id: false, force: true do |t|
    t.integer  "id",                  limit: 8,          default: 0,           null: false
    t.string   "auth",                limit: 20,         default: "manual",    null: false
    t.boolean  "confirmed",                              default: false,       null: false
    t.boolean  "policyagreed",                           default: false,       null: false
    t.boolean  "deleted",                                default: false,       null: false
    t.boolean  "suspended",                              default: false,       null: false
    t.integer  "mnethostid",          limit: 8,          default: 0,           null: false
    t.string   "username",            limit: 100,        default: "",          null: false
    t.string   "password",                               default: "",          null: false
    t.string   "idnumber",                               default: "",          null: false
    t.string   "firstname",           limit: 100,        default: "",          null: false
    t.string   "lastname",            limit: 100,        default: "",          null: false
    t.string   "name",                limit: 201
    t.string   "email",               limit: 100,        default: "",          null: false
    t.boolean  "emailstop",                              default: false,       null: false
    t.string   "icq",                 limit: 15,         default: "",          null: false
    t.string   "skype",               limit: 50,         default: "",          null: false
    t.string   "yahoo",               limit: 50,         default: "",          null: false
    t.string   "aim",                 limit: 50,         default: "",          null: false
    t.string   "msn",                 limit: 50,         default: "",          null: false
    t.string   "phone1",              limit: 20,         default: "",          null: false
    t.string   "phone2",              limit: 20,         default: "",          null: false
    t.string   "institution",                            default: "",          null: false
    t.string   "department",                             default: "",          null: false
    t.string   "address",                                default: "",          null: false
    t.string   "city",                limit: 120,        default: "",          null: false
    t.string   "country",             limit: 2,          default: "",          null: false
    t.string   "lang",                limit: 30,         default: "en",        null: false
    t.string   "theme",               limit: 50,         default: "",          null: false
    t.string   "timezone",            limit: 100,        default: "99",        null: false
    t.integer  "firstaccess",         limit: 8,          default: 0,           null: false
    t.integer  "lastaccess",          limit: 8,          default: 0,           null: false
    t.integer  "lastlogin",           limit: 8,          default: 0,           null: false
    t.integer  "currentlogin",        limit: 8,          default: 0,           null: false
    t.string   "lastip",              limit: 45,         default: "",          null: false
    t.string   "secret",              limit: 15,         default: "",          null: false
    t.integer  "picture",             limit: 8,          default: 0,           null: false
    t.string   "url",                                    default: "",          null: false
    t.text     "description",         limit: 2147483647
    t.integer  "descriptionformat",   limit: 1,          default: 1,           null: false
    t.boolean  "mailformat",                             default: true,        null: false
    t.boolean  "maildigest",                             default: false,       null: false
    t.integer  "maildisplay",         limit: 1,          default: 2,           null: false
    t.boolean  "autosubscribe",                          default: true,        null: false
    t.boolean  "trackforums",                            default: false,       null: false
    t.integer  "timecreated",         limit: 8,          default: 0,           null: false
    t.integer  "timemodified",        limit: 8,          default: 0,           null: false
    t.integer  "trustbitmask",        limit: 8,          default: 0,           null: false
    t.string   "imagealt"
    t.string   "lastnamephonetic"
    t.string   "firstnamephonetic"
    t.string   "middlename"
    t.string   "alternatename"
    t.string   "calendartype",        limit: 30,         default: "gregorian", null: false
    t.string   "auth_token"
    t.integer  "system_role_id"
    t.integer  "teacher_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "roleid"
    t.integer  "assignationid",                          default: 0,           null: false
  end

  create_table "user_disponibilities", force: true do |t|
    t.integer  "user_id"
    t.integer  "day_number"
    t.time     "start_time"
    t.time     "end_time"
    t.time     "extra_start_time"
    t.time     "extra_end_time"
    t.date     "start_date"
    t.date     "end_date"
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

  create_table "user_teacher_levels", force: true do |t|
    t.string   "level_label"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_vs", id: false, force: true do |t|
    t.integer  "id",                  limit: 8,          default: 0,           null: false
    t.string   "auth",                limit: 20,         default: "manual",    null: false
    t.boolean  "confirmed",                              default: false,       null: false
    t.boolean  "policyagreed",                           default: false,       null: false
    t.boolean  "deleted",                                default: false,       null: false
    t.boolean  "suspended",                              default: false,       null: false
    t.integer  "mnethostid",          limit: 8,          default: 0,           null: false
    t.string   "username",            limit: 100,        default: "",          null: false
    t.string   "password",                               default: "",          null: false
    t.string   "idnumber",                               default: "",          null: false
    t.string   "firstname",           limit: 100,        default: "",          null: false
    t.string   "lastname",            limit: 100,        default: "",          null: false
    t.string   "name",                limit: 201
    t.string   "email",               limit: 100,        default: "",          null: false
    t.boolean  "emailstop",                              default: false,       null: false
    t.string   "icq",                 limit: 15,         default: "",          null: false
    t.string   "skype",               limit: 50,         default: "",          null: false
    t.string   "yahoo",               limit: 50,         default: "",          null: false
    t.string   "aim",                 limit: 50,         default: "",          null: false
    t.string   "msn",                 limit: 50,         default: "",          null: false
    t.string   "phone1",              limit: 20,         default: "",          null: false
    t.string   "phone2",              limit: 20,         default: "",          null: false
    t.string   "institution",                            default: "",          null: false
    t.string   "department",                             default: "",          null: false
    t.string   "address",                                default: "",          null: false
    t.string   "city",                limit: 120,        default: "",          null: false
    t.string   "country",             limit: 2,          default: "",          null: false
    t.string   "lang",                limit: 30,         default: "en",        null: false
    t.string   "theme",               limit: 50,         default: "",          null: false
    t.string   "timezone",            limit: 100,        default: "99",        null: false
    t.integer  "firstaccess",         limit: 8,          default: 0,           null: false
    t.integer  "lastaccess",          limit: 8,          default: 0,           null: false
    t.integer  "lastlogin",           limit: 8,          default: 0,           null: false
    t.integer  "currentlogin",        limit: 8,          default: 0,           null: false
    t.string   "lastip",              limit: 45,         default: "",          null: false
    t.string   "secret",              limit: 15,         default: "",          null: false
    t.integer  "picture",             limit: 8,          default: 0,           null: false
    t.string   "url",                                    default: "",          null: false
    t.text     "description",         limit: 2147483647
    t.integer  "descriptionformat",   limit: 1,          default: 1,           null: false
    t.boolean  "mailformat",                             default: true,        null: false
    t.boolean  "maildigest",                             default: false,       null: false
    t.integer  "maildisplay",         limit: 1,          default: 2,           null: false
    t.boolean  "autosubscribe",                          default: true,        null: false
    t.boolean  "trackforums",                            default: false,       null: false
    t.integer  "timecreated",         limit: 8,          default: 0,           null: false
    t.integer  "timemodified",        limit: 8,          default: 0,           null: false
    t.integer  "trustbitmask",        limit: 8,          default: 0,           null: false
    t.string   "imagealt"
    t.string   "lastnamephonetic"
    t.string   "firstnamephonetic"
    t.string   "middlename"
    t.string   "alternatename"
    t.string   "calendartype",        limit: 30,         default: "gregorian", null: false
    t.string   "auth_token"
    t.integer  "system_role_id"
    t.integer  "teacher_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "auth_token"
    t.integer  "system_role_id"
    t.integer  "teacher_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "web_contact_forms", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "subject"
    t.text     "msg"
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
