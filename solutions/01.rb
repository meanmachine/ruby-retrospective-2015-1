class Object
  def convert_to_bgn(price, unit)
    rate_to_bgn = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}
    (price * rate_to_bgn[unit]).round 2
  end

  def compare_prices(first_price, first_unit, second_price, second_unit)
      first_price_bgn  = convert_to_bgn(first_price, first_unit)
	  second_price_bgn = convert_to_bgn(second_price, second_unit)
	  first_price_bgn <=> second_price_bgn
  end
end