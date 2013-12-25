class CreateStories < ActiveRecord::Migration

  def change
    create_table :stories do |t|
      t.string :text
      t.string :classify
      t.float  :total_score
      t.string :scores

      t.timestamps
    end
  end
end
