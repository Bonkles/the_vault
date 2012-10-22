class CreateVmtFiles < ActiveRecord::Migration
  def change
    create_table :vmt_files do |t|
      t.string :filename
      t.text :description
      t.datetime :last_updated
      t.string :family
      t.integer :revision
      t.string :last_update_by
      t.boolean :is_locked
      t.text :vmtdata
      t.boolean :eco
      t.boolean :in_agile
      t.string :oem
      t.string :oem_group
      t.timestamps
    end
  end
end