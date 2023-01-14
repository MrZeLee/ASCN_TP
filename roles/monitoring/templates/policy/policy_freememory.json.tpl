{
  "name": "projects/{{ gcp_project }}/alertPolicies/17577962871074960257",
  "displayName": "Free memory < 10%",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Memory utilization",
      "conditionMonitoringQueryLanguage": {
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "query": "fetch gce_instance\n| metric 'agent.googleapis.com/memory/percent_used'\n| filter (metric.state == 'free')\n| group_by 5m, [value_percent_used_mean: mean(value.percent_used)]\n| every 5m\n| condition val() < 10 '%'"
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "projects/{{ gcp_project }}/notificationChannels/4769193409311441356"
  ]
}