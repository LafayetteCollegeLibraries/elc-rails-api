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

ActiveRecord::Schema.define(version: 20171027181244) do

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.integer "drupal_node_id"
    t.string "drupal_node_type", default: "node"
  end

  create_table "items", force: :cascade do |t|
    t.integer "work_id"
    t.string "drupal_node_type", default: "node"
    t.integer "drupal_node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "volume"
    t.string "year"
    t.string "issue"
    t.index ["work_id"], name: "index_items_on_work_id"
  end

  create_table "items_loans", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "loan_id"
    t.index ["item_id"], name: "index_items_loans_on_item_id"
    t.index ["loan_id"], name: "index_items_loans_on_loan_id"
  end

  create_table "ledgers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.string "label"
    t.datetime "checkout_date"
    t.datetime "return_date"
    t.string "ledger_filename"
    t.integer "shareholder_id"
    t.integer "representative_id"
    t.string "drupal_node_type", default: "node"
    t.integer "drupal_node_id"
    t.integer "ledger_id"
    t.string "volumes"
    t.string "issues"
    t.string "years"
    t.string "csv_source"
    t.index ["ledger_id"], name: "index_loans_on_ledger_id"
    t.index ["representative_id"], name: "index_loans_on_representative_id"
    t.index ["shareholder_id"], name: "index_loans_on_shareholder_id"
  end

  create_table "patrons", force: :cascade do |t|
    t.string "name"
    t.integer "drupal_node_id"
    t.string "drupal_node_type", default: "node"
  end

  create_table "patrons_person_types", id: false, force: :cascade do |t|
    t.integer "patron_id"
    t.integer "person_type_id"
    t.index ["patron_id"], name: "index_patrons_person_types_on_patron_id"
    t.index ["person_type_id"], name: "index_patrons_person_types_on_person_type_id"
  end

  create_table "person_types", force: :cascade do |t|
    t.string "label"
    t.string "drupal_node_type", default: "taxonomy"
    t.integer "drupal_node_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "label"
    t.integer "drupal_node_id"
    t.string "drupal_node_type", default: "taxonomy"
  end

  create_table "subjects_works", id: false, force: :cascade do |t|
    t.integer "work_id"
    t.integer "subject_id"
    t.index ["subject_id"], name: "index_subjects_works_on_subject_id"
    t.index ["work_id"], name: "index_subjects_works_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.integer "author_id"
    t.string "title"
    t.string "format"
    t.integer "number"
    t.string "drupal_node_type", default: "node"
    t.integer "drupal_node_id"
    t.boolean "missing_from_csv", default: false
    t.index ["author_id"], name: "index_works_on_author_id"
  end

end
