# API Endpoints

## collections
- **GET** `/collections:list`
- **GET** `/collections:get`
- **POST** `/collections:create`
- **POST** `/collections:update`
- **POST** `/collections:destroy`
- **POST** `/collections:move`
- **POST** `/collections:setFields`

### collections.fields
- **GET** `/collections/{collectionName}/fields:get`
- **GET** `/collections/{collectionName}/fields:list`
- **POST** `/collections/{collectionName}/fields:create`
- **POST** `/collections/{collectionName}/fields:update`
- **POST** `/collections/{collectionName}/fields:destroy`
- **POST** `/collections/{collectionName}/fields:move`

## collectionCategories
- **POST** `/collectionCategories:list`
- **POST** `/collectionCategories:get`
- **POST** `/collectionCategories:create`
- **POST** `/collectionCategories:update`
- **POST** `/collectionCategories:destroy`
- **POST** `/collectionCategories:move`

## dbViews
- **GET** `/dbViews:get` - Get db view fields
- **GET** `/dbViews:list` - List views that are not connected to collections in database
- **GET** `/dbViews:query` - Query db view data

## $collection
- **GET** `/{collectionName}:list` - Returns a list of the collection
- **GET** `/{collectionName}:get` - Returns a record
- **POST** `/{collectionName}:create` - Create record
- **POST** `/{collectionName}:update` - Update record
- **POST** `/{collectionName}:destroy` - Delete record
- **POST** `/{collectionName}:move` - Move record
- **POST** `/{collectionName}:export`
- **POST** `/{collectionName}:importXlsx`
- **POST** `/{collectionName}:downloadXlsxTemplate`
- **POST** `/{fileCollectionName}:create`

### $collection.$oneToOneAssociation
- **GET** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:get` - Returns the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:create` - Create and associate a record
- **POST** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:update` - Update the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:destroy` - Delete and disassociate the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:set` - Associate a record
- **POST** `/{collectionName}/{collectionIndex}/{oneToOneAssociation}:remove` - Disassociate the relationship record

### $collection.$manyToOneAssociation
- **GET** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:get` - Returns the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:create` - Create and associate a record
- **POST** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:update` - Update the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:destroy` - Delete and disassociate the relationship record
- **POST** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:set` - Associate a record
- **POST** `/{collectionName}/{collectionIndex}/{manyToOneAssociation}:remove` - Disassociate the relationship record

### $collection.$oneToManyAssociation
- **GET** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:list` - Returns a list of the one-to-many relationship
- **GET** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:get` - Returns a record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:create` - Create and attach record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:update` - Update record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:destroy` - Delete and detach record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:move` - Move record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:set` - Set or reset associations
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:add` - Attach record
- **POST** `/{collectionName}/{collectionIndex}/{oneToManyAssociation}:remove` - Detach record

### $collection.$manyToManyAssociation
- **GET** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:list` - Returns a list of the many-to-many relationship
- **GET** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:get` - Returns a record of the many-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:create` - Create and attach record of the many-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:update` - Update record of the many-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:destroy` - Delete and detach record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:move` - Move record of the one-to-many relationship
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:set` - Set or reset associations
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:add` - Attach record
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:remove` - Detach record
- **POST** `/{collectionName}/{collectionIndex}/{manyToManyAssociation}:toggle` - Attach or detach record

## app
- **GET** `/app:getLang`
- **GET** `/app:getInfo`
- **GET** `/app:getPlugins`
- **POST** `/app:restart`
- **POST** `/app:clearCache`

## pm
- **POST** `/pm:enable`
- **POST** `/pm:disable`
- **POST** `/pm:remove`

## roles
- **GET** `/roles:list`
- **GET** `/roles:get`
- **POST** `/roles:create`
- **POST** `/roles:update`
- **POST** `/roles:destroy`
- **GET** `/roles:check`
- **POST** `/roles:setDefaultRole`

### roles.collections
- **GET** `/roles/{roleName}/collections:list`

## availableActions
- **GET** `/availableActions:list`

## Auth
- **GET** `/auth:check` - Basic auth
- **POST** `/auth:signIn`
- **POST** `/auth:signUp`
- **POST** `/auth:signOut`
- **POST** `/auth:changePassword`

### Authenticator
- **GET** `/authenticators:listTypes`
- **GET** `/authenticators:publicList`
- **POST** `/authenticators:create`
- **GET** `/authenticators:list`
- **GET** `/authenticators:get`
- **POST** `/authenticators:update`
- **POST** `/authenticators:destroy`

## storages
- **GET** `/storages:list`
- **GET** `/storages:get`
- **POST** `/storages:create`
- **POST** `/storages:update`
- **POST** `/storages:destroy`

## default
- **GET** `/systemSettings:get`
- **POST** `/systemSettings:update`

## uiSchemas
- **GET** `/uiSchemas:getJsonSchema/{uid}`
- **GET** `/uiSchemas:getProperties/{uid}`
- **POST** `/uiSchemas:insert`
- **POST** `/uiSchemas:remove/{uid}`
- **POST** `/uiSchemas:patch`
- **POST** `/uiSchemas:batchPatch`
- **POST** `/uiSchemas:clearAncestor/{uid}`
- **POST** `/uiSchemas:insertAdjacent/{uid}`
- **POST** `/uiSchemas:saveAsTemplate`

## Push
- **POST** `/userData:push`

## users
- **GET** `/users:list`
- **GET** `/users:get`
- **POST** `/users:create`
- **POST** `/users:update`
- **POST** `/users:destroy`

## verifications
- **GET** `/verifications:list`
- **GET** `/verifications:get`
- **POST** `/verifications:create`
- **POST** `/verifications:update`
- **POST** `/verifications:destroy`

## verifications_providers
- **GET** `/verifications_providers:list`
- **POST** `/verifications_providers:create`
- **POST** `/verifications_providers:update`
- **POST** `/verifications_providers:destroy`

## workflows
- **GET** `/workflows:list`
- **GET** `/workflows:get`
- **POST** `/workflows:create`
- **POST** `/workflows:update`
- **POST** `/workflows:destroy`
- **POST** `/workflows:revision`
- **POST** `/workflows:trigger`

### workflows.nodes
- **POST** `/workflows/{workflowId}/nodes:create`

## flow_nodes
- **POST** `/flow_nodes:update`
- **POST** `/flow_nodes:destroy`

## executions
- **GET** `/executions:list`
- **GET** `/executions:get`

## workflowManualTasks
- **GET** `/workflowManualTasks:list`
- **GET** `/workflowManualTasks:get`
- **POST** `/workflowManualTasks:submit`

## themeConfig
- **GET** `/themeConfig:list`
- **POST** `/themeConfig:create`
- **POST** `/themeConfig:update`
- **POST** `/themeConfig:destroy`

## swagger
- **GET** `/swagger:getUrls`

## localization
- **POST** `/localization:sync`
- **POST** `/localization:publish`

## localizationTexts
- **GET** `/localizationTexts:list`

## localizationTranslations
- **POST** `/localizationTranslations:updateOrCreate`

## apiKeys
- **POST** `/apiKeys:create`
- **GET** `/apiKeys:list`
- **DELETE** `/apiKeys:destroy/{filterByTk}`

## applications
- **GET** `/applications:list`
- **POST** `/applications:create`
- **POST** `/applications:update`
- **POST** `/applications:destroy`

## map-configuration
- **GET** `/map-configuration:get`
- **POST** `/map-configuration:set`

## chinaRegions
- **GET** `/chinaRegions:list`

## Schemas
- `role`
- `user`
- `roles`
- `authenticator`
- `uiSchema`
- `userData`
- `department`
- `workflow`
- `node`
- `execution`
- `job`
- `user_job`
- `Theme`
- `apiKeys`
- `applicationFrom`
- `application`
- `mapConfiguration`
- `error`
