class FixTypoOnSupportsTransactionId < ActiveRecord::Migration
  def change
    rename_column :supports, :translaction_id, :transaction_id
  end
end
