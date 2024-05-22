{{- define "SIToBytes" -}}
{{- $memory := .memory -}}
{{- $matched := (regexMatch `^([0-9]+)(k|M|G|Ki|Mi|Gi)$` $memory) -}}
{{- if (not $matched) -}}
{{- $_ := (fail (printf "Invalid memory amount (%s)" $memory)) -}}
{{- end -}}
{{- $amount := (regexFind `^[0-9]+` $memory) -}}
{{- $unit := (regexFind `(k|M|G|Ki|Mi|Gi)$` $memory) -}}
{{- if eq $unit "k" -}}
{{- mul $amount 1024 -}}
{{- else if eq $unit "M" -}}
{{- mul $amount 1024 1024 -}}
{{- else if eq $unit "G" -}}
{{- mul $amount 1024 1024 1024 -}}
{{- else if eq $unit "Ki" -}}
{{- mul $amount 1024 -}}
{{- else if eq $unit "Mi" -}}
{{- mul $amount 1024 1024 -}}
{{- else if eq $unit "Gi" -}}
{{- mul $amount 1024 1024 1024 -}}
{{- else -}}
{{- $_ := (fail (printf "Something went wrong when parse memory value: " $memory)) -}}
{{- end -}}
{{- end -}}

{{- define "addMemoryOverhead" -}}
{{- $memoryInMb := divf (include "SIToBytes" (dict "memory" .memory)) 1024 1024 -}}
{{- add (mulf $memoryInMb .overhead) $memoryInMb -}}
{{- end -}}

{{- define "getMemoryOverhead" -}}
{{- if .Values.spec.sparkConf -}}
    {{- if index .Values.spec.sparkConf "spark.driver.memoryOverheadFactor" -}}
    {{- index .Values.spec.sparkConf "spark.driver.memoryOverheadFactor" -}}
    {{- else if index .Values.spec.sparkConf "spark.kubernetes.memoryOverheadFactor" -}}
    {{- index .Values.spec.sparkConf "spark.kubernetes.memoryOverheadFactor" -}}
    {{- else -}}
    {{- 0.1 -}}
    {{- end -}}
{{- else -}}
{{- 0.1 -}}
{{- end -}}
{{- end -}}
