# 1. Make a list of Arctos names using:
# SELECT DISTINCT scientific_name FROM flat WHERE guid_prefix in
# ('UAM:Herb', 'UAM:Alg', 'UAM:Myco', 'UAMb:Herb')
# save as arctos_names

# 2. Download the latest WFO:

curl -L https://files.worldfloraonline.org/files/WFO_Backbone/_WFOCompleteBackbone/WFO_Backbone.zip > WFO_Backbone.zip

# WFO is neither CSV nor TSV

gawk 'BEGIN{FS="\t";OFS="|"}{gsub(/\|/,"^",$0);for(i in NF){gsub(/^"/,"",$i);gsub(/"$/,"",$i)} print $0}' classification.csv > classification.psv

