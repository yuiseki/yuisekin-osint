
osint:
	make nslookup $(filter-out $@,$(MAKECMDGOALS))
	make whois $(filter-out $@,$(MAKECMDGOALS))
	make dig $(filter-out $@,$(MAKECMDGOALS))
	make geoip $(filter-out $@,$(MAKECMDGOALS))

# make nslookup google.com
nslookup:
	nslookup $(filter-out $@,$(MAKECMDGOALS))

# make whois google.com
whois:
	whois $(filter-out $@,$(MAKECMDGOALS))

# make dig google.com
dig:
	dig $(filter-out $@,$(MAKECMDGOALS))

# make geoip google.com
geoip:
	geoiplookup $(filter-out $@,$(MAKECMDGOALS))

# make asn google.com
asn:
	asn $(filter-out $@,$(MAKECMDGOALS))

# make recon-domains google.com
recon-domains:
	recon-cli -w $(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/certificate_transparency -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/ssl_san -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))

# make recon-results google.com
recon-results:
	recon-cli -m reporting/csv -x -w $(filter-out $@,$(MAKECMDGOALS)) -o HEADERS=hostname -o FILENAME=./recon.csv

%:
	@: