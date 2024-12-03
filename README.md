![Logo](https://avatars.githubusercontent.com/u/79948663?s=200&v=4)

# Tech Challenge - FIAP TECH 2024

Este repositório contém o código fonte da infraestrutura em Terraform com K8s desenvolvida para o projeto do Tech Challenge referente a pós-graduação da FIAP TECH no ano de 2024:

## Arquitetura
![Arquitetura](.assests/arquitetura.png)

## Stack utilizada

**Infra:** Terraform e K8s

## Rodando localmente

Clone o projeto:

```bash
  git clone https://link-para-o-projeto
```

Entre no diretório do projeto:

```bash
  cd ftc4-terraform
```

Instale as dependências e módulos do diretório com o Terraform:

```bash
  terraform init
```

Execute o comando de `plan` para criar um preview das alterações:

```bash
  terraform plan
```

Execute o comando de `apply` para aplicar as alterações e subir a aplicação:

```bash
  terraform apply
```

## Documentação

Este repositório contém uma infraestrutura Kubernetes provisionada via Terraform. A seguir, a estrutura de pastas do projeto e uma breve descrição de cada módulo.

### Estrutura de Pastas

### modules/

Esta pasta contém os módulos reutilizáveis para provisionar diferentes componentes da infraestrutura de forma modular.

-  **app-client/**: Define o deployment, serviço e configuração do aplicativo app-client que será executado no cluster Kubernetes.
-  **app-order/**: Define o deployment, serviço e configuração do aplicativo app-order que será executado no cluster Kubernetes.
-  **app-payment/**: Define o deployment, serviço e configuração do aplicativo app-payment que será executado no cluster Kubernetes.
-  **app-product/**: Define o deployment, serviço e configuração do aplicativo app-product que será executado no cluster Kubernetes.
-  **eks-cluster/**: Provisiona o cluster EKS (Elastic Kubernetes Service), incluindo configuração do plano de controle e integração com o IAM.
-  **namespaces/**: Módulo responsável por criar e gerenciar namespaces no cluster Kubernetes, proporcionando isolamento para diferentes ambientes e serviços.
-  **nodes/**: Gerencia os nós de trabalho (worker nodes) do cluster EKS, incluindo a configuração de grupos de nós e roles do IAM.

### Arquivos na raiz

-  **main.tf**: Arquivo principal do Terraform que orquestra a criação da infraestrutura e integra os diferentes módulos do projeto.
-  **readme.md**: Este arquivo, contendo a documentação do projeto.

## Autores

-  [@Bruno Campos](https://github.com/brunocamposousa)
-  [@Bruno Oliveira](https://github.com/bgoulart)
-  [@Diógenes Viana](https://github.com/diogenesviana)
-  [@Filipe Borba](https://www.github.com/filipexxborba)
-  [@Rhuan Patriky](https://github.com/rhuanpk)