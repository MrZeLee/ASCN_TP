---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: ghost
  labels:
    app: ghost
    namespace: {{ namespace }}
    environment: ghost
spec:
  replicas: {{ min_replicas_ghost }}
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app: ghost
  template:
    metadata:
      labels:
        app: ghost
    spec:
      initContainers:
      - name: wait-for-db
        image: busybox:1.32
        command: ['sh', '-c', 'until nslookup db; do echo waiting for db; sleep 2; done']
      containers:
      - image: ghost:5.14.1
        name: ghost
        resources:
          requests: 
            cpu: "{{ cpu_request_ghost }}"
            memory: "{{ memory_request_ghost }}"
          limits:
            cpu: "{{ cpu_limit_ghost }}"
        ports:
        - containerPort: 2368
#        livenessProbe:
#          httpGet:
#            path: /
#            port: {{ ghost_port }}
#          initialDelaySeconds: 40
#          periodSeconds: 20
#          timeoutSeconds: 10
        env:
        - name: database__client
          value: mysql
        - name: database__connection__host
          value: db
        - name: database__connection__user
          value: root
        - name: database__connection__password
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: db_password
        - name: database__connection__database
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: db_name
        - name: url
          value: http://{{ ghost_ip }}:{{ ghost_port }}/
        - name: mail__transport
          value: {{ mail__transport }}
        - name: mail__from
          value: "{{ mail__from }}"
        - name: mail__options__host
          value: {{ mail__options__host }}
        - name: mail__options__port
          value: "{{ mail__options__port }}"
        - name: mail__options__auth__user
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: mail__auth__user
        - name: mail__options__auth__pass
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: mail__auth__pass
        - name: mail__options__service
          value: {{ mail__options__service }}
        - name: mail__options__secure
          value: "{{ mail__options__secure }}"
#        - name: NODE_ENV
#          value: development

# ---

# apiVersion: v1
# kind: Service
# metadata:
#   name: ghost
# spec:
#   type: LoadBalancer
#   selector:
#     app: ghost
#   ports:
#   - name: http
#     protocol: TCP
#     port: {{ ghost_port }}
#     targetPort: 2368


---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: db
  labels:
    app: db
    namespace: {{ namespace }}
    environment: ghost
spec:
  replicas: 1
  revisionHistoryLimit: 0
  selector:
    matchLabels:
      app: db
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - image: mysql:8.0
        name: db
        resources:
          requests: 
            cpu: "{{ cpu_request_db }}"
            memory: "{{ memory_request_db }}"
          limits:
            cpu: "{{ cpu_limit_db }}"
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: db_password
        - name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: db_name
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
        livenessProbe:
          exec:
            command:
            - /bin/sh
            - -ec
            - >-
              mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD ping
          initialDelaySeconds: 60
          periodSeconds: 30
          timeoutSeconds: 10
        readinessProbe:
          exec:
            # Check we can execute queries over TCP (skip-networking is off).
            command:
            - /bin/sh
            - -ec
            - >-
              mysql -h127.0.0.1 -uroot -p$MYSQL_ROOT_PASSWORD -e'SELECT 1'
          initialDelaySeconds: 5
          periodSeconds: 2
          timeoutSeconds: 1
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv

---

apiVersion: v1
kind: Service
metadata:
  name: db
  namespace: {{ namespace }}
spec:
  type: ClusterIP
  selector:
    app: db
  ports:
  - name: mysql
    protocol: TCP
    port: 3306
    targetPort: 3306

---

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ghost
  namespace: {{ namespace }}
spec:
  maxReplicas: {{ max_replicas_ghost }}
  metrics:
  - resource:
      name: cpu
      target:
        averageValue: {{ cpu_ha }}
        type: AverageValue
    type: Resource
  minReplicas: {{ min_replicas_ghost }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ghost