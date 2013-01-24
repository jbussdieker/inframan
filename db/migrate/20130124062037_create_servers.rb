class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :public_ip
      t.string :private_ip
      t.integer :region_id
      t.string :instance_id
      t.string :image_id

      t.timestamps
    end
  end
end
