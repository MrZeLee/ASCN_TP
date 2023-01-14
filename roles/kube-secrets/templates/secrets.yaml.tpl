kind: Namespace
apiVersion: v1
metadata:
  name: {{ namespace }}
  labels:
    name: ghost

{% for secret in secrets %}

---

apiVersion: v1
kind: Secret
metadata:
  name: mysecret
  namespace: {{ namespace }}
  labels:
    environment: {{ secret.environment }}
  creationTimestamp: null
type: Opaque
data:
  {% for element in secret.data -%}
  {{ element }}: {{ secret.data[element] | b64encode }}
  {% endfor %}

{% endfor %}
