class AddHitToUrl < ActiveRecord::Migration[6.1]
  def change
    add_column :urls, :hits, :integer, default: 0
  end
end
