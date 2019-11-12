import "aws-mappings" as $mappings;
def find_key($map; $value):
	$map | to_entries[] | select( .value == $value ) | .key;
	
def find_key2($map):
	. as $input | $map | to_entries[] | select( .value == $input ) | .key;
	
# $mappings::mappings[].RerservedTerms."STD-PU-1yr",
# $mappings::mappings[].RerservedTerms."STD-PU-1yr" == { "PurchaseOption": "Partial Upfront",	"LeaseContractLength": "1yr", "OfferingClass": "standard" },
# $mappings::mappings[].RerservedTerms | to_entries[] | select( .value == { "PurchaseOption": "Partial Upfront",	"LeaseContractLength": "1yr", "OfferingClass": "standard" }) | .key

# OK: 
# find_key($mappings::mappings[].RerservedTerms; { "PurchaseOption": "Partial Upfront",	"LeaseContractLength": "1yr", "OfferingClass": "standard" } )

# OK:
# { "PurchaseOption": "Partial Upfront",	"LeaseContractLength": "1yr", "OfferingClass": "standard" } | find_key2($mappings::mappings[].RerservedTerms)

# OK
# .terms.Reserved[].termAttributes | find_key2($mappings::mappings[].RerservedTerms)

# OK
# .terms.Reserved[].termAttributes |= find_key2($mappings::mappings[].RerservedTerms)

# OK
# .terms.Reserved[].termAttributes |= find_key2($mappings::mappings[].RerservedTerms)
#	| .terms.Reserved |= with_entries( .key = .value.termAttributes | del(.value.termAttributes) )

# FAIL
# .terms.Reserved |= map( {.termAttributes | find_key2($mappings::mappings[].RerservedTerms): 42 } )


# OK
#.terms.Reserved[].priceDimensions |= {
#	"Upfront Fee": .[] | select(.unit == "Quantity").pricePerUnit.USD,
#	Hrs: .[] | select(.unit == "Hrs").pricePerUnit.USD
#}

# OK - mostly - No-Upfront does not work - perhaps due to missing "upfrontFee"?
.terms.Reserved |= with_entries(
	.key = (.value.termAttributes | find_key2($mappings::mappings[].RerservedTerms)) |
	.value |= (.priceDimensions | { 
		upfrontFee: .[] | select(.unit == "Quantity").pricePerUnit.USD,
#		upfrontFee: .[] | select(false).pricePerUnit.USD,
		hourFee:    .[] | select(.unit == "Hrs").pricePerUnit.USD
	})
#	.
)

# TODO: '{upfront: (first(.priceDimensions[] | select(false)) // 42) , hour: last(.priceDimensions[] | select(true)) }'


# alternatives:
# - use `rtrimstr($SKU+".")` on keys for `.terms[][]` and use the hex-id for mapping
# - use from_entries upon priceDimensions and create tuples and "upfrontFee" and "hourFee".


# .terms.Reserved[].termAttributes | debug
