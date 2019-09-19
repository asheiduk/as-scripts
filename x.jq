import "x-mappings" as $mappings;
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
.terms.Reserved[].termAttributes | find_key2($mappings::mappings[].RerservedTerms)

# .terms.Reserved[].termAttributes | debug
