---

apiVersion: v1
kind: Service
metadata:
  name: ghost
  namespace: {{ namespace }}
spec:
  type: LoadBalancer
  selector:
    app: ghost
  ports:
  - name: http
    protocol: TCP
    port: {{ ghost_port }}
    targetPort: 2368