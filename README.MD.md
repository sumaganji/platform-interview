## structural changes
### Previously
```
├── tf
│   ├── main.tf

```
### Now
```
├── tf
│   ├── README.MD
│   ├── dev.tf
│   ├── main.tf
│   ├── prod.tf
│   └── staging.tf
```

### Highlights
* Tf file on the bases of environment for better code seggrigation on environment bases & code readability.
* Code commenting in staging tf file for better code structure undertanding 
 
 ## Adding New Environment

 1 Updated docker-compose.yaml
 * Added network named "staging" for seprate network configuration
 * Added Service for key vault named "staging" to deploy keyvault in staging env.
 * Added host port "8401" & updated value of VAULT_DEV_ROOT_TOKEN_ID for staging env.

2 Updated stanging.tf file
*  Created following resources & configration for key vault: vault_audit, vault_auth_backend, vault_generic_secret, vault_policy, vault_generic_endpoint
*  Created & configured following application container: account_staging, gateway_staging, payment_staging, frontend_staging
*  Updated secrets, evironment variables, netwroking settings, keyvault policies for the staging environment

## CI/CD

For setting Up all the environment (Dev, Staging, Prod) do the following:
1. install and configure vagrant & its dependency.
2. Run ```vagrant up``` command to setup the complete infrastructure.


## Points to consider for production:
1. Secrets should not be written in code and pushed to git repo.
2. In IaC code use of variables & iteration(count or for_each)can be used to promoted DRY(do not repeat youself) Concept