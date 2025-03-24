MOSQ_STAGING := ../../../staging/tmp/sd/HACK
PLUGIN_NAME = mqtt_mitm_auth
PLUGIN_SRC  = $(PLUGIN_NAME).c
PLUGIN_OUT  := $(MOSQ_STAGING)/usr/lib/$(PLUGIN_NAME).so
MOSQ_INC := -I$(MOSQ_STAGING)/usr/include

all: $(PLUGIN_OUT)

$(PLUGIN_OUT): $(PLUGIN_SRC)
	@echo "-> Baue MQTT Auth Plugin: $(PLUGIN_NAME).so via $(MOSQ_INC)"
	$(CC) -Wall -fPIC -shared -DMOSQ_AUTH_PLUGIN_VERSION=4 $(MOSQ_INC) -o $@ $^

clean:
	rm -f $(PLUGIN_OUT)
