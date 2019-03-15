class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :amount_paid
      t.string :plan_id
      t.string :card_number
      t.string :invoice_interval
      t.boolean :invoice_paid
      t.string :invoice_currency
      t.string :stripe_invoice_id
      t.references :admin  
      t.timestamps
    end
  end
end
