class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :access_key
      t.string :secret_access_key

      t.timestamps
    end
  end
end
