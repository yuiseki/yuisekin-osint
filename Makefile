
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

# make recon-domain google.com
#discovery/info_disclosure/interesting_files
recon-domain:
	recon-cli -w $(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/mx_spf_ip -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/brute_hosts -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/certificate_transparency -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/ssl_san -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/netcraft -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/hackertarget -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/threatcrowd -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/threatcrowd -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-hosts/threatcrowd -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/domains-contacts/whois_pocs -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/netblocks-companies/whois_orgs -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=$(filter-out $@,$(MAKECMDGOALS))
	recon-cli -m recon/hosts-hosts/resolve -x -w $(filter-out $@,$(MAKECMDGOALS)) -o SOURCE=default
	mkdir -p ./tmp/$(filter-out $@,$(MAKECMDGOALS))/
	recon-cli -m reporting/csv -x -w $(filter-out $@,$(MAKECMDGOALS)) -o HEADERS=True -o TABLE=hosts -o FILENAME=/workspaces/yuisekin-osint/tmp/$(filter-out $@,$(MAKECMDGOALS))/hostnames.csv
	recon-cli -m reporting/csv -x -w $(filter-out $@,$(MAKECMDGOALS)) -o HEADERS=True -o TABLE=contacts -o FILENAME=/workspaces/yuisekin-osint/tmp/$(filter-out $@,$(MAKECMDGOALS))/contacts.csv

%:
	@:
