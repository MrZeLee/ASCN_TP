# Persistent Volume Claim for MySQL pod
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv
  namespace: {{ namespace }}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 10Gi