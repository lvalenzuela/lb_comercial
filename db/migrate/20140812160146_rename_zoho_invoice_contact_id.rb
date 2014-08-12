class RenameZohoInvoiceContactId < ActiveRecord::Migration
  def up
  	rename_column :zoho_invoices, :contact_id, :customer_id
  end

  def down
  	rename_column :zoho_invoices, :customer_id, :contact_id
  end
end
