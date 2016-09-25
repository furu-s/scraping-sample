class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :image_path
      t.date :published_date
      t.boolean :published

      t.timestamps null: false
    end
  end
end
