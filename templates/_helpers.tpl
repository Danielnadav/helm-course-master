{{- define "pgadmin.labels" }}
    labels:
        app: pgadmin-ui
        env: {{ .Values.app.name }}
{{- end }}

