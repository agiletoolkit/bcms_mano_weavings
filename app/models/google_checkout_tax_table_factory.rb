class GoogleCheckoutTaxTableFactory
  def effective_tax_tables_at(time)
      table1 = Google4R::Checkout::TaxTable.new(false)
      table1.name = "Default Tax Table"
      [ table1 ]
  end
end
