.
| .priceDimensions
| [ .[]
|     if .unit == "Hrs" then { hourFee: .USD } 
      elif .unit == "Quantity" then { upfrontFee: .USD }
      else empty end
  ]
| add
