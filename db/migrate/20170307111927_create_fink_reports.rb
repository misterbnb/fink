class CreateFinkReports < ActiveRecord::Migration
  def change
    create_table :fink_reports do |t|
      t.timestamps
      t.string :kind
      t.integer :kind_id
      t.text :url
    end
  end
end
