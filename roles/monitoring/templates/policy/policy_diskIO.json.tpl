{
  "name": "projects/{{ gcp_project }}/alertPolicies/17577962871074960256",
  "displayName": "Disk I/0 time above 80ms",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Disk I/O time",
      "conditionThreshold": {
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/disk/io_time\"",
        "thresholdValue": 80,
        "trigger": {
          "count": 1
        }
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