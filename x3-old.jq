.priceDimensions |=
{
	ufrontFee: .[] | select(.unit == "Quantity") | .USD,
    hourFee:   .[] | select(.unit == "Hrs").USD
}
