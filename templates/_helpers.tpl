{{- define "pgadmin.labels" }}
    labels:
        app: pagdmin-ui
        env: {{ .Values.app.env }}
{{- end }}

