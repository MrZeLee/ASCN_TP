{
  "name": "projects/{{ gcp_project }}/alertPolicies/17577962871074960258",
  "displayName": "CPU load > 80%",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - CPU utilization (OS reported)",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/cpu/utilization\" AND metadata.system_labels.state != \"idle\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_MEAN"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 80
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