                        INTERNET
                            |
                      Load Balancer
                            |
                   ┌────────┴────────┐
                   │                 │
                Worker-1          Worker-2
                   │                 │
                   └───── RKE2 ──────┘
                         Cluster
                           |
            ┌──────────────┼──────────────┐
            │              │              │
        Master-1        Master-2        Master-3
         + etcd           + etcd          + etcd


External / persistent systems:

Database
Object Storage   → product images
Persistent Storage → if absolutely needed
Backup Storage
Monitoring
Git Registry


3 x RKE2 server/control-plane
2 x worker
1 x load balancer
private network
mümkünse sadece LB/bastion public
DB public değil
worker/control-plane private IP


| Müşteri problemi                     | Çözüm                                      |
| ------------------------------------ | ------------------------------------------ |
| Kim neyi değiştirdi bilmiyoruz       | Git + GitOps / ArgoCD                      |
| Elle sunucuya dosya atılıyor         | CI/CD                                      |
| Deploy sırasında site kapanıyor      | RollingUpdate / Blue-Green                 |
| Sunucu düşerse site düşüyor          | Kubernetes replicas + HA                   |
| Yoğunlukta site çöktü                | HPA                                        |
| Site bozulunca müşteri söylüyor      | Prometheus + Alertmanager                  |
| Trafik/metrik göremiyoruz            | Prometheus + Grafana                       |
| DB yedeği                            | DB backup + restore test                   |
| Dosyadaki sipariş logları kayboluyor | Persistent storage / merkezi logging       |
| Ürün görselleri kayboluyor           | Object storage                             |
| Şifre kodda                          | Kubernetes Secrets / Vault vb.             |
| Sistem kendi kendini kontrol etsin   | readiness/liveness/startup probes          |
| Erişim kontrolü                      | RBAC + IAM + audit                         |
| DB internete açık                    | private network + firewall/security groups |
| HTTP                                 | TLS + Ingress                              |
| Yeni gelen kişi sistemi anlayabilsin | IaC + Git + dokümantasyon                  |
