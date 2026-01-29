# Modernização do Projeto

Este documento descreve, em detalhes, como a modernização do projeto foi feita, quais mudanças foram aplicadas e por quê. Ele serve como guia de referência para quem for entender a nova arquitetura, os novos componentes e os pontos de atenção ao atualizar um ambiente local.  

## 1. Objetivos da modernização

Os objetivos principais foram:

- **Atualizar o stack para versões estáveis e suportadas** do Spring Boot e Spring Cloud.  
- **Substituir componentes obsoletos** (Zuul, Hystrix, Ribbon e OAuth2 legado) por soluções atuais.  
- **Simplificar a arquitetura** e tornar a base mais preparada para escalabilidade, observabilidade e manutenção.  

## 2. Atualização de versões (plataforma base)

### 2.1 Spring Boot e Java

Todos os serviços foram atualizados para:

- **Spring Boot 3.3.5**
- **Java 17**

Essa mudança garante compatibilidade com as versões mais recentes do Spring Framework (6.x), além de trazer melhorias de performance, segurança e suporte a features modernas da JVM.  

### 2.2 Spring Cloud

Os módulos que usam Spring Cloud foram alinhados com:

- **Spring Cloud 2023.0.4**

Essa versão é compatível com Spring Boot 3.3.x e traz melhorias de estabilidade e integração com o ecossistema atual do Spring.  

## 3. Migração de componentes obsoletos

### 3.1 Gateway

**Antes:** Zuul  
**Agora:** Spring Cloud Gateway  

Mudanças principais:

- Remoção do `spring-cloud-starter-netflix-zuul`
- Adição do `spring-cloud-starter-gateway`
- Migração das rotas para `spring.cloud.gateway.routes[...]`
- Segurança migrada para WebFlux com `SecurityWebFilterChain`

O Gateway agora trabalha de forma reativa, com melhor desempenho e compatibilidade com o stack atual.  

### 3.2 Balanceamento de carga

**Antes:** Ribbon (Netflix)  
**Agora:** Spring Cloud LoadBalancer  

Mudanças principais:

- Remoção de `spring-cloud-starter-netflix-ribbon`
- Adição de `spring-cloud-starter-loadbalancer`

O LoadBalancer é o substituto oficial do Ribbon dentro do Spring Cloud.  

### 3.3 Resiliência / Circuit Breaker

**Antes:** Hystrix  
**Agora:** Resilience4j  

Mudanças principais:

- Remoção de `spring-cloud-starter-netflix-hystrix`
- Adição de `spring-cloud-starter-circuitbreaker-resilience4j`
- Substituição do `@HystrixCommand` por `@CircuitBreaker`
- Inclusão das configurações de circuit breaker em `application.properties`

O Resilience4j é a biblioteca recomendada oficialmente e oferece maior flexibilidade e observabilidade.  

### 3.4 OAuth2

**Antes:** Spring OAuth2 legado  
**Agora:** Spring Authorization Server  

Mudanças principais:

- Remoção de classes baseadas em `AuthorizationServerConfigurerAdapter`
- Criação de nova configuração com `OAuth2AuthorizationServerConfiguration`
- Inclusão do `spring-security-oauth2-authorization-server`
- Geração dinâmica de chaves RSA para JWT (classe `Jwks`)
- Ajuste do cliente OAuth em `RegisteredClientRepository`

Essa migração é necessária porque o Spring OAuth2 legado está descontinuado e não é compatível com o Spring Boot 3.  

## 4. Migração para Jakarta EE

O Spring Boot 3 utiliza Jakarta EE, então as importações `javax.persistence` foram migradas para `jakarta.persistence`.  

Isso afetou as entidades JPA dos serviços `hr-user` e `hr-worker`.  

## 5. Ajustes em configuração centralizada

No Spring Boot 3, o uso de `bootstrap.properties` foi removido em favor do novo modelo:

```properties
spring.config.import=optional:configserver:http://localhost:8888
```

Assim, os serviços configurados para o Config Server agora usam `spring.config.import` dentro de `application.properties`.  

## 6. Segurança e JWT no Gateway

O Gateway agora funciona como **Resource Server** validando tokens JWT emitidos pelo Authorization Server.  

As permissões foram ajustadas via `SecurityWebFilterChain` com base em escopos (`SCOPE_operator`, `SCOPE_admin`), seguindo o padrão OAuth2 moderno.  

## 7. Resumo das principais alterações por serviço

### hr-api-gateway-zuul

- Migrado de Zuul para Spring Cloud Gateway
- Implementação reativa de segurança (WebFlux)
- Configuração de rotas via propriedades  

### hr-oauth

- Migrado para Spring Authorization Server
- JWT com chaves RSA dinâmicas
- Novo modelo de cliente OAuth2  

### hr-payroll

- Substituição de Hystrix por Resilience4j  
- Substituição de Ribbon por LoadBalancer  

### hr-user / hr-worker

- Atualização para Jakarta EE  
- Ajustes para o novo bootstrap de configuração  

## 8. Próximos passos recomendados

Para quem for continuar a evolução do projeto:

- Considerar um **Config Server mais seguro** com autenticação/criptação de secrets.  
- Evoluir o **Authorization Server** para persistir clientes e tokens em banco.  
- Habilitar observabilidade com **Micrometer + Prometheus + Grafana**.  
- Atualizar a documentação do Postman com novos endpoints e fluxos OAuth2.
