#

POLICY_FILES=base.cf cfengine_stdlib.cf promises.cf
TEMPLATES=net_interfaces.dat net_hostname.dat net_mailname.dat net_hosts.dat \
	net_resolv_conf.dat net_dnsmasq_conf.dat

INPUTS_DIR=/var/lib/cfengine3/inputs


##########################################

all: check


install: $(POLICY_FILES) $(addprefix templates/,$(TEMPLATES))
	
	if [ ! -d $(INPUTS_DIR)/templates ]; then \
	  mkdir -p $(INPUTS_DIR)/templates; \
	  fi
	
	install --owner=root --group=root --mode=644 \
	  $(POLICY_FILES) $(INPUTS_DIR)
	
	install --owner=root --group=root --mode=644 \
	  $(addprefix templates/,$(TEMPLATES)) $(INPUTS_DIR)/templates


check: $(POLICY_FILES)
	
	/usr/sbin/cf-promises -Ivf ./promises.cf
	

.PHONY: all check install

