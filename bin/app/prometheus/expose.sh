#!/bin/bash
source ./bin/config.sh
set -e

# kubectl apply -f ./manifests/svc.yaml

read -p "请输入访问域名：" DOMAIN

cat >$DIR/gateway.yaml <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana-gateway
  namespace: monitoring
spec:
  selector:
    istio: ingress
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - $DOMAIN
      tls:
        httpsRedirect: false
    - port:
        number: 443
        name: https
        protocol: HTTPS
      tls:
        mode: SIMPLE
        credentialName: monitoring-grafana-tls
      hosts:
        - $DOMAIN

---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana-vsvc
  namespace: monitoring
spec:
  hosts:
    - $DOMAIN
  gateways:
    - grafana-gateway
  http:
    - match:
        - scheme:
            exact: http
          withoutHeaders:
            :path:
              prefix: /.well-known/acme-challenge/
      redirect:
        scheme: https
        redirectCode: 302
    - route:
        - destination:
            host: prometheus-grafana
            port:
              number: 80
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: monitoring-grafana
  namespace: istio-ingress
spec:
  dnsNames:
    - $DOMAIN
  secretName: monitoring-grafana-tls
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
EOF

kubectl apply -f $DIR/gateway.yaml
