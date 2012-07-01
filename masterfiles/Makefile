#

POLICY_FILES=cfengine_stdlib.cf promises.cf library.cf base.cf ocemr.cf

INPUTS_DIR=/var/lib/cfengine3/inputs


##########################################

all: check


install: $(POLICY_FILES) $(addprefix templates/,$(TEMPLATES))
	
	if [ ! -d $(INPUTS_DIR)/templates ]; then \
	  mkdir -p $(INPUTS_DIR)/templates; \
	  fi
	
	if [ ! -d $(INPUTS_DIR)/data ]; then \
	  mkdir -p $(INPUTS_DIR)/data; \
	  fi
	
	install --owner=root --group=root --mode=644 \
	  $(POLICY_FILES) $(INPUTS_DIR)
	
	install --owner=root --group=root --mode=644 \
	  templates/*.dat $(INPUTS_DIR)/templates

	install --owner=root --group=root --mode=644 \
	  data/* $(INPUTS_DIR)/data


check: $(POLICY_FILES)
	
	/usr/sbin/cf-promises -Ivf ./promises.cf
	

.PHONY: all check install

