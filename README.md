# Spark Local Chart
## Why local mode?
Sometimes, you want to use Spark because it scales well, but currently, you have limited resources and want to conserve them. This is where local mode comes in.
## Value file syntax 
The value file syntax is similar to the spark-on-k8s-operator, making it easier to convert your jobs to cluster mode. You can reuse your existing values file.

## Example value file

````yaml
metadata:
  name: spark-pi
  namespace: spark
spec:
  imagePullSecrets:
    - my-secret
  sparkConf:
    spark.ui.proxyRedirectUri: "/"
  image: apache/spark:3.5.1
  imagePullPolicy: Always
  mainClass: org.apache.spark.examples.SparkPi
  mainApplicationFile: /opt/spark/examples/jars/spark-examples_2.12-3.5.1.jar
  arguments:
    - 1000
  restartPolicy:
    type: Never
  driver:
    cores: 1
    coreLimit: 1
    memory: 1G
    secrets:
    - name: hadoop-conf
      path: /opt/hadoop/conf
    configMaps:
    - name: my-conf
      path: /opt/my-conf
    env:
    - name: MY_ENV
      value: my_env
    - name: CONFIG_MAP_ENV
      valueFrom:
        configMapKeyRef:
          name: my-config-map
          key: my_key
    - name: SECRET_ENV
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: MY_SECRET
````
