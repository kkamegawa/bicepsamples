# This folder contains the web-related bicep files for the project

This folder contains the web-related bicep files for the project.

## Contents

- [Azure Function Consumption Plan](./function-consumption-plan.bicep)
- [Azure Logic Apps Consumption Plan](./logic-apps-consumption-plan.bicep)

## Usage

### Functions

```bash
az deployment group create \
  --name <deployment-name> \
  --resource-group <resource-group-name> \
  --template-file function_consumption_public.bicep \
  --parameters function-consumption-plan.bicepparam
```

### Logic Apps

```bash
az deployment group create \
  --name <deployment-name> \
  --resource-group <resource-group-name> \
  --template-file logicapps_consumption_public.bicep \
  --parameters logic-apps-consumption-plan.bicepparam
```
