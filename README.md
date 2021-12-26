# Template Engine for Docx

## Deploy
helm upgrade --install --wait --create-namespace --namespace=dte-ns -f values.yaml --set regcred=$GITHUB_REGISTRY_CREDS --set host=$INGRESS_HOST dte . 
