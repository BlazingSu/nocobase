# 这是nocobase的官方开发文档，里面包含有对应的示例代码

TITLE: Defining Standalone and Association Resources in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define both standalone (`posts`) and association resources (`posts.user`, `posts.coments`) using `app.resource()` in NocoBase. It illustrates the structure for linking related data entities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
// Equivalent to app.resourcer.define()

// Define article resources
app.resource({
  name: 'posts',
});

// Define the article's author resource
app.resource({
  name: 'posts.user',
});

// Define the article's comment resource
app.resource({
  name: 'posts.coments',
});
```

----------------------------------------

TITLE: Perform Basic Data Queries with Repository
DESCRIPTION: Explains how to use `find*` methods on a `Repository` object to perform query operations. All query methods support the `filter` parameter for basic data filtering, similar to a SQL WHERE clause.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/repository.md#_snippet_1

LANGUAGE: JavaScript
CODE:
```
// SELECT * FROM users WHERE id = 1
userRepository.find({
  filter: {
    id: 1,
  },
});
```

----------------------------------------

TITLE: NocoBase Plugin Class Definition and Lifecycle Methods (TypeScript)
DESCRIPTION: Defines the `PluginSampleHelloServer` class, extending `Plugin` from `@nocobase/server`. It showcases various lifecycle methods (`afterAdd`, `beforeLoad`, `load`, `install`, `afterEnable`, `afterDisable`, `remove`) and demonstrates common operations performed within each stage, such as registering field types, models, collections, resources, and middleware.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { InstallOptions, Plugin } from '@nocobase/server';

export class PluginSampleHelloServer extends Plugin {
  afterAdd() {
    // After the plugin is registered with pm.add. Mainly used for placing listeners for the app beforeLoad event
    this.app.on('beforeLoad');
  }
  beforeLoad() {
    // Customize classes or methods
    this.db.registerFieldTypes();
    this.db.registerModels();
    this.db.registerRepositories();
    this.db.registerOperators();
    // Event listeners
    this.app.on();
    this.db.on();
  }
  async load() {
    // Define collection
    this.db.collection();
    // Import collection configurations
    this.db.import();
    this.db.addMigrations();

    // Define resource
    this.resourcer.define();
    // Register resource actions
    this.resourcer.registerActions();

    // Register middleware
    this.resourcer.use();
    this.acl.use();
    this.app.use();

    this.app.i18n;
    // Custom commands
    this.app.command();
  }
  async install(options?: InstallOptions) {
    // Installation logic
  }
  async afterEnable() {
    // After activation
  }
  async afterDisable() {
    // After deactivation
  }
  async remove() {
    // Deletion logic
  }
}

export default MyPlugin;
```

----------------------------------------

TITLE: Defining BelongsToMany Association in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates defining a 'belongsToMany' association, representing a many-to-many relationship using an intermediate table. If `through` is not specified, an intermediate table is automatically created. It shows how to define the relationship from both sides (posts to tags and tags to posts) using `foreignKey`, `sourceKey`, and `otherKey`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'belongsToMany',
      name: 'tags',
      target: 'tags', // 同名可省略
      through: 'postsTags', // 中间表不配置将自动生成
      foreignKey: 'postId', // 自身表在中间表的外键
      sourceKey: 'id', // 自身表的主键
      otherKey: 'tagId', // 关联表在中间表的外键
    },
  ],
});
```

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'tags',
  fields: [
    {
      type: 'belongsToMany',
      name: 'posts',
      through: 'postsTags', // 同一组关系指向同一张中间表
    },
  ],
});
```

----------------------------------------

TITLE: Registering a New Schema Initializer in NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript example shows how to register a newly defined `SchemaInitializer` within a NocoBase plugin's `load` method using `this.schemaInitializerManager.add()`. The initializer includes a custom item ('helloBlock') that, when clicked, inserts a 'Hello, world!' `h1` component into the schema. This makes the custom initializer available for use in the application UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/initializer.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class PluginDemoAddSchemaInitializer extends Plugin {
  async load() {
    const myInitializer = new SchemaInitializer({
      name: 'myInitializer',
      title: 'Add block',
      wrap: Grid.wrap,
      items: [
        {
          name: 'helloBlock',
          type: 'item',
          useComponentProps() {
            const { insert } = useSchemaInitializer();
            return {
              title: 'Hello',
              onClick: () => {
                insert({
                  type: 'void',
                  'x-decorator': 'CardItem',
                  'x-component': 'h1',
                  'x-content': 'Hello, world!',
                });
              },
            };
          },
        },
      ],
    });
    this.schemaInitializerManager.add(myInitializer);
  }
}
```

----------------------------------------

TITLE: Registering Data Block Initializer and Components in NocoBase Client Plugin (TSX)
DESCRIPTION: This snippet shows the main plugin file's `load` method, where various components and settings are registered. It adds the `Info` component, `useInfoProps` scope, `infoSettings`, and crucially, registers `infoInitializerItem` to the `page:addBlock` schema initializer under the `dataBlocks` category. This makes the custom data block available for selection when adding new blocks to a page.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-data.md#_snippet_12

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { Info } from './component';
import { useInfoProps } from './schema';
import { infoSettings } from './settings';
import { infoInitializerItem } from './initializer';

export class PluginDataBlockInitializerClient extends Plugin {
  async load() {
    this.app.addComponents({ Info });
    this.app.addScopes({ useInfoProps });

    this.app.schemaSettingsManager.add(infoSettings);

    this.app.schemaInitializerManager.addItem('page:addBlock', `dataBlocks.${infoInitializerItem.name}`, infoInitializerItem)
  }
}

export default PluginDataBlockInitializerClient;
```

----------------------------------------

TITLE: Define NocoBase Schema Initializer Item for Block Insertion
DESCRIPTION: This snippet defines a Schema Initializer Item, 'imageInitializerItem', which allows users to insert the 'Image' block schema into a page. It specifies the item's type, a unique name, an icon, and a 'useComponentProps' function that provides the display title and an 'onClick' handler to insert the 'imageSchema' using the 'useSchemaInitializer' hook.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-simple.md#_snippet_7

LANGUAGE: ts
CODE:
```
import { SchemaInitializerItemType, useSchemaInitializer } from '@nocobase/client';

import { useT } from '../locale';
import { imageSchema } from '../schema';
import { BlockName, BlockNameLowercase } from '../constants';

export const imageInitializerItem: SchemaInitializerItemType = {
  type: 'item',
  name: BlockNameLowercase,
  icon: 'FileImageOutlined',
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT()
    return {
      title: t(BlockName),
      onClick: () => {
        insert(imageSchema);
      },
    };
  },
}
```

----------------------------------------

TITLE: BelongsToMany Association Interface and Example
DESCRIPTION: Defines the TypeScript interface for a `BelongsToMany` association, specifying properties such as `type`, `name`, `target`, `through` (intermediate table), `foreignKey`, `sourceKey`, `otherKey`, and `targetKey`. The example illustrates configuring a many-to-many relationship between `posts` and `tags` using an intermediate `posts_tags` table.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/association-fields.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
interface BelongsToMany {
  type: 'belongsToMany';
  name: string;
  // default value is name
  target?: string;
  // defaults to the source collection name and target in the natural order of the first letter of the string
  through?: string;
  // defaults to the singular form of source collection name + 'Id'
  foreignKey?: string;
  // The default value is the primary key of the source model, usually id
  sourceKey?: string;
  // the default value is the singular form of target + 'Id'
  otherKey?: string;
  // the default value is the primary key of the target model, usually id
  targetKey?: string;
}

// tags table's primary key, posts table's primary key and posts_tags two foreign keys are linked
{
  name: 'posts',
  fields: [
    {
      type: 'believesToMany',
      name: 'tags',
      target: 'tags',
      through: 'posts_tags', // intermediate table
      foreignKey: 'tagId', // foreign key 1, in posts_tags table
      otherKey: 'postId', // foreignKey2, in posts_tags table
      targetKey: 'id', // tags table's primary key
      sourceKey: 'id', // posts table's primary key
    }
  ],
}
```

----------------------------------------

TITLE: Defining a Collection Configuration (TypeScript)
DESCRIPTION: This snippet defines a simple 'books' collection configuration in TypeScript, specifying its name and a single 'title' field of type string. This file is intended to be imported by the NocoBase database system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_9

LANGUAGE: ts
CODE:
```
export default {
  name: 'books',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
};
```

----------------------------------------

TITLE: Defining Data Model with Database.collection - JavaScript
DESCRIPTION: This snippet demonstrates how to define a data model using the `db.collection` method. It shows the creation of a 'users' collection with both scalar ('name') and association ('profile') fields. This method serves as a proxy entry for defining the data schema within the NocoBase database instance.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/collection.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database')

// Create database instance
const db = new Database({...});

// Define data model
db.collection({
  name: 'users',
  // Define model fields
  fields: [
    // Scalar field
    {
      name: 'name',
      type: 'string',
    },

    // Association field
    {
      name: 'profile',
      type: 'hasOne' // 'hasMany', 'belongsTo', 'belongsToMany'
    }
  ],
});
```

----------------------------------------

TITLE: Configuring Collection Fields in TypeScript
DESCRIPTION: This example demonstrates how to define fields within a NocoBase collection. The `users` collection includes `name` (string) and `age` (integer) fields. It also provides sample data illustrating the structure of records conforming to this collection definition, showing how individual data entries would appear.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/index.md#_snippet_1

LANGUAGE: ts
CODE:
```
// Collection configuration
{
  name: 'users',
  fields: [
    { type: 'string', name: 'name' },
    { type: 'integer', name: 'age' },
    // Other fields
  ],
}
// sample data
[
  {
    name: 'Jason',
    age: 20,
  },
  { {
    name: 'Li Si',
    age: 18,
  }
];
```

----------------------------------------

TITLE: Define a NocoBase Collection with Fields
DESCRIPTION: This snippet demonstrates how to define a data model using the `db.collection()` method in NocoBase. It specifies the collection's name and its fields, including scalar types like 'string' and relational types like 'hasOne'. This is essential for structuring your application's data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/collection.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database')

// Create a database instance
const db = new Database({...});

// Define a data model
db.collection({
  name: 'users',
  // Define model fields
  fields: [
    // Scalar field
    {
      name: 'name',
      type: 'string',
    },

    // Related field
    {
      name: 'profile',
      type: 'hasOne' // 'hasMany', 'belongsTo', 'belongsToMany'
    }
  ],
});
```

----------------------------------------

TITLE: Defining a Basic Collection in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a basic data collection (equivalent to a database table) in NocoBase using `db.collection()`. It specifies the collection's `name` and an array of `fields`, each with a `name` and `type`. After definition, `db.sync()` must be called to persist the collection to the database.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    { name: 'title', type: 'string' },
    { name: 'content', type: 'text' },
    // ...
  ],
});
```

----------------------------------------

TITLE: Defining HasMany Association in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet illustrates defining a 'hasMany' association, representing a one-to-many relationship where the foreign key is stored in the associated table. It links a record in the current collection to multiple records in the target collection, using `foreignKey` and `sourceKey`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'hasMany',
      name: 'posts',
      foreignKey: 'authorId',
      sourceKey: 'id',
    },
  ],
});
```

----------------------------------------

TITLE: Finding a Single Post by Primary Key (TypeScript)
DESCRIPTION: This example illustrates the use of the `findOne` method to retrieve a single data record from the database. It shows how to specify the record by its primary key using `filterByTk`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_22

LANGUAGE: TypeScript
CODE:
```
const posts = db.getRepository('posts');

const result = await posts.findOne({
  filterByTk: 1,
});
```

----------------------------------------

TITLE: Defining HasOne Association in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a one-to-one association using the 'hasOne' field type in a NocoBase collection. A 'user' is linked to a 'profile', where the foreign key resides in the 'profiles' table. The 'target' option can be omitted if it matches the plural form of the field name.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_14

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'hasOne',
      name: 'profile',
      target: 'profiles', // Can be omitted
    },
  ],
});
```

----------------------------------------

TITLE: Creating a New Post with Associated Tags (TypeScript)
DESCRIPTION: This example shows how to use the `create` method to insert a new data record into the table. It demonstrates creating a new post and simultaneously handling associated `tags`, either by updating existing ones (with `id`) or creating new ones (with `name`).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_24

LANGUAGE: TypeScript
CODE:
```
const posts = db.getRepository('posts');

const result = await posts.create({
  values: {
    title: 'NocoBase 1.0 Release Notes',
    tags: [
      // Update data when there is a primary key and value of the associated table
      { id: 1 },
      // Create data when there is no primary key and value
      { name: 'NocoBase' }
    ]
  }
});
```

----------------------------------------

TITLE: Defining String Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a 'string' type field named 'title' for a 'books' collection. This field is equivalent to `VARCHAR` in most databases and is used for short text strings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});
```

----------------------------------------

TITLE: Creating Association with Existing Object During Data Creation in NocoBase
DESCRIPTION: Shows how to create a new data record and associate it with an existing object by providing the existing object's ID, rather than creating a new associated object.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_16

LANGUAGE: javascript
CODE:
```
const tag1 = await tagRepository.findOne({
  filter: {
    name: 'tag1',
  },
});

await userRepository.create({
  name: 'Mark',
  age: 18,
  posts: [
    {
      title: 'post title',
      content: 'post content',
      tags: [
        {
          id: tag1.id, // Create an association with an existing associated object
        },
        {
          name: 'tag2',
        },
      ],
    },
  ],
});
```

----------------------------------------

TITLE: Defining One-to-One Association with hasOne (TypeScript)
DESCRIPTION: This snippet demonstrates the 'hasOne' association type, creating a one-to-one relationship where a user has one profile. The foreign key is stored in the 'profiles' table. The 'target' property can be omitted if it matches the plural form of the field name.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_14

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'hasOne',
      name: 'profile',
      target: 'profiles' // Can be omitted
    }
  ]
});
```

----------------------------------------

TITLE: Listing Collection Resources (NocoBase HTTP API)
DESCRIPTION: This snippet shows how to retrieve a list of all collection resources using NocoBase's custom HTTP API. It performs a GET request to the /api/<collection>:list endpoint, returning an array of collection objects.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_2

LANGUAGE: bash
CODE:
```
GET   /api/<collection>:list
```

----------------------------------------

TITLE: Implementing Delete Action for NocoBase Table Records (TypeScript)
DESCRIPTION: This TypeScript snippet defines `useDeleteActionProps`, a custom hook for handling the delete action in a NocoBase table. It uses `AntdApp.useApp()`, `useCollectionRecordData()`, `useDataBlockResource()`, `useCollection()`, and `useDataBlockRequest()` to confirm deletion, destroy the record via the resource API, refresh the data block, and display a success message. It also shows the `ISchema` configuration for integrating this action as an 'Action.Link' component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_18

LANGUAGE: ts
CODE:
```
import { ActionProps } from '@nocobase/client';

function useDeleteActionProps(): ActionProps {
  const { message } = AntdApp.useApp();
  const record = useCollectionRecordData();
  const resource = useDataBlockResource();
  const collection = useCollection();
  const { runAsync } = useDataBlockRequest();
  return {
    confirm: {
      title: 'Delete',
      content: 'Are you sure you want to delete it?',
    },
    async onClick() {
      await resource.destroy({
        filterByTk: record[collection.filterTargetKey]
      });
      await runAsync();
      message.success('Deleted!');
    },
  };
}

const schema: ISchema = {
  // ...
  properties: {
    // ...
    table: {
      // ...
      properties: {
        // ...
        actions: {
          // ...
          properties: {
            // ...
            delete: {
              type: 'void',
              title: 'Delete',
              'x-component': 'Action.Link',
              'x-use-component-props': 'useDeleteActionProps',
            }
          }
        }
      }
    }
  }
}
```

----------------------------------------

TITLE: Creating a NocoBase Plugin via CLI (Bash)
DESCRIPTION: This command uses the NocoBase Plugin Manager (pm) CLI to quickly create a new, empty plugin with the specified scope and name. It sets up the basic directory structure for plugin development.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/your-fisrt-plugin.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn pm create @my-project/plugin-hello
```

----------------------------------------

TITLE: Defining Password Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet illustrates how to define a 'password' type field, a NocoBase extension that uses Node.js's native `crypto.scrypt` for encryption. It allows specifying `length` and `randomBytesSize` for customization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'password',
      name: 'password',
      length: 64, // 长度，默认 64
      randomBytesSize: 8, // 随机字节长度，默认 8
    },
  ],
});
```

----------------------------------------

TITLE: Defining BelongsTo Association in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a 'belongsTo' association, representing a many-to-one relationship where the foreign key is stored in the current table. It allows configuring `target`, `foreignKey`, and `sourceKey` for precise control over the relationship.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'belongsTo',
      name: 'author',
      target: 'users', // 不配置默认为 name 复数名称的表名
      foreignKey: 'authorId', // 不配置默认为 <name> + Id 的格式
      sourceKey: 'id', // 不配置默认为 target 表的 id
    },
  ],
});
```

----------------------------------------

TITLE: Defining Text Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a 'text' type field in a NocoBase collection. It's equivalent to the `TEXT` type in most databases and is used for storing general text content.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'text',
      name: 'content',
    },
  ],
});
```

----------------------------------------

TITLE: Defining Chinese Localization for NocoBase Plugin (JSON)
DESCRIPTION: This JSON snippet defines the Chinese translations for a NocoBase plugin. It maps the key 'Document' to its Chinese equivalent '文档', enabling multi-language support for UI elements. This file is located at `packages/plugins/@nocobase-sample/plugin-initializer-action-simple/src/locale/zh-CN.json`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/action-simple.md#_snippet_11

LANGUAGE: JSON
CODE:
```
{
  "Document": "文档"
}
```

----------------------------------------

TITLE: Defining a Resource with Custom Actions and Middleware in TypeScript
DESCRIPTION: This example demonstrates how to define a new resource named 'books' using app.resourcer.define(). It includes a custom 'publish' action that sets ctx.body to 'ok' and an asynchronous middleware function that executes before the action, showcasing how to extend resource functionality with custom logic and middleware.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
app.resourcer.define({
  name: 'books',
  actions: {
    // Extended action
    publish(ctx, next) {
      ctx.body = 'ok';
    }
  },
  middleware: [
    // Extended middleware
    async (ctx, next) => {
      await next();
    }
  ]
});
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Validation Events (TypeScript)
DESCRIPTION: These events are triggered before and after data validation, which occurs based on rules defined in the collection. They are invoked when `repository.create()` or `repository.update()` is called. Use these hooks to perform actions or modify data during the validation process.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_14

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.beforeValidate` | 'beforeValidate' | `${string}.afterValidate` | 'afterValidate', listener: ValidateListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { ValidationOptions } from 'sequelize/types/lib/instance-validator';
import type { HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

type ValidateListener = (
  model: Model,
  options?: ValidationOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'tests',
  fields: [
    {
      type: 'string',
      name: 'email',
      validate: {
        isEmail: true,
      },
    },
  ],
});

// すべてのモデル
db.on('beforeValidate', async (model, options) => {
  // 何かを行う
});
// tests モデル
db.on('tests.beforeValidate', async (model, options) => {
  // 何かを行う
});

// すべてのモデル
db.on('afterValidate', async (model, options) => {
  // 何かを行う
});
// tests モデル
db.on('tests.afterValidate', async (model, options) => {
  // 何かを行う
});

const repository = db.getRepository('tests');
await repository.create({
  values: {
    email: 'abc' // メール形式をチェック
  }
});
// または
await repository.update({
  filterByTk: 1,
  values: {
    email: 'abc' // メール形式をチェック
  }
});
```

----------------------------------------

TITLE: Defining NocoBase Client-Side Plugin Entry - TypeScript
DESCRIPTION: This code snippet illustrates the required structure for the client-side entry point of a NocoBase third-party plugin. It defines a `MyPlugin` class extending `Plugin` from `@nocobase/client`, located in `src/client/index.ts`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0120-changelog.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
// src/client/index.ts
import { Plugin } from '@nocobase/client';

class MyPlugin extends Plugin {
  async load() {
    // ...
  }
}

export default MyPlugin;
```

----------------------------------------

TITLE: Defining a Nocobase Collection (TypeScript)
DESCRIPTION: Provides an example of how to define a Nocobase collection using `defineCollection` in a dedicated file. This file should be placed in the `src/server/collections` directory, replacing previous inline or directory-based imports.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0190-changelog.md#_snippet_11

LANGUAGE: typescript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'examples'
});
```

----------------------------------------

TITLE: Implementing Custom Middleware for Create Action Validation in NocoBase TypeScript
DESCRIPTION: This TypeScript snippet shows how to add custom middleware to a `create` action in NocoBase. The middleware validates if a product is enabled and has inventory before an order can be created. This allows for complex, pre-processing business logic to be enforced before the main action execution.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        create: {
          middlewares: [
            async (ctx, next) => {
              const { productId } = ctx.action.params.values;

              const product = await ctx.db.getRepository('products').findOne({
                filterByTk: productId,
                filter: {
                  enabled: true,
                  inventory: {
                    $gt: 0,
                  },
                },
              });

              if (!product) {
                return ctx.throw(404);
              }

              await next();
            },
          ],
        },
      },
    });
  }
}
```

----------------------------------------

TITLE: Defining a Client Plugin Class - NocoBase TypeScript
DESCRIPTION: This TypeScript snippet demonstrates the basic structure of a client-side plugin class in NocoBase. It extends the `Plugin` class from `@nocobase/client` and defines the three core lifecycle methods: `afterAdd`, `beforeLoad`, and `load`. These methods are crucial for managing the plugin's initialization and interaction with the NocoBase application lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';

export class PluginSampleHelloClient extends Plugin {
  async afterAdd() {}

  async beforeLoad() {}

  async load() {}
}

export default PluginSampleHelloClient;
```

----------------------------------------

TITLE: Override Default Resource Operations in NocoBase
DESCRIPTION: Explains how to override a default operation, such as 'create' for 'orders', to inject server-side logic (e.g., setting `userId` from the current logged-in user) before invoking the original default action.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/resources-actions.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';
import actions from '@nocobase/actions';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async create(ctx, next) {
          ctx.action.mergeParams({
            values: {
              userId: ctx.state.user.id
            }
          });

          return actions.create(ctx, next);
        }
      }
    });
  }
}
```

----------------------------------------

TITLE: Defining a NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a new data collection named 'posts' with a 'title' field using `app.db.collection()`. The `await app.db.sync()` call ensures that this collection definition is synchronized with the underlying database, making the 'posts' resource available for API interactions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_0

LANGUAGE: ts
CODE:
```
app.db.collection({
  name: 'posts',
  fields: [{ type: 'string', name: 'title' }],
});

await app.db.sync();
```

----------------------------------------

TITLE: Registering Plugin Setting Page in NocoBase Client (TypeScript/React)
DESCRIPTION: This TypeScript/React snippet demonstrates how to register a new plugin setting page within the NocoBase client application. It uses `this.app.pluginSettingsManager.add` to associate a component (`PluginSettingPage`) with the plugin's name, title, and icon, making it accessible in the admin settings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/router/add-setting-page-layout-routes/index.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const PluginSettingPage = () => <div>
  details
</div>;

export class PluginAddSettingPageLayoutRoutesClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Different Layout',
      icon: 'ApiOutlined',
      Component: PluginSettingPage,
    });
  }
}

export default PluginAddSettingPageLayoutRoutesClient;
```

----------------------------------------

TITLE: Registering Custom Authentication Type on Server-Side (JavaScript)
DESCRIPTION: This code illustrates how to register a new custom authentication type (`custom-auth-type`) with the NocoBase authentication manager on the server-side. The `load` method of a plugin is used to call `this.app.authManager.registerTypes()`, associating the `CustomAuth` class with the new type.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/guide.md#_snippet_3

LANGUAGE: JavaScript
CODE:
```
class CustomAuthPlugin extends Plugin {
  async load() {
    this.app.authManager.registerTypes('custom-auth-type', {
      auth: CustomAuth,
    });
  }
}
```

----------------------------------------

TITLE: Registering Custom Page and Plugin Settings in NocoBase (TSX)
DESCRIPTION: This snippet demonstrates how to register a custom page route and a plugin settings page using `this.router.add()` and `this.app.pluginSettingsManager.add()` within a NocoBase plugin. It defines a 'hello' route at the root path and a 'hello' settings page with a title and icon.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/router.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import { Application, Plugin } from '@nocobase/client';
import React from 'react';

class PluginHello extends Plugin {
  async load() {
    this.router.add('hello', {
      path: '/',
      Component: () => <div>Hello NocoBase</div>,
    });

    this.app.pluginSettingsManager.add('hello', {
      title: 'Hello',
      icon: 'ApiOutlined',
      Component: () => <div>Hello Setting page</div>,
    });
  }
}
```

----------------------------------------

TITLE: Integrating SchemaComponent with NocoBase Plugin in React TSX
DESCRIPTION: Provides a complete example of integrating `SchemaComponent` within a NocoBase application using a `Plugin`. It demonstrates how to add `SchemaComponentProvider` and custom components via `app.addProvider` and `app.addComponents` within a plugin's `load` method, and how to define a page that uses `SchemaComponent`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/rendering.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import {
  Application,
  Plugin,
  SchemaComponent,
  SchemaComponentProvider
} from '@nocobase/client';
import React from 'react';

const Hello = () => <h1>Hello, world!</h1>;

const HelloPage = () => {
  return (
    <SchemaComponent
      schema={{
        name: 'hello',
        type: 'void',
        'x-component': 'Hello'
      }}
    />
  );
};

class PluginHello extends Plugin {
  async load() {
    this.app.addProvider(SchemaComponentProvider, {
      components: this.app.components,
      scopes: this.app.scopes
    });
    this.app.addComponents({ Hello });
    this.router.add('hello', {
      path: '/',
      Component: HelloPage
    });
  }
}

const app = new Application({
  router: {
    type: 'memory'
  },
  plugins: [PluginHello]
});

export default app.getRootComponent();
```

----------------------------------------

TITLE: Implement Custom Authentication with NocoBase BaseAuth Class
DESCRIPTION: Leverage NocoBase's `BaseAuth` class to simplify custom authentication development. By extending `BaseAuth`, you can reuse existing JWT authentication logic and user collection management, significantly reducing the amount of boilerplate code required for your custom authentication type.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/auth/dev/guide.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { BaseAuth } from '@nocobase/auth';

class CustomAuth extends BaseAuth {
  constructor(config: AuthConfig) {
    // Set user data table
    const userCollection = config.ctx.db.getCollection('users');
    super({ ...config, userCollection });
  }

  // Implement user authentication logic
  async validate() {}
}
```

----------------------------------------

TITLE: Performing CRUD Operations with NocoBase Repositories - JavaScript
DESCRIPTION: This snippet demonstrates how to perform common CRUD (Create, Read, Update, Delete) operations on data using NocoBase's `Repository` API. It covers creating new records, querying existing ones, updating values, and deleting records by ID.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_2

LANGUAGE: javascript
CODE:
```
const UserRepository = UserCollection.repository();

// Create
await UserRepository.create({
  name: 'Mark',
  age: 18,
});

// Query
const user = await UserRepository.findOne({
  filter: {
    name: 'Mark',
  },
});

// Update
await UserRepository.update({
  values: {
    age: 20,
  },
});

// Delete
await UserRepository.destroy(user.id);
```

----------------------------------------

TITLE: Creating NocoBase App (Latest, PostgreSQL, Bash)
DESCRIPTION: This command initializes a new NocoBase project named 'my-nocobase-app' using the latest stable version, configured for a PostgreSQL database. It sets essential environment variables for database connection (host, port, database name, user, password) and timezone, along with optional NocoBase package credentials.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/getting-started/installation/create-nocobase-app.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d postgres \
   -e DB_HOST=localhost \
   -e DB_PORT=5432 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=Asia/Shanghai \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: Defining New Collections in NocoBase Plugin - TypeScript
DESCRIPTION: This snippet demonstrates how to define a new collection within a NocoBase plugin. Collections defined this way are automatically synchronized with the database upon plugin activation, creating corresponding data tables and fields. It uses the `defineCollection` function from `@nocobase/database`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/configure.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'examples',
});
```

----------------------------------------

TITLE: Defining Categories Collection with hasMany Field - TypeScript
DESCRIPTION: This snippet defines the 'categories' collection in NocoBase. It includes a 'title' field of type 'string' and a 'products' field of type 'hasMany', which establishes a one-to-many relationship with products associated under each category. This collection is automatically imported by `db.import()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'categories',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
    {
      type: 'hasMany',
      name: 'products',
    },
  ],
};
```

----------------------------------------

TITLE: Creating Single Data Record with Repository in NocoBase
DESCRIPTION: Shows how to create a single new data record using the `create` method on a `Repository` object, specifying the fields and their values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_13

LANGUAGE: javascript
CODE:
```
await userRepository.create({
  name: 'Mark',
  age: 18,
});
// INSERT INTO users (name, age) VALUES ('Mark', 18)
```

----------------------------------------

TITLE: Performing CRUD Operations with NocoBase Repository
DESCRIPTION: This snippet demonstrates how to perform common CRUD (Create, Read, Update, Delete) operations on data using a NocoBase `Repository`. A repository is obtained from a `Collection` (e.g., `UserCollection.repository()`). It shows examples of `create` to insert new records, `findOne` to query data with filters, `update` to modify existing records, and `destroy` to delete records by ID.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_2

LANGUAGE: javascript
CODE:
```
const UserRepository = UserCollection.repository();

// Create
await UserRepository.create({
  name: 'Mark',
  age: 18,
});

// Query
const user = await UserRepository.findOne({
  filter: {
    name: 'Mark',
  },
});

// Update
await UserRepository.update({
  values: {
    age: 20,
  },
});

// Delete
await UserRepository.destroy(user.id);
```

----------------------------------------

TITLE: Connecting to NocoBase Database
DESCRIPTION: This snippet demonstrates how to initialize a NocoBase `Database` instance. It shows configurations for both SQLite, requiring a `storage` path, and MySQL/PostgreSQL, which need `dialect`, `database`, `username`, `password`, `host`, and `port` parameters. The `Database` constructor takes an `options` object to define connection details.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database');

// SQLite database configuration parameters
const database = new Database({
  dialect: 'sqlite',
  storage: 'path/to/database.sqlite'
})
```

LANGUAGE: javascript
CODE:
```
// MySQL \\ PostgreSQL database configuration parameters
const database = new Database({
  dialect: /* 'postgres' or 'mysql' */,
  database: 'database',
  username: 'username',
  password: 'password',
  host: 'localhost',
  port: 'port'
})
```

----------------------------------------

TITLE: Define NocoBase Data Collection Configuration
DESCRIPTION: Creates the configuration content for a data sheet. This method is used for data sheet configuration files imported by `db.import()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_10

LANGUAGE: APIDOC
CODE:
```
Signature:
defineCollection(name: string, config: CollectionOptions): CollectionOptions

Parameters:
- name: collectionOptions, type: CollectionOptions, default: -, description: Same as all db.collection() parameters
```

LANGUAGE: TypeScript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'users',
  fields: [
    {
      type: 'string',
      name: 'name'
    }
  ]
});
```

----------------------------------------

TITLE: Adding a Global Custom Action to All NocoBase Resources (TypeScript)
DESCRIPTION: This code defines a global `export` action that can be applied to any NocoBase collection. The action retrieves data based on a provided filter, formats it into CSV, and sets the response type to 'text/csv', enabling data export functionality across all resources.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
app.actions({
  // Add export method to all resources for exporting data
  async export(ctx, next) {
    const repo = ctx.db.getRepository(ctx.action.resource);
    const results = await repo.find({
      filter: ctx.action.params.filter
    });
    ctx.type = 'text/csv';
    // Splice to CSV format
    ctx.body = results
      .map(row => Object.keys(row)
        .reduce((arr, col) => [... . arr, row[col]], []).join(',')
      ).join('\n');

    next();
  }
});
```

----------------------------------------

TITLE: Loading Collections and Setting ACL in a NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how a NocoBase plugin's `load()` method imports collection definitions from a specified directory (e.g., `collections`). It uses `this.db.import()` to register multiple collections at once. Additionally, it temporarily sets broad ACL permissions for 'products', 'categories', and 'orders' collections, allowing all operations for testing purposes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import path from 'path';
import { Plugin } from '@nocobase/server;

export default class ShopPlugin extends Plugin {
  async load() {
    await this.db.import({
      directory: path.resolve(__dirname, 'collections'),
    });

    this.app.acl.allow('products', '*');
    this.app.acl.allow('categories', '*');
    this.app.acl.allow('orders', '*');
  }
}
```

----------------------------------------

TITLE: Defining a NocoBase Collection with Fields (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a new data collection named 'posts' in NocoBase using the `db.collection()` method. It specifies the collection's name and an array of fields, each with a `name` and `type`, such as 'title' (string) and 'content' (text). This definition exists in memory until `db.sync()` is called to persist it to the database.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    { name: 'title', type: 'string' }
    { name: 'content', type: 'text' },
    // ...
  ]
});
```

----------------------------------------

TITLE: Defining Data Model with Database Collection Method - JavaScript
DESCRIPTION: This snippet demonstrates how to define a data model using the `collection` method of a `Database` instance. It shows the creation of a 'users' collection with both scalar ('name') and association ('profile') fields, illustrating how to structure the data schema within NocoBase.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/collection.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database')

// Create database instance
const db = new Database({...});

// Define data model
db.collection({
  name: 'users',
  // Define model fields
  fields: [
    // Scalar field
    {
      name: 'name',
      type: 'string',
    },

    // Association field
    {
      name: 'profile',
      type: 'hasOne' // 'hasMany', 'belongsTo', 'belongsToMany'
    }
  ],
});
```

----------------------------------------

TITLE: Implementing Custom Deliver Action for Orders (TypeScript)
DESCRIPTION: This snippet implements a custom `deliver` action for the 'orders' resource. It updates the order's status to 'shipped' (2) and creates/updates associated delivery information based on provided parameters, demonstrating how to handle complex status changes and related data updates.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_12

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async deliver(ctx, next) {
          const { filterByTk } = ctx.action.params;
          const orderRepo = ctx.db.getRepository('orders');

          const [order] = await orderRepo.update({
            filterByTk,
            values: {
              status: 2,
              delivery: {
                ... . ctx.action.params.values,
                status: 0
              }
            }
          });

          ctx.body = order;

          next();
        }
      }
    });
  }
}
```

----------------------------------------

TITLE: Registering Plugin Configuration Page in NocoBase Client (TypeScript)
DESCRIPTION: This snippet modifies the NocoBase client-side plugin entry point to register a new plugin settings form. It imports `PluginSettingsForm` and assigns it as the `Component` for the plugin's settings, replacing a placeholder. This makes the custom settings page accessible through the NocoBase admin panel.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/form.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
// @ts-ignore
import { name } from '../../package.json';
import { PluginSettingsForm } from './PluginSettingsForm'

export class PluginSettingFormClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Plugin Settings Form',
      icon: 'FormOutlined',
      Component: PluginSettingsForm,
    });
  }
}

export default PluginSettingFormClient;
```

----------------------------------------

TITLE: Testing with MockDatabase in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to use `MockDatabase` for unit testing in NocoBase. `MockDatabase` isolates test cases by using random table prefixes, ensuring data integrity between tests. It shows how to define a collection, synchronize the database, and perform basic CRUD operations on a repository.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/others/testing.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { MockDatabase } from '@nocobase/test';

describe('my suite', () => {
  let db;

  beforeEach(async () => {
    db = new MockDatabase();

    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });

    await db.sync();
  });

  test('my case', async () => {
    const postRepository = db.getRepository('posts');
    const p1 = await postRepository.create({
      values: {
        title: 'hello',
      },
    });

    expect(p1.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Defining a NocoBase Collection with User Fields (TypeScript)
DESCRIPTION: This example illustrates defining a 'users' collection in NocoBase, showcasing how to specify individual fields like 'name' (string) and 'age' (integer). It emphasizes that `name` and `type` are required for each field, and different fields within a collection are uniquely identified by their `name`. This structure maps directly to database table columns.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    { type: 'string', name: 'name' }
    { type: 'integer', name: 'age' }
    // Other fields
  ],
});
```

----------------------------------------

TITLE: Defining a General Collection in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a basic NocoBase collection named 'posts' with a single string field 'title'. It illustrates the fundamental structure for creating a new collection without special inheritance or tree properties.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/collection-template.md#_snippet_0

LANGUAGE: ts
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});
```

----------------------------------------

TITLE: Defining a NocoBase Collection (TypeScript)
DESCRIPTION: This TypeScript snippet defines a new data collection named 'hello' using `@nocobase/database`. It includes a single string field named 'name', establishing the schema for a new database table.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/your-fisrt-plugin.md#_snippet_2

LANGUAGE: typescript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'hello',
  fields: [{ type: 'string', name: 'name' }],
});
```

----------------------------------------

TITLE: Extend NocoBase Resources with Custom Actions
DESCRIPTION: NocoBase allows extending resource operations beyond default CRUD. This snippet demonstrates how to override a specific resource's action (e.g., 'posts:create' to enforce user ID) and how to add a global action (e.g., 'export' to generate CSV data for any table) to meet custom business requirements.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/resources-actions.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
// Equivalent to app.resourcer.registerActions()
// Register the create operation method for the article resource
app.actions({
  async ['posts:create'](ctx, next) {
    const postRepo = ctx.db.getRepository('posts');
    await postRepo.create({
      values: {
        ...ctx.action.params.values,
        // Limit the current user as the author of the article
        userId: ctx.state.currentUserId
      }
    });

    await next();
  }
});
```

LANGUAGE: TypeScript
CODE:
```
app.actions({
  // Add an export method to all resources to export data
  async export(ctx, next) {
    const repo = ctx.db.getRepository(ctx.action.resource);
    const results = await repo.find({
      filter: ctx.action.params.filter
    });
    ctx.type = 'text/csv';
    // Combine into CSV format
    ctx.body = results
      .map((row) =>
        Object.keys(row)
          .reduce((arr, col) => [...arr, row[col]], [])
          .join(',')
      )
      .join('\n');

    await next();
  }
});
```

LANGUAGE: Bash
CODE:
```
curl http://localhost:13000/api/<any_table>:export
```

----------------------------------------

TITLE: Initializing NocoBase Application (Bash)
DESCRIPTION: This snippet demonstrates how to create a new NocoBase application, navigate into its directory, install dependencies, and perform the initial NocoBase installation. This is a prerequisite step for setting up a development environment or a new project.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/plugin-settings/form.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

----------------------------------------

TITLE: Initializing NocoBase Application (Bash)
DESCRIPTION: This snippet demonstrates the initial setup steps for a NocoBase application, including creating a new project, navigating into its directory, installing dependencies, and performing the core NocoBase installation using yarn.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/plugin-settings/table.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

----------------------------------------

TITLE: Initializing NocoBase Application Instance (TypeScript)
DESCRIPTION: This snippet demonstrates how to create a new instance of the `Application` class. It accepts an `ApplicationOptions` object, configuring the `apiClient` with a base URL and a `dynamicImport` function for loading plugins dynamically. This is the entry point for setting up the NocoBase client application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/client/application.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const app = new Application({
  apiClient: {
    baseURL: process.env.API_BASE_URL,
  },
  dynamicImport: (name: string) => {
    return import(`../plugins/${name}`);
  }
});
```

----------------------------------------

TITLE: Defining New Collections in NocoBase Plugin - TypeScript
DESCRIPTION: This snippet demonstrates how to define a new collection within a NocoBase plugin. Collections are defined in `src/server/collections/*.ts` files. This method automatically synchronizes the collection with the database upon plugin activation, creating corresponding data tables and fields.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/configure.md#_snippet_0

LANGUAGE: ts
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'examples',
});
```

----------------------------------------

TITLE: Creating NocoBase App (Latest, MySQL, Bash)
DESCRIPTION: This command initializes a new NocoBase project named 'my-nocobase-app' using the latest stable version, configured for a MySQL database. It sets essential environment variables for database connection (host, port, database name, user, password) and timezone, along with optional NocoBase package credentials.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/getting-started/installation/create-nocobase-app.md#_snippet_3

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d mysql \
   -e DB_HOST=localhost \
   -e DB_PORT=3306 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=Asia/Shanghai \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: Overriding Default Create Action for NocoBase Orders (TypeScript)
DESCRIPTION: This snippet demonstrates how to override the default 'create' action for the 'orders' resource. It ensures that the 'userId' for a new order is automatically set from the current logged-in user's ID, preventing client-side manipulation. The original 'create' logic is then called after modifying the parameters using 'ctx.action.mergeParams()'.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/server';
import actions from '@nocobase/actions;

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async create(ctx, next) {
          ctx.action.mergeParams({
            values: {
              userId: ctx.state.user.id,
            },
          });

          return actions.create(ctx, next);
        },
      },
    });
  }
}
```

----------------------------------------

TITLE: Register Custom Workflow Trigger in Nocobase
DESCRIPTION: Registers a new custom trigger type for the Nocobase Workflow Plugin. This method allows extending the workflow system with custom event listeners that can initiate workflows based on specific conditions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/workflow/development/api.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Method: registerTrigger
Signature: registerTrigger(type: string, trigger: typeof Trigger | Trigger)
Parameters:
  - type (string): Identifier for the trigger type.
  - trigger (typeof Trigger | Trigger): Trigger type or instance.
```

LANGUAGE: TypeScript
CODE:
```
import PluginWorkflowServer, { Trigger } from '@nocobase/plugin-workflow';

function handler(this: MyTrigger, workflow: WorkflowModel, message: string) {
  // Triggers the workflow
  this.workflow.trigger(workflow, { data: message.data });
}

class MyTrigger extends Trigger {
  messageHandlers: Map<number, WorkflowModel> = new Map();
  on(workflow: WorkflowModel) {
    const messageHandler = handler.bind(this, workflow);
    // Listens for an event to trigger the workflow
    process.on(
      'message',
      this.messageHandlers.set(workflow.id, messageHandler),
    );
  }

  off(workflow: WorkflowModel) {
    const messageHandler = this.messageHandlers.get(workflow.id);
    // Removes the listener
    process.off('message', messageHandler);
  }
}

export default class MyPlugin extends Plugin {
  load() {
    // Retrieves the Workflow plugin instance
    const workflowPlugin =
      this.app.pm.get<PluginWorkflowServer>(PluginWorkflowServer);

    // Registers the trigger
    workflowPlugin.registerTrigger('myTrigger', MyTrigger);
  }
}
```

----------------------------------------

TITLE: Programmatically Trigger Nocobase Workflow
DESCRIPTION: Triggers a specific workflow programmatically. This method is primarily used within custom triggers to activate a workflow when a custom event is detected, passing relevant context data for its execution.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/workflow/development/api.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Method: trigger
Signature: trigger(workflow: Workflow, context: any)
Parameters:
  - workflow (WorkflowModel): The workflow object to trigger.
  - context (object): Contextual data provided when triggering.
Note: The `context` parameter is currently mandatory; the workflow will not be triggered without it.
```

LANGUAGE: TypeScript
CODE:
```
import { Trigger } from '@nocobase/plugin-workflow';

class MyTrigger extends Trigger {
  timer: NodeJS.Timeout;

  on(workflow) {
    // Registers the event
    this.timer = setInterval(() => {
      // Triggers the workflow
      this.plugin.trigger(workflow, { date: new Date() });
    }, workflow.config.interval ?? 60000);
  }
}
```

----------------------------------------

TITLE: Implementing Custom Middleware for NocoBase Create Action
DESCRIPTION: This example shows how to add custom middleware to a NocoBase `create` action to enforce complex business logic. The middleware checks if a product is enabled and in stock before allowing an order to be created, throwing an error if conditions are not met.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_18

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        create: {
          middlewares: [
            async (ctx, next) => {
              const { productId } = ctx.action.params.values;

              const product = await ctx.db.getRepository('products').findOne({
                filterByTk: productId,
                filter: {
                  enabled: true,
                  inventory: {
                    $gt: 0,
                  },
                },
              });

              if (!product) {
                return ctx.throw(404);
              }

              await next();
            },
          ],
        },
      },
    });
  }
}
```

----------------------------------------

TITLE: Registering Page Component and Route in NocoBase Plugin (TSX)
DESCRIPTION: This TSX snippet shows how to register the `PluginSettingsTablePage` component as a route within a NocoBase plugin's `load` method. It uses `this.app.router.add()` to associate a path (`/admin/plugin-settings-table-page`) with the `PluginSettingsTablePage` component, making it accessible via the application's routing system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_21

LANGUAGE: tsx
CODE:
```
import { PluginSettingsTablePage } from './PluginSettingsTablePage'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...

    this.app.router.add(`admin.${name}-page`, {
      path: '/admin/plugin-settings-table-page',
      Component: PluginSettingsTablePage,
    })
  }
}
```

----------------------------------------

TITLE: Authenticating DB Connection - TypeScript
DESCRIPTION: Performs a database connection check and version verification.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/server/application.md#_snippet_18

LANGUAGE: TypeScript
CODE:
```
authenticate(): Promise<void>
```

----------------------------------------

TITLE: Extending Existing Collections in NocoBase Plugin - TypeScript
DESCRIPTION: This snippet illustrates how to extend the options of an existing collection within a NocoBase plugin. It utilizes the `extendCollection` function from `@nocobase/database` to modify or add properties to an already defined collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/configure.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import { extendCollection } from '@nocobase/database';

export default extendCollection({
  name: 'examples',
});
```

----------------------------------------

TITLE: Defining Abstract Storage Class and Custom Implementation (TypeScript)
DESCRIPTION: This snippet defines the abstract `Storage` class, outlining the interface for client-side data storage operations such as `clear`, `getItem`, `removeItem`, and `setItem`. It also shows a `CustomStorage` class extending `Storage`, demonstrating how custom storage mechanisms can be implemented. This structure provides a flexible blueprint for persistent data management.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/sdk/storage.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export abstract class Storage {
  abstract clear(): void;
  abstract getItem(key: string): string | null;
  abstract removeItem(key: string): void;
  abstract setItem(key: string, value: string): void;
}

export class CustomStorage extends Storage {
  // ...
}
```

----------------------------------------

TITLE: Defining ResourceManager Action Types and Handlers (TypeScript)
DESCRIPTION: Defines the standard action types (DefaultActionType), custom action names (ActionName), and the signature for action handler middleware (HandlerType) used within the ResourceManager. These types ensure consistency and proper typing for resource actions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource-manager.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
export type DefaultActionType =
  | 'list'
  | 'create'
  | 'get'
  | 'update'
  | 'destroy'
  | 'set'
  | 'add'
  | 'remove';
export type ActionName = DefaultActionType | Omit<string, DefaultActionType>;

export type HandlerType = (
  ctx: ResourcerContext,
  next: () => Promise<any>,
) => any;
```

----------------------------------------

TITLE: Defining Many-to-Many Association with belongsToMany (TypeScript)
DESCRIPTION: These snippets demonstrate the 'belongsToMany' association type, creating a many-to-many relationship between 'posts' and 'tags' using an intermediate table ('postsTags'). It shows how to configure both sides of the relationship, specifying the intermediate table, foreign keys, and source keys for proper linking.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_16

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'belongsToMany',
      name: 'tags',
      target: 'tags', // Can be omitted if name is the same
      through: 'postsTags', // Intermediate table will be generated automatically if not specified
      foreignKey: 'postId', // Foreign key in the intermediate table referring to the table itself
      sourceKey: 'id', // Primary key of the table itself
      otherKey: 'tagId' // Foreign key in the intermediate table referring to the association table
    }
  ]
});
```

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'tags',
  fields: [
    {
      type: 'belongsToMany',
      name: 'posts',
      through: 'postsTags' // Refer to the same intermediate table in the same set of relation
    }
  ]
});
```

----------------------------------------

TITLE: Defining Custom Encryption Field (Server-side) - NocoBase TypeScript
DESCRIPTION: This snippet defines the EncryptionField class, extending NocoBase's Field class. It sets the database dataType to DataTypes.STRING and overrides the get and set methods. The get method decrypts the stored value before returning it, while the set method encrypts the value before saving it to the database, ensuring data is always encrypted at rest.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/interface.md#_snippet_7

LANGUAGE: ts
CODE:
```
import { BaseColumnFieldOptions, Field, FieldContext } from '@nocobase/database';
import { DataTypes } from 'sequelize';
import { decryptSync, encryptSync } from './utils';

export interface EncryptionFieldOptions extends BaseColumnFieldOptions {
  type: 'encryption';
}

export class EncryptionField extends Field {
  get dataType() {
    return DataTypes.STRING;
  }

  constructor(options?: any, context?: FieldContext) {
    const { name, iv } = options;
    super(
      {
        get() {
          const value = this.getDataValue(name);
          if (!value) return null;
          return decryptSync(value, iv);
        },
        set(value) {
          if (!value?.length) value = null;
          else {
            value = encryptSync(value, iv);
          }
          this.setDataValue(name, value);
        },
        ...options,
      },
      context,
    );
  }
}
```

----------------------------------------

TITLE: Initializing NocoBase Middleware with a Handler Function (TypeScript)
DESCRIPTION: This snippet demonstrates the simplest way to define a NocoBase Middleware instance by passing an asynchronous handler function directly to its constructor. The handler function receives `ctx` (context) and `next` (next middleware function) as parameters, allowing for execution flow control.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/middleware.md#_snippet_0

LANGUAGE: ts
CODE:
```
const middleware = new Middleware((ctx, next) => {
  await next();
});
```

----------------------------------------

TITLE: Defining NocoBase Orders Data Table (TypeScript)
DESCRIPTION: This snippet defines a new `orders` data table within a NocoBase plugin, specifying fields like `id` (UUID primary key), `product` (belongsTo), `quantity`, `totalPrice`, `status`, `address`, and `user` (belongsTo). It establishes the schema for managing order entities, including relationships to products and users.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'orders',
  fields: [
    {
      type: 'uuid',
      name: 'id',
      primaryKey: true,
    },
    {
      type: 'belongsTo',
      name: 'product',
    },
    {
      type: 'integer',
      name: 'quantity',
    },
    {
      type: 'integer',
      name: 'totalPrice',
    },
    {
      type: 'integer',
      name: 'status',
    },
    {
      type: 'string',
      name: 'address',
    },
    {
      type: 'belongsTo',
      name: 'user',
    },
  ],
};
```

----------------------------------------

TITLE: Adding Multiple Migrations from Directory (TypeScript)
DESCRIPTION: This example shows how to add multiple migration files located within a specified directory using the `addMigrations` method. It allows configuring the directory path, accepted file extensions (defaulting to 'js' and 'ts'), and an optional namespace for the migrations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
db.addMigrations({
  directory: path.resolve(__dirname, './migrations'),
  namespace: 'test',
});
```

----------------------------------------

TITLE: Creating a NocoBase Page with mockPage (TypeScript)
DESCRIPTION: Generates a NocoBase page instance based on the provided configuration. Pages created with `mockPage` are automatically destroyed after the current test case completes, making them suitable for isolated tests. The `pageConfig` parameter allows customization of page type, name, URL, base path, collections, and schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/test/e2e.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { test } from '@nocobase/test/e2e';

test('learn how to use mockPage', async ({ mockPage }) => {
  const nocoPage = await mockPage();
  await nocoPage.goto();
});
```

----------------------------------------

TITLE: Writing Backend Tests with NocoBase and Vitest
DESCRIPTION: This snippet demonstrates how to write backend tests using `@nocobase/test/server`. It shows setting up a mock database, defining a collection, performing CRUD operations, and asserting results within a Vitest test suite.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/welcome/release/v0180-changelog.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { mockDatabase } from '@nocobase/test/server';

describe('my db suite', () => {
  let db;

  beforeEach(async () => {
    db = mockDatabase();
    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });
    await db.sync();
  });

  afterEach(async () => {
    await db.close();
  });

  test('my case', async () => {
    const repository = db.getRepository('posts');
    const post = await repository.create({
      values: {
        title: 'hello',
      },
    });

    expect(post.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Adding Association Relationships - HasManyRepository - TypeScript
DESCRIPTION: Adds association relationships between objects. The `tk` parameter specifies the target key value(s) of the associated object, which can be a single value or an array.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/has-many-repository.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
async add(options: TargetKey | TargetKey[] | AssociatedOptions)
```

LANGUAGE: TypeScript
CODE:
```
interface AssociatedOptions extends Transactionable {
  tk?: TargetKey | TargetKey[];
}
```

----------------------------------------

TITLE: Configuring NocoBase with MariaDB using Docker Compose
DESCRIPTION: This Docker Compose configuration sets up a NocoBase application service connected to a MariaDB database. It defines environment variables for the application's secret key, MariaDB database connection details (host, port, name, user, password), and timezone. It also includes a MariaDB service with database and user credentials.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/getting-started/installation/docker-compose.md#_snippet_3

LANGUAGE: YAML
CODE:
```
version: '3'

networks:
  nocobase:
    driver: bridge

services:
  app:
    image: nocobase/nocobase:latest
    restart: always
    networks:
      - nocobase
    depends_on:
      - mariadb
    environment:
      # The application's secret key, used to generate user tokens, etc.
      # If APP_KEY is changed, old tokens will also become invalid.
      # It can be any random string, and make sure it is not exposed.
      - APP_KEY=your-secret-key
      # Database type, supports postgres, mysql, mariadb
      - DB_DIALECT=mariadb
      # Database host, can be replaced with the IP of an existing database server
      - DB_HOST=mariadb
      # Database port
      - DB_PORT=3306
      # Database name
      - DB_DATABASE=nocobase
      # Database user
      - DB_USER=root
      # Database password
      - DB_PASSWORD=nocobase
      # Whether to convert table and field names to snake case
      - DB_UNDERSCORED=true
      # Timezone
      - TZ=Asia/Shanghai
      # Service platform username and password,
      # used for automatically downloading and updating plugins.
      - NOCOBASE_PKG_USERNAME=
      - NOCOBASE_PKG_PASSWORD=
    volumes:
      - ./storage:/app/nocobase/storage
    ports:
      - '13000:80'
    # init: true

  # If using an existing database server, mariadb service can be omitted
  mariadb:
    image: mariadb:11
    environment:
      MYSQL_DATABASE: nocobase
      MYSQL_USER: nocobase
      MYSQL_PASSWORD: nocobase
      MYSQL_ROOT_PASSWORD: nocobase
```

----------------------------------------

TITLE: Defining BelongsTo Association in NocoBase
DESCRIPTION: This configuration defines a 'belongsTo' association in NocoBase's Collection, establishing a many-to-one relationship where 'posts' belong to a 'user'. It specifies the target collection 'users' and the foreign key 'userId' in the 'posts' collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/association-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
{
  name: 'posts',
  fields: [
    {
      type: 'belongsTo',
      name: 'user',
      target: 'users',
      foreignKey: 'userId',
    },
  ],
}
```

----------------------------------------

TITLE: Get Repository Object and Perform Basic CRUD
DESCRIPTION: Demonstrates how to obtain a `Repository` object from a `Collection` and perform basic data retrieval and update operations. It shows finding a user by ID, modifying its name, and saving the changes to the database.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/repository.md#_snippet_0

LANGUAGE: JavaScript
CODE:
```
const { UserCollection } = require('./collections');

const UserRepository = UserCollection.repository;

const user = await UserRepository.findOne({
  filter: {
    id: 1,
  },
});

user.name = 'new name';
await user.save();
```

----------------------------------------

TITLE: Defining NocoBase Migration Class (TypeScript)
DESCRIPTION: This TypeScript code defines a basic migration class that extends `Migration` from `@nocobase/server`. It specifies the `on` property to determine when the migration runs (e.g., `afterLoad`) and `appVersion` for version compatibility. The `up()` method is where the migration logic is implemented.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/migration.md#_snippet_2

LANGUAGE: typescript
CODE:
```
import { Migration } from '@nocobase/server';

export default class extends Migration {
  on = 'afterLoad'; // 'beforeLoad' | 'afterSync' | 'afterLoad'
  appVersion = '<0.19.0-alpha.3';

  async up() {
    // coding
  }
}
```

----------------------------------------

TITLE: Creating and Enabling a NocoBase Plugin
DESCRIPTION: These commands create a new NocoBase plugin with the specified name and then enable it within the NocoBase system. This step integrates the custom plugin into the application, making it available for use.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/field/interface.md#_snippet_1

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase-sample/plugin-field-interface
yarn pm enable @nocobase-sample/plugin-field-interface
```

----------------------------------------

TITLE: Creating a NocoBase Plugin via CLI
DESCRIPTION: This command uses the NocoBase Plugin Manager (pm) CLI to quickly scaffold a new, empty plugin with a specified scope and name. It sets up the basic directory structure for client and server code.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/your-fisrt-plugin.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn pm create @my-project/plugin-hello
```

----------------------------------------

TITLE: Extending NocoBase Chart Class for ECharts (TypeScript)
DESCRIPTION: This TypeScript snippet defines the `ECharts` class, extending NocoBase's base `Chart` class. It initializes common ECharts properties like `name`, `title`, and `series`, and sets `ReactECharts` as the rendering component. Default configuration fields (`xField`, `yField`, `seriesField`) are pre-set to streamline chart creation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/data-visualization/step-by-step/index.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { Chart } from '@nocobase/plugin-data-visualization/client';

export class ECharts extends Chart {
  constructor({
    name,
    title,
    series,
    config,
  }: {
    name: string;
    title: string;
    series: any;
    config?: ChartProps['config'];
  }) {
    super({
      name,
      title,
      component: ReactECharts,
      config: ['xField', 'yField', 'seriesField', ...(config || [])],
    });
    this.series = series;
  }
}
```

----------------------------------------

TITLE: Initializing Application Instance (TypeScript)
DESCRIPTION: This snippet demonstrates how to create a new `Application` instance. It configures the `apiClient` with a base URL and defines a `dynamicImport` function for loading plugins dynamically, essential for modular application design.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/client/application.md#_snippet_0

LANGUAGE: typescript
CODE:
```
const app = new Application({
  apiClient: {
    baseURL: process.env.API_BASE_URL,
  },
  dynamicImport: (name: string) => {
    return import(`../plugins/${name}`);
  }
});
```

----------------------------------------

TITLE: Extending Pages and Plugin Settings with NocoBase Client (TSX)
DESCRIPTION: This snippet demonstrates how to extend NocoBase client pages and add plugin settings using a custom `Plugin` class. It registers a new route 'hello' at the root path '/' with a simple React component and adds a 'hello' entry to the plugin settings manager with a title, icon, and component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/router.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import { Application, Plugin } from '@nocobase/client';
import React from 'react';

class PluginHello extends Plugin {
  async load() {
    this.router.add('hello', {
      path: '/',
      Component: () => <div>Hello NocoBase</div>,
    });

    this.app.pluginSettingsManager.add('hello', {
      title: 'Hello',
      icon: 'ApiOutlined',
      Component: () => <div>Hello Setting page</div>,
    });
  }
}
```

----------------------------------------

TITLE: Replacing a NocoBase Route with a Custom Component
DESCRIPTION: This snippet shows how a custom plugin can override an existing route by adding a new route with the same name or a similar path, pointing to a `CustomLoginPage` component. This method allows for replacing entire page flows or specific entry points within the application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/index.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class CustomPlugin extends Plugin {
  async load() {
    this.app.router.add('auth.login', {
      path: '/login',
      Component: CustomLoginPage,
    })
  }
}
```

----------------------------------------

TITLE: Extending BaseAuth for Basic User Authentication - TypeScript
DESCRIPTION: This snippet demonstrates how to extend `BaseAuth` to create a custom authentication class, `BasicAuth`. It initializes the user collection in the constructor and outlines the `validate` method, which contains the core user authentication logic called during sign-in to determine if the user can successfully log in.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/auth/base-auth.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
class BasicAuth extends BaseAuth {
  constructor(config: AuthConfig) {
    // Set user collection
    const userCollection = config.ctx.db.getCollection('users');
    super({ ...config, userCollection });
  }

  // User authentication logic, called by `auth.signIn`
  // Returns user data
  async validate() {
    const ctx = this.ctx;
    const { values } = ctx.action.params;
    // ...
    return user;
  }
}
```

----------------------------------------

TITLE: BelongsToMany Association Interface and Example
DESCRIPTION: This snippet defines the TypeScript interface for a 'belongsToMany' association, including parameters like `name`, `target`, `through` (intermediate table), `foreignKey`, `otherKey`, `sourceKey`, and `targetKey`. The example illustrates a many-to-many relationship between 'posts' and 'tags' using an intermediate table 'posts_tags', specifying all relevant keys for linking.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/association-fields.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
interface BelongsToMany {
  type: 'belongsToMany';
  name: string;
  // default value is name
  target?: string;
  // defaults to the source collection name and target in the natural order of the first letter of the string
  through?: string;
  // defaults to the singular form of source collection name + 'Id'
  foreignKey?: string;
  // The default value is the primary key of the source model, usually id
  sourceKey?: string;
  // the default value is the singular form of target + 'Id'
  otherKey?: string;
  // the default value is the primary key of the target model, usually id
  targetKey?: string;
}

// tags table's primary key, posts table's primary key and posts_tags two foreign keys are linked
{
  name: 'posts',
  fields: [
    {
      type: 'believesToMany',
      name: 'tags',
      target: 'tags',
      through: 'posts_tags', // intermediate table
      foreignKey: 'tagId', // foreign key 1, in posts_tags table
      otherKey: 'postId', // foreignKey2, in posts_tags table
      targetKey: 'id', // tags table's primary key
      sourceKey: 'id', // posts table's primary key
    }
  ],
}
```

----------------------------------------

TITLE: Registering a Custom Page Component in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet extends the NocoBase `Plugin` class to register a custom React component (`SamplesCustomPage`) directly as a route within the NocoBase client-side router. It sets up a new admin route at `/admin/custom-page2`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initailizer/add-item-to-block.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { SamplesCustomPage } from './CustomPage'

export class PluginComponentAndScopeLocalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page2', {
      path: '/admin/custom-page2',
      Component: SamplesCustomPage,
    })
  }
}

export default PluginComponentAndScopeLocalClient;
```

----------------------------------------

TITLE: Defining and Using Custom UI Components with SchemaComponent in TypeScript
DESCRIPTION: This snippet defines `SamplesHello` and `useSamplesHelloProps` for rendering custom UI. It then constructs an `ISchema` object demonstrating how to register these components and their props with `SchemaComponent`, using both direct object references and string-based lookups. This allows for flexible UI rendering based on schema definitions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/local.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import { ISchema, SchemaComponent, withDynamicSchemaProps } from "@nocobase/client"
import { uid } from '@formily/shared'
import { useFieldSchema } from '@formily/react'
import React, { FC } from "react"

const SamplesHello: FC<{ name: string }> = withDynamicSchemaProps(({ name }) => {
  return <div>hello {name}</div>
})

const useSamplesHelloProps = () => {
  const schema = useFieldSchema();
  return { name: schema.name }
}

const schema: ISchema = {
  type: 'void',
  name: uid(),
  properties: {
    demo1: {
      type: 'void',
      'x-component': SamplesHello,
      'x-component-props': {
        name: 'demo1',
      },
    },
    demo2: {
      type: 'void',
      'x-component': SamplesHello,
      'x-use-component-props': useSamplesHelloProps,
    },
    demo3: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-component-props': {
        name: 'demo3',
      },
    },
    demo4: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-use-component-props': 'useSamplesHelloProps',
    },
  }
}

export const SamplesCustomPage = () => {
  return <SchemaComponent schema={schema} components={{ SamplesHello }} scope={{ useSamplesHelloProps }}></SchemaComponent>
}
```

----------------------------------------

TITLE: Defining Collection Options in NocoBase (TypeScript)
DESCRIPTION: This TypeScript interface defines the configuration options for a NocoBase collection. It includes properties like `name` for the collection's identifier, `title` for display, `tree` for tree structure support, `inherits` for parent-child inheritance, `fields` for associated fields, and `timestamps`/`paranoid` for record management. The `CollectionSortable` type specifies sorting behavior.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/options.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
interface CollectionOptions {
  name: string;
  title?: string;
  // Tree structure table, TreeRepository
  tree?:
    | 'adjacency-list'
    | 'closure-table'
    | 'materialized-path'
    | 'nested-set';
  // parent-child inheritance
  inherits?: string | string[];
  fields?: FieldOptions[];
  timestamps?: boolean;
  paranoid?: boolean;
  sortable?: CollectionSortable;
  model?: string;
  repository?: string;
  [key: string]: any;
}

type CollectionSortable =
  | string
  | boolean
  | { name?: string; scopeKey?: string };
```

----------------------------------------

TITLE: Building NocoBase for Production
DESCRIPTION: Compiles and optimizes the NocoBase application for production deployment. This command should be executed after installing dependencies without the `--production` flag.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/getting-started/installation/git-clone.md#_snippet_8

LANGUAGE: bash
CODE:
```
yarn build
```

----------------------------------------

TITLE: Defining Data Structure with NocoBase Collection
DESCRIPTION: This snippet illustrates how to define a database table structure using NocoBase's `Collection` object. A `Collection` is created with a `name` and an array of `fields`, each specifying a `name` and `type`. After defining collections, the `database.sync()` method is called to synchronize the defined structure with the actual database.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_1

LANGUAGE: javascript
CODE:
```
// Define Collection
const UserCollection = database.collection({
  name: 'users',
  fields: [
    {
      name: 'name',
      type: 'string',
    },
    {
      name: 'age',
      type: 'integer',
    },
  ],
});
```

LANGUAGE: javascript
CODE:
```
await database.sync();
```

----------------------------------------

TITLE: Defining Custom Resource with Asynchronous Action in NocoBase (TypeScript)
DESCRIPTION: This snippet shows how to define a custom, database-independent resource named `notifications` with an asynchronous `send` action. The action processes the request body to send a notification via `someProvider.send()`, demonstrating how to implement custom logic for non-CRUD operations or external service integrations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
app.resource({
  name: 'notifications',
  actions: {
    async send(ctx, next) {
      await someProvider.send(ctx.request.body);
      next();
    },
  },
});
```

----------------------------------------

TITLE: Defining a New NocoBase Collection (TypeScript)
DESCRIPTION: This snippet defines a new 'orders' collection in NocoBase. It specifies various fields such as 'id' (UUID primary key), 'product' (belongsTo relationship), 'quantity', 'totalPrice', 'status', 'address', and 'user' (belongsTo relationship), establishing the schema for order data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'orders',
  fields: [
    {
      type: 'uuid',
      name: 'id',
      primaryKey: true,
    },
    {
      type: 'belongsTo',
      name: 'product',
    },
    {
      type: 'integer',
      name: 'quantity',
    },
    {
      type: 'integer',
      name: 'totalPrice',
    },
    {
      type: 'integer',
      name: 'status',
    },
    {
      type: 'string',
      name: 'address',
    },
    {
      type: 'belongsTo',
      name: 'user',
    },
  ],
};
```

----------------------------------------

TITLE: Registering a Custom Server-Side Trigger with Nocobase Workflow Plugin
DESCRIPTION: This TypeScript code demonstrates how to register a custom server-side trigger, `MyTrigger`, with the Nocobase workflow plugin. Within a custom plugin's `load` method, it retrieves the `WorkflowPlugin` instance and then uses `workflowPlugin.registerTrigger('interval', MyTrigger)` to make the new 'interval' trigger type available for use in workflows. This ensures the trigger is recognized and executable upon server startup.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/development/trigger.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import WorkflowPlugin from '@nocobase/plugin-workflow';

export default class MyPlugin extends Plugin {
  load() {
    // get workflow plugin instance
    const workflowPlugin = this.app.pm.get(WorkflowPlugin) as WorkflowPlugin;

    // register trigger
    workflowPlugin.registerTrigger('interval', MyTrigger);
  }
}
```

----------------------------------------

TITLE: Implementing Server-Side Notification Channel Logic in NocoBase
DESCRIPTION: This code defines a server-side notification channel by extending the `BaseNotificationChannel` abstract class. The `send` method is implemented to contain the custom business logic for sending notifications, such as interacting with an external SMS gateway. It logs the arguments and returns a success status with the message.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/notification-manager/development/extension.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import { BaseNotificationChannel } from '@nocobase/plugin-notification-manager';

export class ExampleServer extends BaseNotificationChannel {
  async send(args): Promise<any> {
    console.log('ExampleServer send', args);
    return { status: 'success', message: args.message };
  }
}
```

----------------------------------------

TITLE: Creating a Global Data Provider with React Context and NocoBase useRequest (TypeScript/React)
DESCRIPTION: This snippet defines a React Context and a Provider component (`PluginSettingsTableProvider`) that fetches data using NocoBase's `useRequest` hook. It makes the request result globally accessible via `PluginSettingsTableContext` and provides a custom hook `usePluginSettingsTableRequest` for consuming the data. This ensures configuration data is available throughout the application and can be refreshed.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_22

LANGUAGE: tsx
CODE:
```
import React, { createContext, FC } from 'react';
import { useRequest, UseRequestResult } from '@nocobase/client';

const PluginSettingsTableContext = createContext<UseRequestResult<{ data?: any[] }>>(null as any);

export const PluginSettingsTableProvider: FC<{ children: React.ReactNode }> = ({children}) => {
  const request = useRequest<{ data?: any[] }> ({
    url: 'samplesEmailTemplates:list',
  });

  console.log('PluginSettingsTableProvider', request.data?.data);

  return <PluginSettingsTableContext.Provider value={request}>{children}</PluginSettingsTableContext.Provider>;
}

export const usePluginSettingsTableRequest = () => {
  return React.useContext(PluginSettingsTableContext);
};
```

----------------------------------------

TITLE: Defining a NocoBase Collection in TypeScript
DESCRIPTION: This TypeScript snippet defines a new NocoBase collection named 'hello' with a single string field 'name'. This collection will be automatically synchronized with the database upon plugin activation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/your-fisrt-plugin.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'hello',
  fields: [{ type: 'string', name: 'name' }],
});
```

----------------------------------------

TITLE: Filtering Data with Repository find() in TypeScript
DESCRIPTION: This example demonstrates how to use the `filter` option within the `find()` method to query records based on specific field values and operators, such as equality and greater than (`$gt`).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/repository.md#_snippet_2

LANGUAGE: typescript
CODE:
```
// 查询 name 为 foo，并且 age 大于 18 的记录
repository.find({
  filter: {
    name: 'foo',
    age: {
      $gt: 18,
    },
  },
});
```

----------------------------------------

TITLE: Defining Resource Action Parameter Whitelist/Blacklist in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a `create` action for a `posts` resource in NocoBase, specifying `whitelist` and `blacklist` rules for its `values` parameters. This limits which fields (`title`, `content`) are allowed and which (`createdAt`, `createdById`) are disallowed during creation, ensuring server-side control over data manipulation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
app.resource({
  name: 'posts',
  actions: {
    create: {
      whitelist: ['title', 'content'],
      blacklist: ['createdAt', 'createdById'],
    },
  },
});
```

----------------------------------------

TITLE: Inserting Middleware with Tags and Position (TypeScript)
DESCRIPTION: Demonstrates how to insert custom middleware into specific positions within the built-in middleware chain using `tag`, `before`, and `after` options. This allows fine-grained control over middleware execution order relative to existing tagged middlewares.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/middleware.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
app.use(m1, { tag: 'restApi' });
app.resourcer.use(m2, { tag: 'parseToken' });
app.resourcer.use(m3, { tag: 'checkRole' });
// m4 will come before m1
app.use(m4, { before: 'restApi' });
// m5 will be inserted between m2 and m3
app.resourcer.use(m5, { after: 'parseToken', before: 'checkRole' });
```

----------------------------------------

TITLE: Default Middleware Execution Order and Resource Definition (TypeScript)
DESCRIPTION: Shows the default execution order of `acl.use()`, `resourcer.use()`, and `app.use()` middlewares when no specific insertion points are defined. It also includes a resource definition with an action handler to illustrate how different middleware types and action handlers interact in the request lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/middleware.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
app.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(1);
  await next();
  ctx.body.push(2);
});

app.resourcer.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(3);
  await next();
  ctx.body.push(4);
});

app.acl.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(5);
  await next();
  ctx.body.push(6);
});

app.resourcer.define({
  name: 'test',
  actions: {
    async list(ctx, next) {
      ctx.body = ctx.body || [];
      ctx.body.push(7);
      await next();
      ctx.body.push(8);
    }
  }
});
```

----------------------------------------

TITLE: Configuring NocoBase Router for Admin Pages (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to register the custom `MaterialPage`, `MaterialVideo`, and `MaterialImg` components with the NocoBase application router. It uses `this.app.router.add` to define routes, associating paths like `/admin/material` with their respective React components, making them accessible in the admin interface.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-page/index.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
// ...
import { MaterialImg, MaterialPage, MaterialVideo } from './MaterialPage';

export class PluginAddPageClient extends Plugin {
  async load() {
    // ...

    this.app.router.add('admin.material', {
      path: '/admin/material',
      Component: MaterialPage,
    })

    this.app.router.add('admin.material.video', {
      path: '/admin/material/video',
      Component: MaterialVideo,
    })

    this.app.router.add('admin.material.img', {
      path: '/admin/material/img',
      Component: MaterialImg,
    })
  }
}
```

----------------------------------------

TITLE: Defining Parent-Child Inheritance Collections in NocoBase (TypeScript)
DESCRIPTION: This snippet illustrates how to establish an inheritance relationship between NocoBase collections. Collection 'b' is defined to inherit from collection 'a', allowing 'b' to automatically include fields and logic from 'a' without explicit redefinition.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/collection-template.md#_snippet_2

LANGUAGE: ts
CODE:
```
db.collection({
  name: 'a',
  fields: [],
});

db.collection({
  name: 'b',
  inherits: 'a',
  fields: [],
});
```

----------------------------------------

TITLE: Extend NocoBase Auth Abstract Class for Custom Authentication
DESCRIPTION: To implement custom authentication logic in NocoBase, inherit from the core `Auth` abstract class. This snippet demonstrates the required methods to be overridden for a custom authentication class, providing a foundation for your authentication strategy.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/auth/dev/guide.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { Auth } from '@nocobase/auth';

class CustomAuth extends Auth {
  set user(user) {}
  get user() {}

  async check() {}
  async signIn() {}
}
```

----------------------------------------

TITLE: Handling Before/After Create Events in NocoBase (TypeScript)
DESCRIPTION: This snippet illustrates how to attach listeners for 'beforeCreate' and 'afterCreate' events. These events are specifically triggered when a new piece of data is created using `repository.create()`. The listeners provide access to the model instance and creation options, enabling actions before or after the data is persisted.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_28

LANGUAGE: TypeScript
CODE:
```
on(eventName: `${string}.beforeCreate` | 'beforeCreate' | `${string}.afterCreate` | 'afterCreate', listener: CreateListener): this
```

LANGUAGE: TypeScript
CODE:
```
import type { CreateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type CreateListener = (
  model: Model,
  options?: CreateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeCreate', async (model, options) => {
  // do something
});

db.on('books.afterCreate', async (model, options) => {
  const { transaction } = options;
  const result = await model.constructor.findByPk(model.id, {
    transaction,
  });
  console.log(result);
});
```

----------------------------------------

TITLE: Defining Data Table Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a data table collection in memory using `db.collection()`, specifying its name and fields with their types. To persist this definition to the database, the `db.sync()` method must be called subsequently.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
    {
      type: 'float',
      name: 'price',
    },
  ],
});

// sync collection as table to db
await db.sync();
```

----------------------------------------

TITLE: Defining a NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define the configuration for a new data table using `defineCollection`. It specifies the collection's name and its fields, which can then be imported by `db.import()` for database synchronization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_21

LANGUAGE: TypeScript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'users',
  fields: [
    {
      type: 'string',
      name: 'name',
    },
  ],
});
```

----------------------------------------

TITLE: Extending a NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to extend an existing collection's configuration using `extendCollection` (aliased as `extend`). It adds a new 'price' field to the 'books' collection, merging with its original definition when imported.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_23

LANGUAGE: TypeScript
CODE:
```
import { extend } from '@nocobase/database';

// Extend again
export default extend({
  name: 'books',
  fields: [{ name: 'price', type: 'number' }],
});
```

----------------------------------------

TITLE: Extending Orders Collection with Delivery Field (TypeScript)
DESCRIPTION: This snippet shows how to extend the existing 'orders' collection schema by adding a 'hasOne' relationship field named 'delivery'. This field links an order to its corresponding delivery information stored in the 'deliveries' collection, enabling a one-to-one relationship.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions.md#_snippet_2

LANGUAGE: typescript
CODE:
```
export default {
  name: 'orders',
  fields: [
    // ...other fields
    {
      type: 'hasOne',
      name: 'delivery',
    },
  ],
};
```

----------------------------------------

TITLE: Defining a Basic Collection in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a basic collection named 'posts' using `db.collection()` in NocoBase. It specifies fields like 'title' (string) and 'content' (text), illustrating the fundamental structure of a data collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    { name: 'title', type: 'string' }
    { name: 'content', type: 'text' },
    // ...
  ]
});
```

----------------------------------------

TITLE: Basic Plugin Class Definition - TypeScript
DESCRIPTION: Demonstrates the basic structure for defining a server-side plugin in NocoBase by extending the `Plugin` class from `@nocobase/server`. This serves as the fundamental entry point for custom plugin logic and configuration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/server/plugin.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export class PluginDemoServer extends Plugin {}

export default PluginDemoServer;
```

----------------------------------------

TITLE: Defining a NocoBase Client Plugin Class (TypeScript)
DESCRIPTION: This TypeScript snippet defines a basic NocoBase client plugin class, 'PluginSampleHelloClient', extending the 'Plugin' base class. It outlines the three core lifecycle methods: 'afterAdd', 'beforeLoad', and 'load', which are executed at different stages of the plugin's initialization and loading process.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';

export class PluginSampleHelloClient extends Plugin {
  async afterAdd() {}

  async beforeLoad() {}

  async load() {}
}

export default PluginSampleHelloClient;
```

----------------------------------------

TITLE: Defining a Resource with Custom Action in NocoBase ResourceManager (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a new resource named 'auth' using `app.resourceManager.define()`. It includes a custom asynchronous action `check` which can perform operations and then call `next()` to proceed with the middleware chain. This is useful for implementing custom authentication or authorization checks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource-manager.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
app.resourceManager.define({
  name: 'auth',
  actions: {
    check: async (ctx, next) => {
      // ...
      await next();
    },
  },
});
```

----------------------------------------

TITLE: Configuring BelongsTo Association in NocoBase
DESCRIPTION: This NocoBase Collection configuration defines a `belongsTo` association named `user` for the `posts` collection. It specifies that the `posts` table has a `userId` foreign key referencing the `users` collection, simplifying relational constraint creation within the NocoBase framework.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/association-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
{
  name: 'posts',
  fields: [
    {
      type: 'belongsTo',
      name: 'user',
      target: 'users',
      foreignKey: 'userId',
    },
  ],
}
```

----------------------------------------

TITLE: Deducting Product Inventory on Order Creation (TypeScript)
DESCRIPTION: This example shows how to automatically deduct product inventory when a new order is created in a NocoBase application. It uses the `orders.afterCreate` database event to listen for new order creations. Inside the event handler, it retrieves the associated product and updates its `inventory` by subtracting the `order.quantity`, ensuring both operations are part of the same transaction for data consistency.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/events.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
class ShopPlugin extends Plugin {
  beforeLoad() {
    this.db.on('orders.afterCreate', async (order, options) => {
      const product = await order.getProduct({
        transaction: options.transaction,
      });

      await product.update(
        {
          inventory: product.inventory - order.quantity,
        },
        {
          transaction: options.transaction,
        },
      );
    });
  }
}
```

----------------------------------------

TITLE: Implementing Custom Deliver Action for NocoBase Orders (TypeScript)
DESCRIPTION: This code defines a custom 'deliver' action for the 'orders' resource within a NocoBase plugin. It updates the order's status to 'shipped' (2) and creates or updates associated delivery details, including the delivery status, using the 'Repository' API. The updated order object is then returned in the response body.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async deliver(ctx, next) {
          const { filterByTk } = ctx.action.params;
          const orderRepo = ctx.db.getRepository('orders');

          const [order] = await orderRepo.update({
            filterByTk,
            values: {
              status: 2,
              delivery: {
                ...ctx.action.params.values,
                status: 0,
              },
            },
          });

          ctx.body = order;

          next();
        },
      },
    });
  }
}
```

----------------------------------------

TITLE: Creating NocoBase Action Schema and Props Hook (TypeScript)
DESCRIPTION: This TypeScript code defines `useDocumentActionProps`, a hook that provides dynamic properties for an action button, including its title and an `onClick` handler to open a URL from the schema. It also defines `createDocumentActionSchema`, a function that generates a NocoBase UI Schema for an 'Action' component, embedding a custom `x-doc-url` and linking to the `useDocumentActionProps` hook for dynamic behavior.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/action-simple.md#_snippet_4

LANGUAGE: typescript
CODE:
```
import { useFieldSchema } from '@formily/react';
import { ISchema } from "@nocobase/client"
import { useT } from '../locale';
import { ActionName } from '../constants';

export function useDocumentActionProps() {
  const fieldSchema = useFieldSchema();
  const t = useT();
  return {
    title: t(ActionName),
    type: 'primary',
    onClick() {
      window.open(fieldSchema['x-doc-url'])
    }
  }
}

export const createDocumentActionSchema = (blockComponent: string): ISchema & { 'x-doc-url': string } => {
  return {
    type: 'void',
    'x-component': 'Action',
    'x-doc-url': `https://client.docs.nocobase.com/components/${blockComponent}`,
    'x-use-component-props': 'useDocumentActionProps',
  }
}
```

----------------------------------------

TITLE: Validate NocoBase UI Block Schema in Client Plugin (TypeScript)
DESCRIPTION: This code demonstrates how to validate a defined UI Schema by integrating it into a temporary page within a NocoBase client plugin. It registers the custom 'Image' component and adds a route to render the schema using `SchemaComponent` for testing purposes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-simple.md#_snippet_7

LANGUAGE: TSX
CODE:
```
import React from 'react';
import { Plugin, SchemaComponent } from '@nocobase/client';
import { Image } from './component'
import { imageSchema } from './schema'

export class PluginInitializerBlockSimpleClient extends Plugin {
  async load() {
    this.app.addComponents({ Image })

    this.app.router.add('admin.image-schema', {
      path: '/admin/image-schema',
      Component: () => {
        return <div style={{ marginTop: 20, marginBottom: 20 }}>
          <SchemaComponent schema={{ properties: { test: imageSchema } }} />
        </div>
      }
    })
  }
}

export default PluginInitializerBlockSimpleClient;
```

----------------------------------------

TITLE: Finding Records with Complex Filter Conditions - TypeScript
DESCRIPTION: This example demonstrates how to use the `filter` option within the `find()` method to query data based on multiple conditions. It shows combining exact matches with operator-based comparisons (e.g., `$gt` for 'greater than') to retrieve specific datasets.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_19

LANGUAGE: typescript
CODE:
```
// Find records with name "foo" and age above 18
repository.find({
  filter: {
    name: 'foo',
    age: {
      $gt: 18,
    },
  },
});
```

----------------------------------------

TITLE: Defining Collection Options Interface (TypeScript)
DESCRIPTION: This interface defines the configuration options for a NocoBase Collection, representing a data structure like a table. It includes properties such as `name` (required), `title`, `tree` for hierarchical structures, `inherits` for inheritance, `fields` for defining associated fields, and options for `timestamps`, `paranoid`, `sortable`, `model`, and `repository`. The `CollectionSortable` type defines options for sorting.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections/options.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
interface CollectionOptions {
  name: string;
  title?: string;
  // 树结构表，TreeRepository
  tree?:
    | 'adjacency-list'
    | 'closure-table'
    | 'materialized-path'
    | 'nested-set';
  // 父子继承
  inherits?: string | string[];
  fields?: FieldOptions[];
  timestamps?: boolean;
  paranoid?: boolean;
  sortable?: CollectionSortable;
  model?: string;
  repository?: string;
  [key: string]: any;
}

type CollectionSortable =
  | string
  | boolean
  | { name?: string; scopeKey?: string };
```

----------------------------------------

TITLE: Filtering with `$notExists` Operator for Relational Fields - TypeScript
DESCRIPTION: This snippet demonstrates the `$notExists` operator, used to filter records where no relational data is present in a specified field. This operator is useful for `hasOne`, `hasMany`, `belongsTo`, and `belongsToMany` relationship types.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/operators.md#_snippet_47

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    author: {
      $notExists: true,
    },
  },
});
```

----------------------------------------

TITLE: Initializing and Configuring AuthManager in TypeScript
DESCRIPTION: This snippet demonstrates the basic setup of `AuthManager`. It shows how to instantiate the manager, configure a custom storer for retrieving authenticator data from a database, register a 'basic' authentication type using `BasicAuth`, and integrate the authentication middleware into the application's resource manager.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/auth/auth-manager.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const authManager = new AuthManager({
  // Key to retrieve the current authenticator identifier from the request header
  authKey: 'X-Authenticator'
});

// Set methods for storing and retrieving authenticators in AuthManager
authManager.setStorer({
  get: async (name: string) => {
    return db.getRepository('authenticators').find({ filter: { name } });
  }
});

// Register an authentication type
authManager.registerTypes('basic', {
  auth: BasicAuth,
  title: 'Password'
});

// Use authentication middleware
app.resourceManager.use(authManager.middleware());
```

----------------------------------------

TITLE: Defining Formula Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a 'formula' type field, a NocoBase extension for calculated fields. It uses `mathjs` to evaluate expressions that can reference other columns in the same record, such as calculating a 'total' from 'price' and 'quantity'.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/field.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'orders',
  fields: [
    {
      type: 'double',
      name: 'price',
    },
    {
      type: 'integer',
      name: 'quantity',
    },
    {
      type: 'formula',
      name: 'total',
      expression: 'price * quantity',
    },
  ],
});
```

----------------------------------------

TITLE: Making Client-Side Requests with NocoBase app.apiClient (TypeScript)
DESCRIPTION: This snippet demonstrates how to make a client-side HTTP request using `app.apiClient` within a NocoBase plugin's `load` method. It shows fetching data from a 'test' URL, illustrating basic API interaction within the plugin lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/api-client.md#_snippet_0

LANGUAGE: ts
CODE:
```
class PluginSampleAPIClient extends Plugin {
  async load() {
    const { data } = await this.app.apiClient.request({ url: 'test' });
  }
}
```

----------------------------------------

TITLE: Returning Custom Results from Workflow Instruction in TypeScript
DESCRIPTION: This snippet demonstrates how to return specific execution results from a workflow instruction's `run` method using the `result` property. The `result` value is saved in the node's task object and can be accessed by subsequent nodes. It also shows how to retrieve custom configuration values from `node.config`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/development/instruction.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { Instruction, JOB_STATUS } from '@nocobase/plugin-workflow';

export class RandomStringInstruction extends Instruction {
  run(node, input, processor) {
    // customized config from node
    const { digit = 1 } = node.config;
    const result = `${Math.round(10 ** digit * Math.random())}`.padStart(
      digit,
      '0',
    );
    return {
      status: JOB_STATUS.RESOVLED,
      result,
    };
  },
};
```

----------------------------------------

TITLE: Defining a New Collection in NocoBase (TypeScript)
DESCRIPTION: This example shows how to use `defineCollection()` to create a configuration for a new data table named 'users' with a 'name' field of type 'string'. This configuration can then be imported by `db.import()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_21

LANGUAGE: TypeScript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'users',
  fields: [
    {
      type: 'string',
      name: 'name',
    },
  ],
});
```

----------------------------------------

TITLE: Registering Custom Timeline Component in NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to register the custom `Timeline` component with the NocoBase client application. By extending `Plugin` and calling `this.app.addComponents({ Timeline })` in the `load` method, the component becomes available for use within the NocoBase UI schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data-modal.md#_snippet_5

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { Timeline } from './component';

export class PluginInitializerBlockDataModalClient extends Plugin {
  async load() {
    this.app.addComponents({ Timeline })
  }
}

export default PluginInitializerBlockDataModalClient;
```

----------------------------------------

TITLE: Configuring NocoBase Commands with IPC, Auth, and Preload (TypeScript)
DESCRIPTION: This snippet illustrates how to apply special configurations like `ipc()`, `auth()`, and `preload()` to NocoBase commands. These configurations modify the command's execution behavior, enabling interaction with a running app instance, performing database verification, or pre-loading application configurations before execution.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/commands.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
app.command('a').ipc().action()
app.command('a').auth().action()
app.command('a').preload().action()
```

----------------------------------------

TITLE: Defining Custom SchemaInitializer Item in NocoBase (TypeScript)
DESCRIPTION: This snippet defines `customRefreshActionInitializerItem`, a SchemaInitializer item of type 'item' for NocoBase. It uses `useSchemaInitializer` to get the `insert` function and `useT` for internationalization, providing a title and an `onClick` handler that inserts `customRefreshActionSchema` when the item is clicked. This item serves as a unique identifier for a custom refresh action within the NocoBase UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/configure-actions.md#_snippet_14

LANGUAGE: TypeScript
CODE:
```
import { SchemaInitializerItemType, useSchemaInitializer } from "@nocobase/client";
import { customRefreshActionSchema } from "./schema";
import { ActionName } from "./constants";
import { useT } from "../../../../locale";

export const customRefreshActionInitializerItem: SchemaInitializerItemType = {
  type: 'item',
  name: ActionName,
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT();
    return {
      title: t(ActionName),
      onClick() {
        insert(customRefreshActionSchema)
      },
    };
  },
};
```

----------------------------------------

TITLE: Defining General Collection in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a basic, general-purpose collection named 'posts' in NocoBase using TypeScript. It initializes the collection with a single string field for 'title', serving as a fundamental example for creating new data models.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/collection-template.md#_snippet_0

LANGUAGE: ts
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});
```

----------------------------------------

TITLE: Defining Text Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet illustrates defining a 'text' type field named 'content' within a 'books' collection. This field is equivalent to `TEXT` in most databases and is used for longer text content.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'text',
      name: 'content',
    },
  ],
});
```

----------------------------------------

TITLE: Defining and Using Custom Components with NocoBase SchemaComponent (TypeScript)
DESCRIPTION: This snippet demonstrates how to define custom React functional components (`SamplesHello`) and a custom hook (`useSamplesHelloProps`) for dynamic schema properties within NocoBase. It shows how to integrate these into a UI schema (`ISchema`) using `SchemaComponent`, illustrating both direct component/hook references and string-based registration for `x-component` and `x-use-component-props`. The `withDynamicSchemaProps` HOC is used to pass schema-derived props to the component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initailizer/add-item-to-block.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import { ISchema, SchemaComponent, withDynamicSchemaProps } from "@nocobase/client"
import { uid } from '@formily/shared'
import { useFieldSchema } from '@formily/react'
import React, { FC } from "react"

const SamplesHello: FC<{ name: string }> = withDynamicSchemaProps(({ name }) => {
  return <div>hello {name}</div>
})

const useSamplesHelloProps = () => {
  const schema = useFieldSchema();
  return { name: schema.name }
}

const schema: ISchema = {
  type: 'void',
  name: uid(),
  properties: {
    demo1: {
      type: 'void',
      'x-component': SamplesHello,
      'x-component-props': {
        name: 'demo1',
      },
    },
    demo2: {
      type: 'void',
      'x-component': SamplesHello,
      'x-use-component-props': useSamplesHelloProps,
    },
    demo3: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-component-props': {
        name: 'demo3',
      },
    },
    demo4: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-use-component-props': 'useSamplesHelloProps',
    },
  }
}

export const SamplesCustomPage = () => {
  return <SchemaComponent schema={schema} components={{ SamplesHello }} scope={{ useSamplesHelloProps }}></SchemaComponent>
}
```

----------------------------------------

TITLE: Initializing AuthManager and Registering Basic Authentication (TypeScript)
DESCRIPTION: This snippet demonstrates the basic setup of `AuthManager`. It initializes the manager with an `authKey` to identify the authenticator in request headers, sets a custom `storer` to retrieve authenticator data from the database, registers a 'basic' authentication type using `BasicAuth`, and integrates the `AuthManager` as middleware into the application's resource manager.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/auth/auth-manager.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const authManager = new AuthManager({
  // Key to retrieve the current authenticator identifier from the request header
  authKey: 'X-Authenticator',
});

// Set methods for storing and retrieving authenticators in AuthManager
authManager.setStorer({
  get: async (name: string) => {
    return db.getRepository('authenticators').find({ filter: { name } });
  },
});

// Register an authentication type
authManager.registerTypes('basic', {
  auth: BasicAuth,
  title: 'Password',
});

// Use authentication middleware
app.resourceManager.use(authManager.middleware());
```

----------------------------------------

TITLE: Define Double Field in NocoBase Collection (TS)
DESCRIPTION: This snippet shows how to define a double-precision floating-point field named 'price' in a NocoBase collection. The 'double' type is used for 64-bit decimal numbers.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/field.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'double',
      name: 'price'
    }
  ]
});
```

----------------------------------------

TITLE: Defining Orders Collection in NocoBase (TypeScript)
DESCRIPTION: This snippet defines a new `orders` collection with various fields such as `id` (UUID primary key), `product` (belongsTo relationship), `quantity`, `totalPrice`, `status`, `address`, and `user` (belongsTo relationship). It establishes a many-to-one relationship with `product` and `user` collections.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_6

LANGUAGE: ts
CODE:
```
export default {
  name: 'orders',
  fields: [
    {
      type: 'uuid',
      name: 'id',
      primaryKey: true,
    },
    {
      type: 'belongsTo',
      name: 'product',
    },
    {
      type: 'integer',
      name: 'quantity',
    },
    {
      type: 'integer',
      name: 'totalPrice',
    },
    {
      type: 'integer',
      name: 'status',
    },
    {
      type: 'string',
      name: 'address',
    },
    {
      type: 'belongsTo',
      name: 'user',
    },
  ],
};
```

----------------------------------------

TITLE: Registering Custom Data Repositories (TypeScript)
DESCRIPTION: This snippet illustrates registering a custom data repository class, `MyRepository`, with the NocoBase database. It demonstrates how to link this custom repository to a collection named 'myCollection' using the `repository` property, enabling custom data access and manipulation logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_13

LANGUAGE: ts
CODE:
```
import { Repository } from '@nocobase/database';

class MyRepository extends Repository {
  // ...
}

db.registerRepositories({
  myRepository: MyRepository,
});

db.collection({
  name: 'myCollection',
  repository: 'myRepository',
});
```

----------------------------------------

TITLE: Initialize NocoBase Project and Plugin (Bash)
DESCRIPTION: This snippet provides commands to set up a new NocoBase application and initialize a plugin. It guides through creating the app, installing dependencies, and then creating and enabling a new plugin for development.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/component-and-scope/global.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
yarn pm create @nocobase-sample/plugin-component-and-scope-global
yarn pm enable @nocobase-sample/plugin-component-and-scope-global
yarn dev
```

----------------------------------------

TITLE: Initializing NocoBase Application (Bash)
DESCRIPTION: This snippet demonstrates how to initialize a new NocoBase application using `yarn create nocobase-app`, navigate into the project directory, install dependencies, and perform the initial NocoBase installation. This is a prerequisite step for setting up a development environment.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/interface.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

----------------------------------------

TITLE: Using `getRepository` for Data Access in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to obtain a data repository for a specific collection and how to handle relationships. It shows creating an author and then creating a post associated with that author using the `authors.posts` repository and the author's ID as `relationId`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_16

LANGUAGE: TypeScript
CODE:
```
const AuthorsRepo = db.getRepository('authors');
const author1 = AuthorsRepo.create({ name: 'author1' });

const PostsRepo = db.getRepository('authors.posts', author1.id);
const post1 = AuthorsRepo.create({ title: 'post1' });
asset(post1.authorId === author1.id); // true
```

----------------------------------------

TITLE: Perform CRUD Operations with Nocobase Repository
DESCRIPTION: This snippet demonstrates how to perform common CRUD (Create, Read, Update, Delete) operations using Nocobase's Repository. It shows examples of creating a new record, finding an existing one, updating its values, and finally destroying it, all through the UserRepository instance.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_2

LANGUAGE: javascript
CODE:
```
const UserRepository = UserCollection.repository();

// 作成
await UserRepository.create({
  name: '张三',
  age: 18,
});

// 検索
const user = await UserRepository.findOne({
  filter: {
    name: '张三',
  },
});

// 更新
await UserRepository.update({
  values: {
    age: 20,
  },
});

// 削除
await UserRepository.destroy(user.id);
```

----------------------------------------

TITLE: Implementing Asynchronous Workflow Nodes with Pending Status (TypeScript)
DESCRIPTION: This snippet demonstrates how to create an asynchronous workflow instruction that can pause execution and resume later. The `run` method returns `JOB_STATUS.PENDING` and saves the job, while the `resume` method is implemented to continue the workflow once an external asynchronous operation (e.g., payment) completes and notifies the workflow engine.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/development/instruction.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
import { Instruction, JOB_STATUS } from '@nocobase/plugin-workflow';

export class PayInstruction extends Instruction {
  async run(node, input, processor) {
    // job could be create first via processor
    const job = await processor.saveJob({
      status: JOB_STATUS.PENDING,
    });

    const { workflow } = processor;
    // do payment asynchronously
    paymentService.pay(node.config, (result) => {
      // notify processor to resume the job
      return workflow.resume(job.id, result);
    });

    // return created job instance
    return job;
  }

  resume(node, job, processor) {
    // check payment status
    job.set('status', job.result.status === 'ok' ? JOB_STATUS.RESOVLED : JOB_STATUS.REJECTED);
    return job;
  },
};
```

----------------------------------------

TITLE: Setting up Server-Side Tests with NocoBase and Vitest (TypeScript)
DESCRIPTION: This snippet demonstrates the basic setup for server-side tests using NocoBase's `@nocobase/test` utilities within a Vitest `describe` block. It initializes a `MockServer` instance, sets up database and agent objects before all tests, and ensures the application is destroyed after all tests to clean up resources.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/test/server.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
describe('actions', () => {
  let app: MockServer;
  let db: Database;
  let agent: any;

  beforeAll(async () => {
    app = await createMockServer({
      plugins: ['acl', 'users', 'data-source-manager'],
    });
    db = app.db;
    agent = app.agent();
  });

  afterAll(async () => {
    await app.destroy();
  });
});
```

----------------------------------------

TITLE: NocoBase Roles and Permissions Management
DESCRIPTION: NocoBase provides granular permission control through roles, allowing administrators to define access to resources. Users can be assigned multiple roles and switch between them. The department plugin allows binding roles to departments, ensuring users inherit departmental permissions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/security.md#_snippet_9

LANGUAGE: APIDOC
CODE:
```
Feature: Roles and Permissions Management
Mechanism: Control user access to resources by defining roles, assigning permissions to roles, and binding users to roles.
Flexibility: Users can have multiple roles and switch between them.
Integration: Department plugin allows binding roles to departments for inherited permissions.
Purpose: Granular control over user permissions to reduce system resource leakage risk.
```

----------------------------------------

TITLE: Listening and Unlistening to Database Events (TypeScript)
DESCRIPTION: This snippet illustrates how to register a listener for a database event using `db.on()` and subsequently remove it using `db.off()`. The example uses the 'afterCreate' event to log model changes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_17

LANGUAGE: typescript
CODE:
```
const listener = async (model, options) => {
  console.log(model);
};

db.on('afterCreate', listener);

db.off('afterCreate', listener);
```

----------------------------------------

TITLE: Handling After Create With Associations Event (TypeScript)
DESCRIPTION: This event is triggered after creating a piece of data that includes hierarchical associations, specifically when `repository.create()` is called. It allows custom logic to be executed post-creation, providing access to the created model and creation options.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_32

LANGUAGE: TypeScript
CODE:
```
on(eventName: `${string}.afterCreateWithAssociations` | 'afterCreateWithAssociations', listener: CreateWithAssociationsListener): this
```

LANGUAGE: TypeScript
CODE:
```
import type { CreateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type CreateWithAssociationsListener = (
  model: Model,
  options?: CreateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('afterCreateWithAssociations', async (model, options) => {
  // do something
});

db.on('books.afterCreateWithAssociations', async (model, options) => {
  // do something
});
```

----------------------------------------

TITLE: Registering Custom Password Field Type in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet illustrates how to extend NocoBase's field types by registering a custom 'password' field. It defines a 'MyPlugin' class that registers 'PasswordField' during 'beforeLoad' and a 'PasswordField' class that specifies its 'dataType' as 'DataTypes.STRING'. This enables NocoBase to recognize and properly handle the new field type.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/field-extension.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export class MyPlugin extends Plugin {
  beforeLoad() {
    this.db.registerFieldTypes({
      password: PasswordField,
    });
  }
}

export class PasswordField extends Field {
  get dataType() {
    return DataTypes.STRING;
  }
}
```

----------------------------------------

TITLE: Register Schema Components and Scopes Globally (TypeScript/TSX)
DESCRIPTION: This snippet updates the plugin's index.ts to globally register the SamplesHello component and useSamplesHelloProps hook. Registering them with this.app.addComponents() and this.app.addScopes() respectively makes them discoverable and usable by SchemaComponent within the application's UI schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/component-and-scope/global.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { SamplesCustomPage, SamplesHello, useSamplesHelloProps } from './CustomPage'

export class PluginComponentAndScopeGlobalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page1', {
      path: '/admin/custom-page1',
      Component: 'SamplesCustomPage',
    })

    this.app.addComponents({ SamplesCustomPage, SamplesHello })
    this.app.addScopes({ useSamplesHelloProps })
  }
}

export default PluginComponentAndScopeGlobalClient;
```

----------------------------------------

TITLE: Defining NocoBase apiClient.request() Method (TypeScript)
DESCRIPTION: This defines the `request` method of the `APIClient` class, which handles client-side HTTP requests. It supports both standard `AxiosRequestConfig` and NocoBase's `ResourceActionOptions` for flexible request configuration, returning a Promise.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/api-client.md#_snippet_1

LANGUAGE: ts
CODE:
```
class APIClient {
  // Client-side requests, supporting AxiosRequestConfig and ResourceActionOptions
  request<T = any, R = AxiosResponse<T>, D = any>(
    config: AxiosRequestConfig<D> | ResourceActionOptions,
  ): Promise<R>;
}
```

----------------------------------------

TITLE: NocoBase Database Built-in Events
DESCRIPTION: The database triggers the following events at corresponding lifecycle stages. You can subscribe to them using the `on()` method to perform specific processing and meet various business needs.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_12

LANGUAGE: APIDOC
CODE:
```
Overview: The database triggers events like 'beforeSync' and 'afterSync' during its lifecycle. These can be subscribed to using the `on()` method to implement custom logic.
```

----------------------------------------

TITLE: Review Original NocoBase AuthLayout Component in TSX
DESCRIPTION: This TSX code displays the default `AuthLayout` component from the NocoBase Auth plugin. It defines the basic structure for authentication pages, including the system title, an `AuthenticatorsContextProvider`, and an `Outlet` for nested routes like sign-in or sign-up forms.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/router/replace-page/index.md#_snippet_1

LANGUAGE: tsx
CODE:
```
export function AuthLayout() {
  const { data } = useSystemSettings();

  return (
    <div
      style={{
        maxWidth: 320,
        margin: '0 auto',
        paddingTop: '20vh'
      }}
    >
      <h1>{data?.data?.title}</h1>
      <AuthenticatorsContextProvider>
        <Outlet />
      </AuthenticatorsContextProvider>
      <div
        className={css`
          position: absolute;
          bottom: 24px;
          width: 100%;
          left: 0;
          text-align: center;
        `}
      >
        <PoweredBy />
      </div>
    </div>
  );
}
```

----------------------------------------

TITLE: Extend NocoBase BaseAuth Class
DESCRIPTION: In most cases, extended user authentication types can reuse existing JWT authentication logic to generate the authentication token. The `BaseAuth` class in the NocoBase core already implements the abstract `Auth` class, allowing plugins to directly inherit from `BaseAuth` to reuse common logic and reduce development costs.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/auth/dev/guide.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { BaseAuth } from '@nocobase/auth';
import { AuthConfig } from '@nocobase/auth';

class CustomAuth extends BaseAuth {
  constructor(config: AuthConfig) {
    // Define the user collection
    const userCollection = config.ctx.db.getCollection('users');
    super({ ...config, userCollection });
  }

  // Implement user login logic
  async validate(): Promise<any> {}
}
```

----------------------------------------

TITLE: Implementing Onion Circle Middleware (TypeScript)
DESCRIPTION: Illustrates the 'onion circle' model for middleware execution, where `next()` allows control to pass to subsequent middleware, and execution unwinds after `next()` resolves. This example shows two application-level middlewares pushing values to `ctx.body` to demonstrate the execution flow.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/middleware.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
app.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(1);
  await next();
  ctx.body.push(2);
});

app.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(3);
  await next();
  ctx.body.push(4);
});
```

----------------------------------------

TITLE: Overriding AuthLayout Component in NocoBase Client
DESCRIPTION: This snippet demonstrates how to override a client-side component, specifically `AuthLayout`, by registering a custom component using `this.app.addComponents`. This method is effective when the original component is registered via a string identifier.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/router/replace-page/index.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { CustomAuthLayout } from './AuthLayout';

export class PluginChangePageClient extends Plugin {
  async load() {
   this.app.addComponents({ AuthLayout: CustomAuthLayout })
  }
}
```

----------------------------------------

TITLE: Extending and Registering BaseInterface in TypeScript
DESCRIPTION: This snippet demonstrates how to extend the `BaseInterface` class to create a `CustomInterface` with custom `toValue` and `toString` logic. It also shows how to register this new interface type with the `db.interfaceManager` for use within the application. The `toValue` method converts an external string to an internal value, while `toString` converts an internal value to a string.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/interfaces/base-interface.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
class CustomInterface extends BaseInterface {
  async toValue(value: string, ctx?: any): Promise<any> {
    // Custom toValue logic
  }

  toString(value: any, ctx?: any) {
    // Custom toString logic
  }
}
// Register Interface
db.interfaceManager.registerInterfaceType('customInterface', CustomInterface)
```

----------------------------------------

TITLE: Nesting Object Schema with Custom Components in NocoBase (TSX)
DESCRIPTION: This snippet demonstrates how to nest an object schema within a custom React component (`Hello`) using NocoBase's `SchemaComponent`. The `Hello` component adapts `props.children` to render nested properties, while the `World` component is used for a specific string property. It shows a basic setup for rendering a structured schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/extending.md#_snippet_4

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

// The Hello component adapted children, allowing nested properties.
const Hello = (props) => <h1>Hello, {props.children}!</h1>;
const World = () => <span>world</span>;

const schema = {
  type: 'object',
  name: 'hello',
  'x-component': 'Hello',
  properties: {
    world: {
      type: 'string',
      'x-component': 'World',
    },
  },
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello, World }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Creating Custom Winston-based Logger in NocoBase (TypeScript)
DESCRIPTION: Demonstrates how to create a custom logger instance using `createLogger` from `@nocobase/logger` for scenarios where Winston's native methods are preferred over NocoBase's system-provided ones. The `options` parameter extends `winston.LoggerOptions`, allowing preset `transports` (e.g., 'console', 'file') and `format` (e.g., 'logfmt', 'json').
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/logger.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import { createLogger } from '@nocobase/logger';

const logger = createLogger({
  // options
});
```

----------------------------------------

TITLE: Extending Orders Collection with Delivery Association in NocoBase (TypeScript)
DESCRIPTION: This snippet extends the existing 'orders' collection schema by adding a `hasOne` association to the 'delivery' collection. This establishes a one-to-one relationship, allowing an order to have a single associated delivery record, crucial for managing shipping details.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_11

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'orders',
  fields: [
    // ... . other fields
    {
      type: 'hasOne',
      name: 'delivery',
    },
  ],
};
```

----------------------------------------

TITLE: Signing In with NocoBase SDK - TypeScript
DESCRIPTION: This snippet demonstrates how to use the `useAPIClient` hook from `@nocobase/client` to access the NocoBase API client within a component. It then shows how to call the `api.auth.signIn` method to authenticate a user, passing `data` and an `authenticator`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/auth/dev/guide.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { useAPIClient } from '@nocobase/client';

// use in component
const api = useAPIClient();
api.auth.signIn(data, authenticator);
```

----------------------------------------

TITLE: Defining a Product Collection for a Plugin (TypeScript)
DESCRIPTION: This snippet defines the 'products' collection structure for an online store plugin. It specifies fields such as 'title' (string), 'price' (integer), 'enabled' (boolean), and 'inventory' (integer), intended for use within a `collections/products.ts` file.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'products',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
    {
      type: 'integer',
      name: 'price',
    },
    {
      type: 'boolean',
      name: 'enabled',
    },
    {
      type: 'integer',
      name: 'inventory',
    },
  ],
};
```

----------------------------------------

TITLE: Defining a Resource with HandlerType Action in NocoBase ResourceManager (TypeScript)
DESCRIPTION: This snippet illustrates defining a 'users' resource where an action `updateProfile` is directly implemented as a `HandlerType` middleware function. This approach allows for custom logic to be executed for specific resource actions, such as updating a user's profile, before continuing the request lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource-manager.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
app.resourceManager.define({
  name: 'users',
  actions: {
    updateProfile: async (ctx, next) => {
      // ...
      await next();
    },
  },
});
```

----------------------------------------

TITLE: Check ACL Operation Permission
DESCRIPTION: Determines if an operation can be executed based on the provided role, resource, and action. It returns the final operation parameters if permission is granted, or null if permission is denied.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/acl/acl.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
interface CanArgs {
  role: string;
  resource: string;
  action: string;
  ctx?: any;
}

interface CanResult {
  role: string;
  resource: string;
  action: string;
  params?: any;
}
```

LANGUAGE: APIDOC
CODE:
```
### `can()`

Determines the permission to execute an operation and returns the final operation parameters. Returns `null` if there is no permission.

#### Signature

- `can(options: CanArgs): CanResult | null`

#### Details

##### CanArgs

| Property   | Type     | Description          |
|------------|----------|----------------------|
| `role`     | `string` | Role identifier      |
| `resource` | `string` | Resource identifier  |
| `action`   | `string` | Action identifier    |
| `ctx`      | `any`    | Optional, request context |

##### CanResult

| Property   | Type     | Description          |
|------------|----------|----------------------|
| `role`     | `string` | Role identifier      |
| `resource` | `string` | Resource identifier  |
| `action`   | `string` | Action identifier    |
| `params`   | `any`    | Optional, operation parameters |
```

----------------------------------------

TITLE: Define Integer Field in NocoBase Collection (TS)
DESCRIPTION: This snippet shows how to define an integer field named 'pages' in a NocoBase collection. The 'integer' type is used for 32-bit whole numbers.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/field.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'integer',
      name: 'pages'
    }
  ]
});
```

----------------------------------------

TITLE: Adding Items to Existing Schema Initializers - New Way (SchemaInitializerManager)
DESCRIPTION: This snippet illustrates the new, recommended way to add items to an existing `SchemaInitializer` in NocoBase 0.17. It uses the `schemaInitializerManager.addItem()` method within a NocoBase `Plugin`'s `load` method, providing a more structured and maintainable approach compared to direct context manipulation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/welcome/release/upgrade-to/v017.md#_snippet_1

LANGUAGE: tsx
CODE:
```
class MyPlugin extends Plugin {
  async load() {
    this.schemaInitializerManager.addItem(
      'BlockInitializers',
      'otherBlocks.hello',
      {
        title: '{{t("Hello block")}}',
        Component: HelloBlockInitializer,
      },
    );
  }
}
```

----------------------------------------

TITLE: Example of NocoBase Save Event Listeners
DESCRIPTION: This example demonstrates registering `beforeSave` and `afterSave` event listeners. These generic hooks are useful for applying logic that should run regardless of whether a record is being created or updated, providing a unified point for data manipulation or side effects.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_38

LANGUAGE: TypeScript
CODE:
```
db.on('beforeSave', async (model, options) => {
  // do something
});

db.on('books.afterSave', async (model, options) => {
  // do something
});
```

----------------------------------------

TITLE: Adding ACL Middleware with use() in TypeScript
DESCRIPTION: This snippet demonstrates how to add an ACL middleware function using the `acl.use()` method. The `use()` method accepts an asynchronous function that returns another asynchronous function, which serves as the actual middleware. This middleware function receives `ctx` (context) and `next` (next middleware function) as parameters, allowing for custom logic before calling `await next()` to proceed with the request chain. It's used to integrate custom access control logic into the NocoBase server.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/acl/acl.md#_snippet_8

LANGUAGE: typescript
CODE:
```
acl.use(async () => {
  return async function (ctx, next) {
    // ...
    await next();
  };
});
```

----------------------------------------

TITLE: Defining NocoBase Frontend UI Schema for Data Table with TypeScript
DESCRIPTION: This snippet defines the frontend UI schema for the `samplesEmailTemplates` collection, mirroring its backend structure. It specifies `subject` as an `input` field and `content` as a `richText` field, including `uiSchema` properties for rendering form components like `Input` and `RichText` with titles and required validation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
const emailTemplatesCollection = {
  name: 'samplesEmailTemplates',
  filterTargetKey: 'id',
  fields: [
    {
      type: 'string',
      name: 'subject',
      interface: 'input',
      uiSchema: {
        title: 'Subject',
        required: true,
        'x-component': 'Input',
      },
    },
    {
      type: 'text',
      name: 'content',
      interface: 'richText',
      uiSchema: {
        title: 'Content',
        required: true,
        'x-component': 'RichText',
      },
    },
  ],
};
```

----------------------------------------

TITLE: Defining Nested Components with `properties` in UI Schema (TSX)
DESCRIPTION: This schema illustrates how to define nested components using the `properties` field. A `div` component acts as a container, and an `input` component is nested within it, demonstrating the hierarchical structure of UI Schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/what-is-ui-schema.md#_snippet_3

LANGUAGE: TSX
CODE:
```
{
  type: 'void',
  'x-component': 'div',
  'x-component-props': { className: 'form-item' },
  properties: {
    title: {
      type: 'string',
      'x-component': 'input',
    },
  },
}
```

----------------------------------------

TITLE: Overriding Default Create Action in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to override the default `create` action for the 'orders' resource within a NocoBase plugin. It modifies the incoming parameters to automatically assign the `userId` from the currently logged-in user's state, ensuring server-side ownership determination, before calling the original `create` action.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';
import actions from '@nocobase/actions';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async create(ctx, next) {
          ctx.action.mergeParams({
            values: {
              userId: ctx.state.user.id,
            },
          });

          return actions.create(ctx, next);
        },
      },
    });
  }
}
```

----------------------------------------

TITLE: Nesting Array Schema with RecursionField for Primitives in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to handle nested `array` schemas where elements are primitive types (string or number) using `<RecursionField />` in NocoBase. The `ArrayList` component iterates over the array's values and renders each item using `RecursionField` with a dynamically retrieved schema for the `Value` component. This approach allows for custom rendering of array elements based on their defined schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/extending.md#_snippet_2

LANGUAGE: tsx
CODE:
```
import React from 'react';
import {
  useFieldSchema,
  Schema,
  RecursionField,
  useField,
  observer,
  connect,
} from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const useValueSchema = () => {
  const schema = useFieldSchema();
  return schema.reduceProperties((buf, s) => {
    if (s['x-component'] === 'Value') {
      return s;
    }
    return buf;
  });
};

const ArrayList = observer(
  (props) => {
    const field = useField();
    const schema = useValueSchema();
    return (
      <>
        String Array
        <ul>
          {field.value?.map((item, index) => {
            // 只有一个元素
            return <RecursionField name={index} schema={schema} />;
          })}
        </ul>
      </>
    );
  },
  { displayName: 'ArrayList' },
);

const Value = connect((props) => {
  return <li>value: {props.value}</li>;
});

const schema = {
  type: 'object',
  properties: {
    strArr: {
      type: 'array',
      default: [1, 2, 3],
      'x-component': 'ArrayList',
      properties: {
        value: {
          type: 'number',
          'x-component': 'Value',
        },
      },
    },
  },
};

export default () => {
  return (
    <SchemaComponentProvider components={{ ArrayList, Value }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Rendering Schema with Dynamic Properties and Components (TSX)
DESCRIPTION: This TSX snippet demonstrates how to render a UI Schema using `SchemaComponent`, providing the necessary `scope` for custom hooks like `useTableProps` and registering custom `components` like `MyTable`. This setup allows the schema to dynamically configure components and their properties at runtime.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/what-is-ui-schema.md#_snippet_14

LANGUAGE: tsx
CODE:
```
<SchemaComponent
  scope={{ useTableProps }}
  components={{ MyTable }}
  schema={{
    type: 'void',
    'x-component': 'MyTable',
    'x-use-component-props': 'useTableProps',
  }}
>
```

----------------------------------------

TITLE: Creating Associated Objects - HasManyRepository - TypeScript
DESCRIPTION: Creates new associated objects within the HasMany relationship. This method handles the persistence of new entities linked to the parent object.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/has-many-repository.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
async create(options?: CreateOptions): Promise<M>
```

----------------------------------------

TITLE: Registering Custom Field Types (TypeScript)
DESCRIPTION: This snippet illustrates how to register a custom field type, `MyField`, with the NocoBase database. The `registerFieldTypes` method accepts a map where keys are field type names and values are the corresponding field class definitions, extending `@nocobase/database/Field`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_11

LANGUAGE: ts
CODE:
```
import { Field } from '@nocobase/database';

class MyField extends Field {
  // ...
}

db.registerFieldTypes({
  myField: MyField,
});
```

----------------------------------------

TITLE: Defining Collections in NocoBase (TypeScript)
DESCRIPTION: This snippet illustrates how basic collections are defined in NocoBase. Each collection is identified by a unique 'name' property, serving as a fundamental organizational unit for different types of data like orders, products, or users.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/index.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
// Orders
{
  name: 'orders',
}
// Products
{
  name: 'products',
}
// Users
{
  name: 'users',
}
// Comments
{
  name: 'comments',
}
```

----------------------------------------

TITLE: Defining Collection Configuration (TypeScript)
DESCRIPTION: This snippet defines a 'books' collection with a 'title' field using a default export in a TypeScript file. This configuration is later imported into the NocoBase database system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'books',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
};
```

----------------------------------------

TITLE: Extending Existing Collections in NocoBase Plugin - TypeScript
DESCRIPTION: This snippet illustrates how to extend the options of an existing collection within a NocoBase plugin. Similar to defining new collections, this configuration is placed in `src/server/collections/*.ts` and synchronizes with the database when the plugin is activated or upgraded.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/configure.md#_snippet_1

LANGUAGE: ts
CODE:
```
import { extendCollection } from '@nocobase/database';

export default extendCollection({
  name: 'examples',
});
```

----------------------------------------

TITLE: Extending Orders Collection with Delivery Association (TypeScript)
DESCRIPTION: This snippet extends the 'orders' collection schema by adding a `hasOne` relationship to the 'delivery' collection. This association is crucial for linking order records with their corresponding shipping information, enabling custom actions like 'deliver'.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_11

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'orders',
  fields: [
    // ... . other fields
    {
      type: 'hasOne',
      name: 'delivery',
    },
  ],
};
```

----------------------------------------

TITLE: Defining `x-component` Property in TypeScript
DESCRIPTION: This TypeScript definition specifies the `x-component` property within the `ISchema` interface, which is used to declare the actual React component to be rendered for a given schema node.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/what-is-ui-schema.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
type Component = any;
interface ISchema {
  ['x-component']?: Component;
}
```

----------------------------------------

TITLE: Inserting Schema with useDesignable in React
DESCRIPTION: This React component demonstrates how to use the `useDesignable` hook from `@nocobase/client` to insert new schema nodes at various adjacent positions relative to the current component's schema. It provides interactive buttons that trigger insertions at `beforeBegin`, `afterBegin`, `beforeEnd`, and `afterEnd` using the `insertAdjacent` method, dynamically adding new 'Hello' components.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/designable.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import React from 'react';
import {
  SchemaComponentProvider,
  SchemaComponent,
  useDesignable,
} from '@nocobase/client';
import { observer, Schema, useFieldSchema } from '@formily/react';
import { Button, Space } from 'antd';
import { uid } from '@formily/shared';

const Hello = (props) => {
  const { insertAdjacent } = useDesignable();
  const fieldSchema = useFieldSchema();
  return (
    <div>
      <h1>
        {fieldSchema.title} - {fieldSchema.name}
      </h1>
      <Space>
        <Button
          onClick={() => {
            insertAdjacent('beforeBegin', {
              title: 'beforeBegin',
              'x-component': 'Hello',
            });
          }}
        >
          before begin
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('afterBegin', {
              title: 'afterBegin',
              'x-component': 'Hello',
            });
          }}
        >
          after begin
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('beforeEnd', {
              title: 'beforeEnd',
              'x-component': 'Hello',
            });
          }}
        >
          before end
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('afterEnd', {
              title: 'afterEnd',
              'x-component': 'Hello',
            });
          }}
        >
          after end
        </Button>
      </Space>
      <div style={{ margin: 50 }}>{props.children}</div>
    </div>
  );
};

const Page = (props) => {
  return <div>{props.children}</div>;
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Page, Hello }}>
      <SchemaComponent
        schema={{
          type: 'void',
          name: 'page',
          'x-component': 'Page',
          properties: {
            hello1: {
              type: 'void',
              title: 'Main',
              'x-component': 'Hello',
            },
          },
        }}
      />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Defining and Syncing Database Schema with NocoBase Collections - JavaScript
DESCRIPTION: This snippet illustrates how to define a database table structure using NocoBase's `Collection` API, specifying fields like 'name' and 'age'. It also shows how to synchronize the defined schema with the actual database using the `database.sync()` method.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_1

LANGUAGE: javascript
CODE:
```
// Define Collection
const UserCollection = database.collection({
  name: 'users',
  fields: [
    {
      name: 'name',
      type: 'string',
    },
    {
      name: 'age',
      type: 'integer',
    },
  ],
});
```

LANGUAGE: javascript
CODE:
```
await database.sync();
```

----------------------------------------

TITLE: Creating Global Plugin Settings Provider (React/TypeScript)
DESCRIPTION: This code establishes a React Context and Provider (`PluginSettingsFormProvider`) to enable global access to plugin settings data. It uses `useRequest` to fetch the data and makes it available to any component consuming the context, facilitating real-time updates.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/plugin-settings/form.md#_snippet_10

LANGUAGE: tsx
CODE:
```
import React, { createContext, FC } from 'react';
import { useRequest, UseRequestResult } from '@nocobase/client';

const PluginSettingsFormContext = createContext<UseRequestResult<{ data?: { key: string; secret: string } }>>(null as any);

export const PluginSettingsFormProvider: FC<{ children: React.ReactNode }> = ({children}) => {
  const request = useRequest<{ data?: { key: string; secret: string } }> ({
    url: 'SamplesMapConfiguration:get',
  });

  console.log('PluginSettingsFormProvider', request.data?.data);

  return <PluginSettingsFormContext.Provider value={request}>{children}</PluginSettingsFormContext.Provider>;
}

export const usePluginSettingsFormRequest = () => {
  return React.useContext(PluginSettingsFormContext);
};
```

----------------------------------------

TITLE: Implementing Color Modal Schema Setting for QRCode (TypeScript)
DESCRIPTION: This TypeScript code adds a `createModalSettingsItem` to the `qrCodeComponentFieldSettings` for configuring the `QRCode` component's color. It opens a modal with a `ColorPicker` component to select a string color value, which is stored under `x-component-props`. It depends on `createModalSettingsItem` from `@nocobase/client` and local `tStr` for localization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/value.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
export const qrCodeComponentFieldSettings = new SchemaSettings({
  name: 'fieldSettings:component:QRCode',
  items: [
    // ...
    createModalSettingsItem({
      name: 'color',
      title: tStr('Color'),
      parentSchemaKey: 'x-component-props',
      schema({ color }) {
        return {
          type: 'object',
          title: tStr('Color'),
          properties: {
            color: {
              type: 'string',
              title: tStr('Color'),
              default: color,
              'x-component': 'ColorPicker',
            }
          }
        }
      },
    }),
  ],
});
```

----------------------------------------

TITLE: Registering FormV3 Component and Admin Route in NocoBase Plugin (TSX)
DESCRIPTION: This snippet demonstrates how to register a custom `FormV3` component and add an administrative route (`/admin/block-form-component`) within a NocoBase client-side plugin. It uses `app.addComponents` to make `FormV3` available and `app.router.add` to define a new page that renders `FormV3` with a `SchemaComponent` containing a basic user form.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/block/block-form.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Plugin, SchemaComponent } from '@nocobase/client';
import { FormV3 } from './FormV3';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.addComponents({ FormV3 })

    this.app.router.add('admin.block-form-component', {
      path: '/admin/block-form-component',
      Component: () => {
        return <FormV3>
          <SchemaComponent schema={{
            type: 'void',
            properties: {
              username: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Username',
                required: true,
              },
              nickname: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Nickname',
              },
              password: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Password',
              },
              button: {
                type: 'void',
                'x-component': 'Action',
                title: 'Submit',
                'x-use-component-props': useSubmitActionProps,
              },
            }
          }} />
        </FormV3>
      }
    });
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Implementing Global Announcement Provider Component (TypeScript/TSX)
DESCRIPTION: This TypeScript/TSX snippet defines the `TopAnnouncement` React functional component. It uses Ant Design's `Alert` and `Affix` components, along with NocoBase's `useRequest` hook, to fetch and display a mock announcement message at the top of the page. It's designed to wrap `children` to ensure other content is rendered.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/provider/content.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import React, { FC, ReactNode } from 'react';
import { Alert, Affix, AlertProps } from 'antd';
import { useRequest } from '@nocobase/client';

const mockRequest = () => new Promise((resolve) => {
  Math.random() > 0.5 ?
    resolve({ data: { message: 'This is an important message.', type: 'info' } }) :
    resolve({ data: undefined })
})

export const TopAnnouncement: FC<{ children: ReactNode }> = ({ children }) => {
  const { data, loading } = useRequest<{ data: { message: string; type: AlertProps['type'] } }>(mockRequest)

  const onClose = () => {
    console.log('onClose')
  }

  return (
    <>
      {
        !loading && !!data.data && <Affix offsetTop={0} style={{ zIndex: 1010 }}>
          <Alert
            message={data.data.message}
            type={data.data.type}
            style={{ borderRadius: 0, borderLeft: 'none', borderRight: 'none' }}
            closable
            onClose={onClose}
          />
        </Affix>
      }
      {children}
    </>
  );
};
```

----------------------------------------

TITLE: Defining a Resource with Custom Action in NocoBase TypeScript
DESCRIPTION: This snippet demonstrates how to define a new resource named 'auth' using `app.resourceManager.define()`. It includes a custom 'check' action, which is an asynchronous handler that performs operations and then calls `next()` to proceed with the middleware chain. This method is crucial for setting up custom resource logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/resourcer/resource-manager.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
app.resourceManager.define({
  name: 'auth',
  actions: {
    check: async (ctx, next) => {
      // ...
      await next();
    }
  }
});
```

----------------------------------------

TITLE: AuthOptions Type Definition for Client-Side Registration in TypeScript
DESCRIPTION: This type definition outlines the structure for `AuthOptions` used when registering a client-side authentication type. It specifies the optional React components that can be provided for various authentication UI elements, such as sign-in, sign-up, and admin settings forms.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/api.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
export type AuthOptions = {
  components: Partial<{
    SignInForm: ComponentType<{ authenticator: AuthenticatorType }>;
    SignInButton: ComponentType<{ authenticator: AuthenticatorType }>;
    SignUpForm: ComponentType<{ authenticatorName: string }>;
    AdminSettingsForm: ComponentType;
  }>;
};
```

----------------------------------------

TITLE: Registering Server-Side Notification Channel Type in TypeScript
DESCRIPTION: This example demonstrates how to register a new server-side notification channel type, 'example-sms', using the `PluginNotificationManagerServer`. It shows extending the `Plugin` class and using `pm.get` to access the notification manager.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/notification-manager/development/api.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import PluginNotificationManagerServer from '@nocobase/plugin-notification-manager';
import { Plugin } from '@nocobase/server';
import { ExampleServer } from './example-server';
export class PluginNotificationExampleServer extends Plugin {
  async load() {
    const notificationServer = this.pm.get(PluginNotificationManagerServer) as PluginNotificationManagerServer;
    notificationServer.registerChannelType({ type: 'example-sms', Channel: ExampleServer });
  }
}

export default PluginNotificationExampleServer;
```

----------------------------------------

TITLE: Defining NocoBase useRequest() Hook Signature (TypeScript)
DESCRIPTION: This defines the signature for the `useRequest` hook, a NocoBase utility for asynchronous data management. It accepts a service configuration (Axios config, ResourceActionOptions, or a custom function) and optional hook options, providing flexibility for data fetching.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/api-client.md#_snippet_7

LANGUAGE: ts
CODE:
```
function useRequest<P>(
  service: AxiosRequestConfig<P> | ResourceActionOptions<P> | FunctionService,
  options?: Options<any, any>,
);
```

----------------------------------------

TITLE: Defining Double Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a 'double' type field named 'price' for a 'books' collection. This field stores double-precision floating-point numbers (64 bits), suitable for monetary values or other decimal numbers.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'double',
      name: 'price',
    },
  ],
});
```

----------------------------------------

TITLE: Defining and Using Field Interface Templates (TypeScript)
DESCRIPTION: This snippet introduces the 'Field Interface' concept as a templating mechanism to abstract and reuse common field configurations. It shows how to define 'email' and 'phone' interfaces, encapsulating their 'type' and 'uiSchema', and then how to simplify field declarations by referencing these interfaces, reducing redundancy.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/index.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
// Template for the email field
interface email {
  type: 'string';
  uiSchema: {
    'x-component': 'Input';
    'x-component-props': {};
    'x-validator': 'email';
  };
}

// Template for the phone field
interface phone {
  type: 'string';
  uiSchema: {
    'x-component': 'Input';
    'x-component-props': {};
    'x-validator': 'phone';
  };
}

// Simplified field configuration
// email
{
  interface: 'email',
  name: 'email',
}

// phone
{
  interface: 'phone',
  name: 'phone',
}
```

----------------------------------------

TITLE: Testing Server Application with mockServer() in TypeScript
DESCRIPTION: This example illustrates how to use `mockServer()` to create a mock NocoBase server instance for testing. It shows how to configure necessary plugins, supplement special handling logic, and provides a common `startApp` method for quick application setup and teardown using `app.quickstart()` and `app.destroy()`/`app.stop()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/test.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { MockServer, mockServer } from '@nocobase/test';

// Each plugin's minimal installation app is different, the necessary plugins need to be added according to their own conditions.
async function createApp(options: any = {}) {
  const app = mockServer({
    ...options,
    plugins: [
      'acl',
      'users',
      'collection-manager',
      'error-handler',
      ...options.plugins,
    ],
    // Other configuration parameters might also be present.
  });
  // Here, some logic that needs special handling can be supplemented, such as importing data tables needed for testing.
  return app;
}

// Most tests need to start the application, so a common startup method can also be provided.
async function startApp() {
  const app = createApp();
  await app.quickstart({
    // Before running tests, clear the database.
    clean: true,
  });
  return app;
}

describe('test example', () => {
  let app: MockServer;

  beforeEach(async () => {
    app = await startApp();
  });

  afterEach(async () => {
    // After running the tests, clear the database.
    await app.destroy();
    // Stop without clearing the database.
    await app.stop();
  });

  test('case1', async () => {
    // coding...
  });
});
```

----------------------------------------

TITLE: Integrate Custom Charts into Nocobase Plugin
DESCRIPTION: This snippet demonstrates how to integrate custom chart definitions, such as `ECharts` instances, into a Nocobase plugin. It shows the `beforeLoad` lifecycle hook where charts are registered with the `DataVisualizationPlugin`, making them available within the application. This process allows for extending the application's charting capabilities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/data-visualization/step-by-step/index.md#_snippet_8

LANGUAGE: typescript
CODE:
```
// client/index.ts
import DataVisualizationPlugin from '@nocobase/plugin-data-visualization/client';

export class PluginSampleAddCustomChartClient extends Plugin {
  async afterAdd() {
    // await this.app.pm.add()
  }

  async beforeLoad() {
    const plugin = this.app.pm.get(DataVisualizationPlugin);
    plugin.charts.addGroup('ECharts', [
      new ECharts(),
      // ...
      // ...
    ]);
  }

  // ここでアプリインスタンスを取得し、修正を行うことができます
  async load() {}
}
```

----------------------------------------

TITLE: Extend Schema Components: Responding to Data with observer
DESCRIPTION: This snippet demonstrates the use of `observer` from `@formily/react` to make components reactive to observable data changes, specifically form values. It contrasts an `observer`-wrapped component with a non-wrapped one to show how `observer` ensures the component re-renders when relevant form data changes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/client/ui-schema/extending.md#_snippet_2

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Input } from 'antd';
import { connect, observer, useForm } from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const SingleText = connect(Input);

const UsedObserver = observer(
  (props) => {
    const form = useForm();
    return <div>UsedObserver: {form.values.t1}</div>;
  },
  { displayName: 'UsedObserver' }
);

const NotUsedObserver = (props) => {
  const form = useForm();
  return <div>NotUsedObserver: {form.values.t1}</div>;
};

const schema = {
  type: 'object',
  properties: {
    t1: {
      type: 'string',
      'x-component': 'SingleText'
    },
    t2: {
      type: 'string',
      'x-component': 'UsedObserver'
    },
    t3: {
      type: 'string',
      'x-component': 'NotUsedObserver'
    }
  }
};

const components = {
  SingleText,
  UsedObserver,
  NotUsedObserver
};

export default () => {
  return (
    <SchemaComponentProvider components={components}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Registering Custom SMS Provider Configuration Form (Client-side, TypeScript)
DESCRIPTION: This snippet demonstrates how to register a custom SMS provider's configuration form on the client side. It defines a React component `CustomSMSProviderSettingsForm` using `SchemaComponent` to create input fields for `accessKeyId` and `accessKeySecret`. The `PluginCustomSMSProviderClient` then registers this form with the `smsOTPProviderManager` under the name 'custom-sms-provider-name', making it available in the SMS verifier configuration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/verification/sms/dev.md#_snippet_0

LANGUAGE: ts
CODE:
```
import { Plugin, SchemaComponent } from '@nocobase/client';
import PluginVerificationClient from '@nocobase/plugin-verification/client';
import React from 'react';

const CustomSMSProviderSettingsForm: React.FC = () => {
  return <SchemaComponent schema={{
    type: 'void',
    properties: {
      accessKeyId: {
        title: `{{t("Access Key ID", { ns: "${NAMESPACE}" })}`,
        type: 'string',
        'x-decorator': 'FormItem',
        'x-component': 'TextAreaWithGlobalScope',
        required: true,
      },
      accessKeySecret: {
        title: `{{t("Access Key Secret", { ns: "${NAMESPACE}" })}`,
        type: 'string',
        'x-decorator': 'FormItem',
        'x-component': 'TextAreaWithGlobalScope',
        'x-component-props': { password: true },
        required: true,
      },
    }
  }} />
}

class PluginCustomSMSProviderClient extends Plugin {
  async load() {
    const plugin = this.app.pm.get('verification') as PluginVerificationClient;
    plugin.smsOTPProviderManager.registerProvider('custom-sms-provider-name', {
      components: {
        AdminSettingsForm: CustomSMSProviderSettingsForm,
      },
    });
  }
}
```

----------------------------------------

TITLE: Registering Plugin Settings (New API - Multiple Tabs) - TSX
DESCRIPTION: This snippet illustrates the new approach for registering plugin configuration pages with multiple tabs. The main setting (`hello`) uses `Outlet` for routing, and each individual tab (`hello.tab1`, `hello.tab2`) is registered as a separate entry using dot notation with its respective component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0150-changelog.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { Outlet } from "react-router-dom";

class HelloPlugin extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add("hello", {
      title: "Hello",
      icon: "ApiOutlined",
      Component: Outlet,
    });

    this.app.pluginSettingsManager.add("hello.tab1", {
      title: "Hello tab1",
      Component: HelloPluginSettingPage1,
    });

    this.app.pluginSettingsManager.add("hello.tab2", {
      title: "Hello tab2",
      Component: HelloPluginSettingPage1,
    });
  }
}
```

----------------------------------------

TITLE: Defining Image Block Schema Initializer Item (TS)
DESCRIPTION: This snippet defines `imageInitializerItem`, a `SchemaInitializerItemType` that allows users to add the `imageSchema` block to a page. It specifies the item type, a unique name, an icon, and an `onClick` handler that uses `useSchemaInitializer` to insert the `imageSchema` when clicked.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-simple.md#_snippet_3

LANGUAGE: TS
CODE:
```
import { SchemaInitializerItemType, useSchemaInitializer } from '@nocobase/client';

import { useT } from '../locale';
import { imageSchema } from '../schema';
import { BlockName, BlockNameLowercase } from '../constants';

export const imageInitializerItem: SchemaInitializerItemType = {
  type: 'item',
  name: BlockNameLowercase,
  icon: 'FileImageOutlined',
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT()
    return {
      title: t(BlockName),
      onClick: () => {
        insert(imageSchema);
      },
    };
  },
}
```

----------------------------------------

TITLE: ResourceOptions and ActionType Interfaces for NocoBase ResourceManager (TypeScript)
DESCRIPTION: This snippet defines the TypeScript interfaces and types used for configuring resources and actions within NocoBase's `ResourceManager`. `ResourceOptions` specifies properties like `name`, `type`, and `actions`, while `ActionType` is a union of `HandlerType` (for direct middleware functions) and `ActionOptions` (for overriding request parameters). These types ensure strong typing for resource definitions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource-manager.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
export interface ResourceOptions {
  name: string;
  type?: ResourceType;
  actions?: {
    [key: string]: ActionType;
  };
  only?: Array<ActionName>;
  except?: Array<ActionName>;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
}

export type ResourceType =
  | 'single'
  | 'hasOne'
  | 'hasMany'
  | 'belongsTo'
  | 'belongsToMany';

export type ActionType = HandlerType | ActionOptions;
export type HandlerType = (
  ctx: ResourcerContext,
  next: () => Promise<any>,
) => any;
export interface ActionOptions {
  values?: any;
  fields?: string[];
  appends?: string[];
  except?: string[];
  whitelist?: string[];
  blacklist?: string[];
  filter?: FilterOptions;
  sort?: string[];
  page?: number;
  pageSize?: number;
  maxPageSize?: number;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
  handler?: HandlerType;
  [key: string]: any;
}
```

----------------------------------------

TITLE: Getting Data Repository for Related Tables (TypeScript)
DESCRIPTION: This example demonstrates how to obtain a data repository for a main table ('authors') and then for a related table ('authors.posts'), linking records using foreign key values. It shows creating an author and then a post associated with that author's ID.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_16

LANGUAGE: typescript
CODE:
```
const AuthorsRepo = db.getRepository('authors');
const author1 = AuthorsRepo.create({ name: 'author1' });

const PostsRepo = db.getRepository('authors.posts', author1.id);
const post1 = AuthorsRepo.create({ title: 'post1' });
asset(post1.authorId === author1.id); // true
```

----------------------------------------

TITLE: Defining FindOptions and findProperty Method in Designable (TypeScript)
DESCRIPTION: Defines the `FindOptions` interface for search criteria and the `findProperty` method signature. This method is used to find the *first* child node that meets the specified conditions, returning a single `Schema` object or `null`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/designable.md#_snippet_8

LANGUAGE: ts
CODE:
```
interface FindOptions {
  // Filter conditions
  filter: any;
  // Elements to skip during the search
  skipOn?: (s: Schema) => boolean;
  // Exit when finding a certain element
  breakOn?: (s: Schema) => boolean;
  // Recursive search
  recursive?: boolean;
}

class Designable {
  findProperty(options: FindOptions): Schema | null;
}
```

----------------------------------------

TITLE: Understanding x-decorator for Component Wrapping
DESCRIPTION: The `x-decorator` property allows combining two components into a single schema node, reducing schema complexity and enhancing component reusability. It is particularly useful for scenarios like wrapping form fields with `FormItem` or grouping blocks with `CardItem`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/client/ui-schema/what-is-ui-schema.md#_snippet_0

LANGUAGE: ts
CODE:
```
type Decorator = any;
interface ISchema {
  ['x-decorator']?: Decorator;
}
```

LANGUAGE: ts
CODE:
```
{
  type: 'void',
  ['x-component']: 'div',
  properties: {
    title: {
      type: 'string',
      'x-decorator': 'FormItem',
      'x-component': 'Input',
    },
    content: {
      type: 'string',
      'x-decorator': 'FormItem',
      'x-component': 'Input.TextArea',
    }
  }
}
```

LANGUAGE: tsx
CODE:
```
<div>
  <FormItem>
    <Input name={'title'} />
  </FormItem>
  <FormItem>
    <Input.TextArea name={'content'} />
  </FormItem>
</div>
```

LANGUAGE: ts
CODE:
```
{
  type: 'void',
  ['x-component']: 'div',
  properties: {
    table: {
      type: 'array',
      'x-decorator': 'CardItem',
      'x-component': 'Table',
    },
    kanban: {
      type: 'array',
      'x-decorator': 'CardItem',
      'x-component': 'Kanban',
    }
  }
}
```

LANGUAGE: tsx
CODE:
```
<div>
  <CardItem>
    <Table />
  </CardItem>
  <CardItem>
    <Kanban />
  </CardItem>
</div>
```

----------------------------------------

TITLE: Creating Multiple Records with Repository createMany() in TypeScript
DESCRIPTION: This snippet shows how to use the `createMany()` method to insert multiple new records into the database in a single operation. It also demonstrates handling related data for each record in the batch.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/repository.md#_snippet_11

LANGUAGE: ts
CODE:
```
const posts = db.getRepository('posts');

const results = await posts.createMany({
  records: [
    {
      title: 'NocoBase 1.0 发布日志',
      tags: [
        // 有关系表主键值时为更新该条数据
        { id: 1 },
        // 没有主键值时为创建新数据
        { name: 'NocoBase' },
      ],
    },
    {
      title: 'NocoBase 1.1 发布日志',
      tags: [{ id: 1 }],
    },
  ],
});
```

----------------------------------------

TITLE: Register Custom Block Component in NocoBase Client Plugin
DESCRIPTION: This TypeScript snippet demonstrates how to register a custom React component (`Info`) with the NocoBase client application. By extending `Plugin` and using `this.app.addComponents`, the `Info` component becomes available for use within the NocoBase UI schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-data.md#_snippet_4

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { Info } from './component';

export class PluginInitializerBlockDataClient extends Plugin {
  async load() {
    this.app.addComponents({ Info })
  }
}

export default PluginInitializerBlockDataClient;
```

----------------------------------------

TITLE: Handling Before/After Remove Collection Events (TypeScript)
DESCRIPTION: These synchronous events are triggered either before or after a data table (collection) is removed from memory, such as when `db.removeCollection()` is called. They provide hooks for cleanup or logging related to collection removal.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_37

LANGUAGE: TypeScript
CODE:
```
on(eventName: 'beforeRemoveCollection' | 'afterRemoveCollection', listener: RemoveCollectionListener): this
```

LANGUAGE: TypeScript
CODE:
```
import type { Collection } from '@nocobase/database';

export type RemoveCollectionListener = (options: Collection) => void;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeRemoveCollection', (collection) => {
  // do something
});

db.on('afterRemoveCollection', (collection) => {
  // do something
});
```

----------------------------------------

TITLE: NocoBase Authentication Flow (No Third-Party Callbacks)
DESCRIPTION: This section describes the authentication process when no third-party callbacks are required. The client uses the NocoBase SDK to call `api.auth.signIn()`, sending the authenticator ID via the `X-Authenticator` header. The `auth:signIn` interface then delegates to the corresponding authenticator's `validate` method, and the client receives user info and an authentication token.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/auth/dev/guide.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
1. Client calls `api.auth.signIn()` (or `auth:signIn` interface) using NocoBase SDK.\n   - Request header: `X-Authenticator` (current authenticator ID).\n2. `auth:signIn` interface delegates to the registered authenticator's `validate` method.\n3. Client receives user information and authentication token from `auth:signIn` response.\n4. Token is saved to local storage (handled by SDK).
```

----------------------------------------

TITLE: Example: Writing NocoBase Server-side Tests with Vitest
DESCRIPTION: This example demonstrates how to write server-side tests using `@nocobase/test/server` and Vitest. It shows mocking a database, defining a collection, creating a record, and asserting its properties.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/release/v0180-changelog.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { mockDatabase } from '@nocobase/test/server';

describe('my database test suite', () => {
  let db;

  beforeEach(async () => {
    db = mockDatabase();
    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });
    await db.sync();
  });

  afterEach(async () => {
    await db.close();
  });

  test('my test case', async () => {
    const repository = db.getRepository('posts');
    const post = await repository.create({
      values: {
        title: 'hello',
      },
    });

    expect(post.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Extending Plugin Class in TypeScript
DESCRIPTION: Demonstrates the basic way to create a NocoBase server-side plugin by extending the `Plugin` class from `@nocobase/server`. This establishes the foundation for a new plugin, inheriting its core functionalities and lifecycle management.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/server/plugin.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export class PluginDemoServer extends Plugin {}

export default PluginDemoServer;
```

----------------------------------------

TITLE: Extending an Existing Collection in NocoBase (TypeScript)
DESCRIPTION: This example demonstrates how to use `extend()` (an alias for `extendCollection()`) to add a new 'price' field of type 'number' to an existing 'books' collection. This method is crucial for modifying collection structures defined elsewhere, such as by plugins.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_23

LANGUAGE: TypeScript
CODE:
```
import { extend } from '@nocobase/database';

// Extend again
export default extend({
  name: 'books',
  fields: [{ name: 'price', type: 'number' }],
});
```

----------------------------------------

TITLE: Defining a NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a new data collection named 'posts' with a 'title' field using `app.db.collection()`. Synchronizing the database with `app.db.sync()` automatically creates corresponding data resources and built-in CRUD actions, making the collection accessible via NocoBase's HTTP API.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
app.db.collection({
  name: 'posts',
  fields: [{ type: 'string', name: 'title' }],
});

await app.db.sync();
```

----------------------------------------

TITLE: Using $eq Operator for Equality Check - TypeScript
DESCRIPTION: Illustrates the `$eq` operator to check if a field's value is exactly equal to a specified value. This operator is equivalent to SQL's `=` operator and is commonly used for precise matching.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/operators.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    title: {
      $eq: 'Spring and Autumn',
    },
  },
});
```

----------------------------------------

TITLE: Initializing NocoBase Application Instance (TypeScript)
DESCRIPTION: This snippet demonstrates how to create a new `Application` instance in TypeScript. It configures the `apiClient` with a base URL and provides a `dynamicImport` function for loading plugins, essential for setting up the application's core services.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/application.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const app = new Application({
  apiClient: {
    baseURL: process.env.API_BASE_URL,
  },
  dynamicImport: (name: string) => {
    return import(`../plugins/${name}`);
  }
});
```

----------------------------------------

TITLE: Rendering Application Component (TypeScript)
DESCRIPTION: This snippet shows how to initialize an `Application` instance and then render its main component. It imports `Application` from `@nocobase/client` and configures the API client and dynamic plugin import, finally exporting the rendered application for use.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/client/application.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { Application } from '@nocobase/client';

export const app = new Application({
  apiClient: {
    baseURL: process.env.API_BASE_URL,
  },
  dynamicImport: (name: string) => {
    return import(`../plugins/${name}`);
  }
});

export default app.render();
```

----------------------------------------

TITLE: Defining UI Schema Interface in TypeScript
DESCRIPTION: This TypeScript interface defines the structure of a UI Schema, outlining properties for component type, name, title, decorator, component, display state, content, child nodes, reactions, UI interaction mode, validation, default data, and designer-related initializers, settings, and toolbars. It serves as the foundational contract for describing frontend components.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/what-is-ui-schema.md#_snippet_0

LANGUAGE: typescript
CODE:
```
interface ISchema {
  type: 'void' | 'string' | 'number' | 'object' | 'array';
  name?: string;
  title?: any;
  // Decorator component
  ['x-decorator']?: string;
  // Decorator component properties
  ['x-decorator-props']?: any;
  // Dynamic decorator component properties
  ['x-use-decorator-props']?: any;
  // Component
  ['x-component']?: string;
  // Component properties
  ['x-component-props']?: any;
  // Dynamic component properties
  ['x-use-component-props']?: any;
  // Display state, default is 'visible'
  ['x-display']?: 'none' | 'hidden' | 'visible';
  // Component's child nodes, simple usage
  ['x-content']?: any;
  // children node schema
  properties?: Record<string, ISchema>;

  // Below are only used for field components

  // Field reactions
  ['x-reactions']?: SchemaReactions;
  // Field UI interaction mode, default is 'editable'
  ['x-pattern']?: 'editable' | 'disabled' | 'readPretty';
  // Field validation
  ['x-validator']?: Validator;
  // Default data
  default?: any;

  // For designer related

  // Initializer, determines what can be inserted adjacent to the current schema
  ['x-initializer']?: string;
  ['x-initializer-props']?: any;

  // Block settings, determines what parameters can be configured for the current schema
  ['x-settings']?: string;
  ['x-settings-props']?: any;

  // Toolbar component
  ['x-toolbar']?: string;
  ['x-toolbar-props']?: any;
}
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Update Events (TypeScript)
DESCRIPTION: These events are triggered before and after data updates. They are invoked when `repository.update()` is called. Use these hooks to perform actions or modify data during the update process, such as auditing changes or validating new values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_16

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.beforeUpdate` | 'beforeUpdate' | `${string}.afterUpdate` | 'afterUpdate', listener: UpdateListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { UpdateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type UpdateListener = (
  model: Model,
  options?: UpdateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeUpdate', async (model, options) => {
  // 何かを行う
});

db.on('books.afterUpdate', async (model, options) => {
  // 何かを行う
});
```

----------------------------------------

TITLE: Initializing AuthManager and Registering Basic Auth (TypeScript)
DESCRIPTION: This snippet demonstrates the basic setup of `AuthManager`. It initializes the manager, configures a method to retrieve authenticators from a database repository, and registers a 'basic' authentication type using `BasicAuth`. Finally, it integrates the `AuthManager` as a middleware into the application's resource manager.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/auth/auth-manager.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const authManager = new AuthManager({
  // 用于从请求头中获取当前认证器标识
  authKey: 'X-Authenticator',
});

// 设置 AuthManager 的存储和获取认证器的方法
authManager.setStorer({
  get: async (name: string) => {
    return db.getRepository('authenticators').find({ filter: { name } });
  },
});

// 注册一种认证类型
authManager.registerTypes('basic', {
  auth: BasicAuth,
  title: 'Password',
});

// 使用鉴权中间件
app.resourceManager.use(authManager.middleware());
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Save Events (TypeScript)
DESCRIPTION: These events are triggered before and after data is saved (created or updated). They are invoked when `repository.create()` or `repository.update()` is called. Use these hooks for operations that apply to both creation and update scenarios.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_17

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.beforeSave` | 'beforeSave' | `${string}.afterSave` | 'afterSave', listener: SaveListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { SaveOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type SaveListener = (model: Model, options?: SaveOptions) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeSave', async (model, options) => {
  // 何かを行う
});

db.on('books.afterSave', async (model, options) => {
  // 何かを行う
});
```

----------------------------------------

TITLE: Complete NocoBase Router Application Example (TypeScript)
DESCRIPTION: This comprehensive example demonstrates a full NocoBase application setup with router initialization and nested route definitions. It includes React components for layout and pages, showing how `Link` and `Outlet` from `react-router-dom` are used within the NocoBase routing context. The router is configured with 'memory' type for demonstration purposes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/router.md#_snippet_7

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { Link, Outlet } from 'react-router-dom';
import { Application } from '@nocobase/client';

const Home = () => <h1>Home</h1>;
const About = () => <h1>About</h1>;

const Layout = () => {
  return (
    <div>
      <div>
        <Link to={'/'}>Home</Link>, <Link to={'/about'}>About</Link>
      </div>
      <Outlet />
    </div>
  );
};

const app = new Application({
  router: {
    type: 'memory',
    initialEntries: ['/'],
  },
});

app.router.add('root', {
  element: <Layout />,
});

app.router.add('root.home', {
  path: '/',
  element: <Home />,
});

app.router.add('root.about', {
  path: '/about',
  element: <About />,
});

export default app.getRootComponent();
```

----------------------------------------

TITLE: ResourceManager define() API Reference
DESCRIPTION: This section provides the API documentation for the `define()` method, including its signature and the TypeScript interfaces `ResourceOptions`, `ResourceType`, `ActionType`, `HandlerType`, and `ActionOptions`. It details the structure and available properties for defining resources and their actions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/resourcer/resource-manager.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Signature:
- define(options: ResourceOptions): Resource

Types:
export interface ResourceOptions {
  name: string;
  type?: ResourceType;
  actions?: {
    [key: string]: ActionType;
  };
  only?: Array<ActionName>;
  except?: Array<ActionName>;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
}

export type ResourceType =
  | 'single'
  | 'hasOne'
  | 'hasMany'
  | 'belongsTo'
  | 'belongsToMany';

export type ActionType = HandlerType | ActionOptions;
export type HandlerType = (
  ctx: ResourcerContext,
  next: () => Promise<any>,
) => any;
export interface ActionOptions {
  values?: any;
  fields?: string[];
  appends?: string[];
  except?: string[];
  whitelist?: string[];
  blacklist?: string[];
  filter?: FilterOptions;
  sort?: string[];
  page?: number;
  pageSize?: number;
  maxPageSize?: number;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
  handler?: HandlerType;
  [key: string]: any;
}
```

----------------------------------------

TITLE: NocoBase API: useSchemaInitializer Hook
DESCRIPTION: A React hook that provides methods for interacting with the Schema Initializer context, primarily used to insert new schemas into the UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data.md#_snippet_16

LANGUAGE: APIDOC
CODE:
```
{
  "name": "useSchemaInitializer",
  "type": "React Hook",
  "description": "Provides methods to insert a Schema.",
  "methods": [
    {"name
```

----------------------------------------

TITLE: Extending NocoBase Users Table with Orders Relationship (TypeScript)
DESCRIPTION: This code demonstrates extending the built-in `users` data table in NocoBase to add a `hasMany` relationship to `orders`. Using the `@nocobase/database` `extend()` method, it non-invasively adds an `orders` association field, enabling retrieval of all orders associated with a specific user.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
import { extend } from '@nocobase/database';

export extend({
  name: 'users',
  fields: [
    {
      type: 'hasMany',
      name: 'orders'
    }
  ]
});
```

----------------------------------------

TITLE: Adding BelongsTo Relationship Field to Products Collection (TypeScript)
DESCRIPTION: This snippet modifies the `products` collection definition to include a `belongsTo` field named `category`. The `target` property points to the `categories` table, establishing a many-to-one relationship. This field, combined with a `hasMany` field on the `categories` table, enables products to be associated with a specific category.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
{
  name: 'products',
  fields: [
    // ...
    {
      type: 'belongsTo',
      name: 'category',
      target: 'categories',
    }
  ]
}
```

----------------------------------------

TITLE: Controlling Output Fields in NocoBase Repository Queries
DESCRIPTION: Demonstrates how to manage the fields returned by a `Repository` query using `fields`, `except`, and `appends` parameters. It shows examples of selecting specific fields, excluding fields, and appending associated data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_3

LANGUAGE: javascript
CODE:
```
// The result contains only the id and name fields
userRepository.find({
  fields: ['id', 'name'],
});

// The result does not contain only the password field
userRepository.find({
  except: ['password'],
});

// The result contains data associated with the posts object
userRepository.find({
  appends: ['posts'],
});
```

----------------------------------------

TITLE: Registering Delete Action Hook in NocoBase Schema (TypeScript)
DESCRIPTION: This code diff shows how to register the `useDeleteActionProps` hook into the `scope` prop of the `SchemaComponent`. This makes the custom action hook available for use within the NocoBase schema, enabling the delete functionality for table records.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_19

LANGUAGE: TypeScript
CODE:
```
export const PluginSettingsTable = () => {
  return (
    <ExtendCollectionsProvider collections={[emailTemplatesCollection]}>
-     <SchemaComponent schema={schema} scope={{ useSubmitActionProps, useEditFormProps }} />
+     <SchemaComponent schema={schema} scope={{ useSubmitActionProps, useEditFormProps, useDeleteActionProps }} />
    </ExtendCollectionsProvider>
  );
};
```

----------------------------------------

TITLE: Implementing a Custom Pie Chart Class (TypeScript)
DESCRIPTION: This snippet defines a custom `Pie` chart class, extending `ECharts` to provide specialized configuration for pie charts. It customizes the `config` for `angleField` and `colorField`, implements an `init` method for inferring fields, and overrides `getProps` to configure dataset, legend, tooltip, and series specific to pie chart rendering.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/data-visualization/step-by-step/index.md#_snippet_10

LANGUAGE: TypeScript
CODE:
```
export class Pie extends ECharts {
  constructor() {
    super({
      name: 'pie',
      title: 'Pie Chart',
      series: { type: 'pie' }
    });
    this.config = [
      {
        property: 'field',
        name: 'angleField',
        title: 'angleField',
        required: true
      },
      {
        property: 'field',
        name: 'colorField',
        title: 'colorField',
        required: true
      }
    ];
  }

  init: ChartType['init'] = (fields, { measures, dimensions }) => {
    const { xField, yField } = this.infer(fields, { measures, dimensions });
    return {
      general: {
        colorField: xField?.value,
        angleField: yField?.value
      }
    };
  };

  getProps({ data, general, advanced, fieldProps }: RenderProps) {
    return deepmerge(
      {
        legend: {},
        tooltip: {},
        dataset: [
          {
            dimensions: [general.colorField, general.angleField],
            source: data
          },
          {
            transform: {
              type: 'data-visualization:transform',
              config: { fieldProps }
            }
          }
        ],
        series: {
          name: fieldProps[general.angleField]?.label,
          datasetIndex: 1,
          ...this.series
        }
      },
      advanced
    );
  }
}

new Pie();
```

----------------------------------------

TITLE: Registering and Routing FormV3 Component in NocoBase Client (TypeScript)
DESCRIPTION: This snippet demonstrates how to register a custom `FormV3` component with the NocoBase client application and set up a dedicated route for it. It shows how to add the component to the application's component registry and define a new route that renders the `FormV3` component containing a `SchemaComponent` with a predefined UI schema for user input fields (username, nickname, password) and a submit button. This allows for temporary page validation of the component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/block/block-form.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Plugin, SchemaComponent } from '@nocobase/client';
import { FormV3 } from './FormV3';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.addComponents({ FormV3 })

    this.app.router.add('admin.block-form-component', {
      path: '/admin/block-form-component',
      Component: () => {
        return <FormV3>
          <SchemaComponent schema={{
            type: 'void',
            properties: {
              username: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Username',
                required: true,
              },
              nickname: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Nickname',
              },
              password: {
                type: 'string',
                'x-decorator': 'FormItem',
                'x-component': 'Input',
                title: 'Password',
              },
              button: {
                type: 'void',
                'x-component': 'Action',
                title: 'Submit',
                'x-use-component-props': useSubmitActionProps,
              },
            }
          }} />
        </FormV3>
      }
    });
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Register QRCode Component in NocoBase Plugin
DESCRIPTION: This TypeScript snippet shows how to register the custom 'QRCode' component with the NocoBase client application. By adding it to 'this.app.addComponents', the component becomes available for use within NocoBase schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/field/value.md#_snippet_5

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/client';

import { QRCode } from './QRCode';

export class PluginFieldComponentValueClient extends Plugin {
  async load() {
    this.app.addComponents({ QRCode });
  }
}

export default PluginFieldComponentValueClient;
```

----------------------------------------

TITLE: Creating Associated Objects with HasOneRepository.create() in TypeScript
DESCRIPTION: This snippet illustrates how to use the `create()` method to create a new associated object for the `HasOne` relationship. It takes `values` as an option and returns the newly created model, including the foreign key (`userId`).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/has-one-repository.md#_snippet_2

LANGUAGE: typescript
CODE:
```
const profile = await UserProfileRepository.create({
  values: { avatar: 'avatar1' }
});

console.log(profile.toJSON());
/*
{
  id: 1,
  avatar: 'avatar1',
  userId: 1,
  updatedAt: 2022-09-24T13:59:40.025Z,
  createdAt: 2022-09-24T13:59:40.025Z
}
*/
```

----------------------------------------

TITLE: Extending BaseAuth for Custom Authentication with User Collection (JavaScript)
DESCRIPTION: This example illustrates how to extend the `BaseAuth` class from `@nocobase/auth` to simplify custom authentication development. It shows how to initialize the `userCollection` in the constructor, allowing the custom authenticator to interact with the 'users' table. The `validate()` method is where the specific user login logic should be implemented, leveraging the base class's existing JWT authentication capabilities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/guide.md#_snippet_1

LANGUAGE: javascript
CODE:
```
import { BaseAuth } from '@nocobase/auth';

class CustomAuth extends BaseAuth {
  constructor(config: AuthConfig) {
    // Set user data table
    const userCollection = config.ctx.db.getCollection('users');
    super({ ...config, userCollection });
  }

  // Implement user login logic
  async validate() {}
}
```

----------------------------------------

TITLE: Defining Many-to-One Association with belongsTo (TypeScript)
DESCRIPTION: This example illustrates the 'belongsTo' association type, establishing a many-to-one relationship where a post belongs to an author. The foreign key ('authorId') is stored in the 'posts' table, linking to the 'users' table. It shows how to explicitly define target, foreignKey, and sourceKey.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_13

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'belongsTo',
      name: 'author',
      target: 'users', // Default table name is the plural form of <name>
      foreignKey: 'authorId', // Default is '<name> + Id'
      sourceKey: 'id' // Default is id of the <target> table
    }
  ]
});
```

----------------------------------------

TITLE: Updating Order Status on Delivery Creation (TypeScript)
DESCRIPTION: This snippet demonstrates how to update an order's status to 'shipped' (status: 2) immediately after a delivery record is created. It leverages the `deliveries.afterCreate` database event. The event handler retrieves the `orders` repository and updates the specific order associated with the delivery, ensuring the status change occurs within the same transaction as the delivery creation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/events.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class ShopPlugin extends Plugin {
  load() {
    this.db.on('deliveries.afterCreate', async (delivery, options) => {
      const orderRepo = this.db.getRepository('orders');
      await orderRepo.update({
        filterByTk: delivery.orderId,
        value: {
          status: 2
        },
        transaction: options.transaction
      });
    });
  }
}
```

----------------------------------------

TITLE: Example File Upload Request with Presigned URL
DESCRIPTION: This snippet provides a concrete example of using the 'curl' command to upload a file to a presigned URL. It demonstrates how to specify the 'putUrl' obtained from the server and the local path to the file being uploaded, ensuring the file is sent directly to the S3-compatible storage.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/file-manager/http-api.md#_snippet_9

LANGUAGE: Shell
CODE:
```
curl 'https://xxxxxxx' \
  -X 'PUT' \
  -T /Users/Downloads/a.png
```

----------------------------------------

TITLE: Creating Association - HTTP API
DESCRIPTION: This snippet demonstrates how to create a new association for a specific collection using the NocoBase HTTP API. It requires a POST request to `/api/<collection>/<collectionIndex>/<association>:create` with an empty JSON body.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions-v2/rest-api.md#_snippet_10

LANGUAGE: bash
CODE:
```
POST    /api/<collection>/<collectionIndex>/<association>:create

{} # JSON body
```

----------------------------------------

TITLE: Setting Application Version for Migration - TypeScript
DESCRIPTION: This snippet demonstrates how to set the `appVersion` property within a NocoBase Migration class. The migration script will only execute if the current application version matches the specified version, ensuring version-specific upgrades.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/server/migration.md#_snippet_0

LANGUAGE: typescript
CODE:
```
export default class extends Migration {
  appVersion = '<=1.0.0-alpha.1';
  // ...
}
```

----------------------------------------

TITLE: Finding Associated Object with HasOneRepository.find() - TypeScript
DESCRIPTION: This example demonstrates using the `find()` method of `UserProfileRepository` to retrieve the associated profile object. If no associated object exists, the method returns `null`. It supports various query options similar to `Repository.find()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/relation-repository/has-one-repository.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
const profile = await UserProfileRepository.find();
// 关联对象不存在时，返回 null
```

----------------------------------------

TITLE: Creating Associated Objects with HasManyRepository (TypeScript)
DESCRIPTION: This method creates new associated objects within the HasMany relationship. It accepts `CreateOptions` and returns a Promise resolving to the newly created model instance.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/has-many-repository.md#_snippet_4

LANGUAGE: typescript
CODE:
```
async create(options?: CreateOptions): Promise<M>
```

----------------------------------------

TITLE: Defining PrimaryKeyWithThroughValues and AssociatedOptions Interfaces for Add Method in TypeScript
DESCRIPTION: Defines `PrimaryKeyWithThroughValues` as a tuple for target key and intermediate table values, and `AssociatedOptions` for the `add()` method, allowing single or multiple target keys with optional intermediate table values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/belongs-to-many-repository.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
type PrimaryKeyWithThroughValues = [TargetKey, Values];

interface AssociatedOptions extends Transactionable {
  tk?:
    | TargetKey
    | TargetKey[]
    | PrimaryKeyWithThroughValues
    | PrimaryKeyWithThroughValues[];
}
```

----------------------------------------

TITLE: NocoBase OIDC/OAuth Redirect URL Configuration
DESCRIPTION: Defines the redirect URLs required for NocoBase's OIDC/OAuth integration, including the primary callback URL and the post-logout redirect URL for RP-initiated logout.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth-oidc/index.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
{
  "type": "object",
  "properties": {
    "Redirect URL": {
      "type": "string",
      "description": "Used to configure the callback URL in the IdP."
    },
    "Post logout redirect URL": {
      "type": "string",
      "description": "Used to configure the Post logout redirect URL in the IdP when RP-initiated logout is enabled."
    }
  }
}
```

----------------------------------------

TITLE: NocoBase CLI: Synchronizing Database Collections (`db:sync`)
DESCRIPTION: The `db:sync` command generates data sheets and fields based on the defined collections configuration. It ensures that the database schema aligns with the application's collection definitions, with an option to force synchronization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/cli.md#_snippet_13

LANGUAGE: APIDOC
CODE:
```
$ yarn nocobase db:sync -h

Usage: nocobase db:sync [options]

Options:
  -f, --force
  -h, --help   display help for command
```

----------------------------------------

TITLE: Configuring Nginx Load Balancer for NocoBase Cluster
DESCRIPTION: This Nginx configuration sets up a load balancer for a NocoBase application cluster. It defines an `upstream` block named `myapp` to list backend NocoBase instances and a `server` block to listen on port 80, proxying incoming requests to the `myapp` upstream. This distributes client requests across multiple NocoBase nodes, improving concurrency and availability.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/getting-started/deployment/cluster-mode.md#_snippet_0

LANGUAGE: nginx
CODE:
```
upstream myapp {
    # ip_hash; # Can be used for session persistence, once enabled, requests from the same client will always be sent to the same backend server.
    server 172.31.0.1:13000; # Internal node 1
    server 172.31.0.2:13000; # Internal node 2
    server 172.31.0.3:13000; # Internal node 3
}

server {
    listen 80;

    location / {
        # Use the defined upstream for load balancing
        proxy_pass http://myapp;
        # ... other configurations
    }
}
```

----------------------------------------

TITLE: Registering Custom Repository Class (TypeScript)
DESCRIPTION: This snippet illustrates registering a custom data repository class, `MyRepository`, with the NocoBase database. It also demonstrates how to associate this custom repository with a collection named 'myCollection' using the `repository` property.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_13

LANGUAGE: TypeScript
CODE:
```
import { Repository } from '@nocobase/database';

class MyRepository extends Repository {
  // ...
}

db.registerRepositories({
  myRepository: MyRepository,
});

db.collection({
  name: 'myCollection',
  repository: 'myRepository',
});
```

----------------------------------------

TITLE: Customizing a Specific Resource Action (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to override the default 'create' action for the 'posts' resource. By using `app.actions()`, it customizes the creation logic to automatically set the `userId` of the new post to the `currentUserId` from the request context, ensuring that users can only create posts for themselves.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_2

LANGUAGE: ts
CODE:
```
// Equivalent to app.resourcer.registerActions()
// Register the create action method for article resources
app.actions({
  async ['posts:create'](ctx, next) {
    const postRepo = ctx.db.getRepository('posts');
    await postRepo.create({
      values: {
        ... . ctx.action.params.values,
        // restrict the current user to be the creator of the post
        userId: ctx.state.currentUserId
      }
    });

    await next();
  }
});
```

----------------------------------------

TITLE: Managing Routes within a NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet shows how to interact with the NocoBase router within a custom plugin. Plugins can add new routes or remove existing ones during their `load` lifecycle method, allowing plugins to extend or modify the application's routing behavior dynamically. This is crucial for modular application development.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/router.md#_snippet_6

LANGUAGE: tsx
CODE:
```
class MyPlugin extends Plugin {
  async load() {
    // add route
    this.app.router.add('hello', {
      path: '/hello',
      element: <div>hello</div>,
    });

    // remove route
    this.app.router.remove('world');
  }
}
```

----------------------------------------

TITLE: Configuring Email Field with uiSchema (TSX)
DESCRIPTION: This snippet shows how to configure an email field using 'uiSchema' to control its display and validation. It specifies the 'Input' component, component properties like 'size', validation rules ('email'), and interaction patterns ('editable'). An example of corresponding data and the React component usage is also provided.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/index.md#_snippet_2

LANGUAGE: TSX
CODE:
```
// Email field, displayed with Input component, using email validation rules
{
  type: 'string',
  name: 'email',
  uiSchema: {
    'x-component': 'Input',
    'x-component-props': { size: 'large' },
    'x-validator': 'email',
    'x-pattern': 'editable', // editable state, and readonly state, read-pretty state
  },
}

// Example data
{
  email: 'admin@nocobase.com',
}

// Component example
<Input name={'email'} size={'large'} value={'admin@nocobase.com'} />
```

----------------------------------------

TITLE: Implementing Custom Deliver Action for Orders in NocoBase (TypeScript)
DESCRIPTION: This snippet defines a custom `deliver` action for the 'orders' resource within a NocoBase plugin. It updates an order's status to 'shipped' (2) and creates/updates an associated delivery record with its initial status (0), based on provided parameters. This action encapsulates the complex logic of order shipping, improving semantic clarity over a generic `update` action.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_12

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    // ...
    this.app.resource({
      name: 'orders',
      actions: {
        async deliver(ctx, next) {
          const { filterByTk } = ctx.action.params;
          const orderRepo = ctx.db.getRepository('orders');

          const [order] = await orderRepo.update({
            filterByTk,
            values: {
              status: 2,
              delivery: {
                ... . ctx.action.params.values,
                status: 0
              status: 0 }
            }
          });

          ctx.body = order;

          next();
        }
      }
    });
  }
}
```

----------------------------------------

TITLE: Synchronizing Collection Definitions to Database in TypeScript
DESCRIPTION: This snippet shows how to synchronize a collection's definition with the underlying database schema. It initializes a 'posts' collection and then calls `sync()` to apply any schema changes or create the table if it doesn't exist. This method extends Sequelize's `Model.sync` to also handle relational fields.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/collection.md#_snippet_13

LANGUAGE: typescript
CODE:
```
const posts = db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});

await posts.sync();
```

----------------------------------------

TITLE: Nocobase: Synchronize Collection Definition with Database
DESCRIPTION: This method synchronizes the datasheet's definition with the underlying database. It extends Sequelize's default `Model.sync` logic to also handle datasheets corresponding to related fields. The method returns a Promise that resolves to void.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/collection.md#_snippet_12

LANGUAGE: APIDOC
CODE:
```
Method: sync
Signature: sync(): Promise<void>
```

LANGUAGE: typescript
CODE:
```
const posts = db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title'
    }
  ]
});

await posts.sync();
```

----------------------------------------

TITLE: Extending an Existing NocoBase Collection (TypeScript)
DESCRIPTION: This code demonstrates how to extend an existing NocoBase collection, specifically the 'users' collection, by adding a new 'hasMany' relationship field named 'orders'. This allows users to have multiple associated orders without modifying the original 'users' collection definition directly, promoting modularity.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
import { extend } from '@nocobase/database';

export extend({
  name: 'users',
  fields: [
    {
      type: 'hasMany',
      name: 'orders'
    }
  ]
});
```

----------------------------------------

TITLE: Extending NocoBase Chart Class for ECharts (TypeScript)
DESCRIPTION: This TypeScript snippet defines an `ECharts` class that extends NocoBase's base `Chart` class. It introduces a `series` parameter in the constructor, specific to ECharts configuration, and sets default `xField`, `yField`, and `seriesField` for common chart types, integrating the previously defined `ReactECharts` component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/data-visualization/step-by-step/index.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { Chart } from '@nocobase/plugin-data-visualization/client';

export class ECharts extends Chart {
  constructor({
    name,
    title,
    series,
    config,
  }: {
    name: string;
    title: string;
    series: any;
    config?: ChartProps['config'];
  }) {
    super({
      name,
      title,
      component: ReactECharts,
      config: ['xField', 'yField', 'seriesField', ...(config || [])],
    });
    this.series = series;
  }
}
```

----------------------------------------

TITLE: Accessing Custom Options in SyncSource in TypeScript
DESCRIPTION: This snippet illustrates how to access custom configuration options for a data source through the `this.options` property within the `SyncSource` class. It shows an example of destructuring `appid` and `secret` from the options.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/user-data-sync/dev/source.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import { SyncSource, UserData } from '@nocobase/plugin-user-data-sync';

class CustomSyncSource extends SyncSource {
  async pull(): Promise<UserData[]> {
    //...
    const { appid, secret } = this.options;
    //...
    return [];
  }
}
```

----------------------------------------

TITLE: Creating a NocoBase Page with mockPage (TypeScript)
DESCRIPTION: This snippet demonstrates how to create a temporary NocoBase page using `mockPage`. The generated page is automatically destroyed after the current test case completes, making it suitable for isolated tests. It navigates to the newly created page using `nocoPage.goto()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/test/e2e.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { test } from '@nocobase/test/e2e';

test('learn how to use mockPage', async ({ mockPage }) => {
  const nocoPage = await mockPage();
  await nocoPage.goto();
});
```

----------------------------------------

TITLE: Registering a Custom Workflow Trigger - TypeScript
DESCRIPTION: Demonstrates how to register a custom trigger type (`MyTrigger`) with the `PluginWorkflowServer`. It shows how to define a trigger class that listens for events (e.g., `process.on('message')`) and uses `this.workflow.trigger()` to activate a workflow, along with `on` and `off` methods for lifecycle management. This allows custom events to initiate workflow executions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow/development/api.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import PluginWorkflowServer, { Trigger } from '@nocobase/plugin-workflow';

function handler(this: MyTrigger, workflow: WorkflowModel, message: string) {
  // trigger workflow
  this.workflow.trigger(workflow, { data: message.data });
}

class MyTrigger extends Trigger {
  messageHandlers: Map<number, WorkflowModel> = new Map();
  on(workflow: WorkflowModel) {
    const messageHandler = handler.bind(this, workflow);
    // listen for some event to trigger workflow
    process.on(
      'message',
      this.messageHandlers.set(workflow.id, messageHandler),
    );
  }

  off(workflow: WorkflowModel) {
    const messageHandler = this.messageHandlers.get(workflow.id);
    // remove listener
    process.off('message', messageHandler);
  }
}

export default class MyPlugin extends Plugin {
  load() {
    // get workflow plugin instance
    const workflowPlugin =
      this.app.pm.get<PluginWorkflowServer>(PluginWorkflowServer);

    // register trigger
    workflowPlugin.registerTrigger('myTrigger', MyTrigger);
  }
}
```

----------------------------------------

TITLE: Register NocoBase FormV3 Block Component via Plugin
DESCRIPTION: This TypeScript snippet registers the `FormV3` component with the NocoBase application's component registry through a client-side plugin. This crucial step makes the `FormV3` block available for use within the NocoBase UI, allowing it to be rendered and configured by users.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { FormV3 } from './FormV3';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.addComponents({ FormV3 });
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Integrating NocoBase Client-Side Plugins with React
DESCRIPTION: This snippet illustrates how to integrate client-side plugin functionality into a NocoBase application using React. It demonstrates initializing the client `Application`, configuring dynamic imports for plugins, and using a `React.memo` component (`HelloProvider`) as a context provider or middleware to render specific UI based on the current route, such as displaying 'Hello world!' on the `/hello` page. Note that `useLocation` would typically be imported from a routing library like `react-router-dom`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0080-changelog.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import React from 'react';
import { Application } from '@nocobase/client';

const app = new Application({
  apiClient: {
    baseURL: process.env.API_BASE_URL,
  },
  dynamicImport: (name: string) => {
    return import(`../plugins/${name}`);
  },
});

// When you visit the /hello page, it displays Hello world!
const HelloProvider = React.memo((props) => {
  const location = useLocation();
  if (location.pathname === '/hello') {
    return <div>Hello world!</div>
  }
  return <>{props.children}</>
});
HelloProvider.displayName = 'HelloProvider'

app.use(HelloProvider);
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin - NocoBase Client (TS)
DESCRIPTION: This snippet shows how to register the previously defined `documentActionSettings` with the NocoBase application's `schemaSettingsManager`. By calling `this.app.schemaSettingsManager.add(documentActionSettings);` within the plugin's `load` method, the settings become available for use across the application, enabling features like component removal.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/action-simple.md#_snippet_9

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/client';
import { useDocumentActionProps } from './schema';
import { documentActionSettings } from './settings';

export class PluginInitializerActionSimpleClient extends Plugin {
  async load() {
    this.app.addScopes({ useDocumentActionProps });
    this.app.schemaSettingsManager.add(documentActionSettings);
  }
}

export default PluginInitializerActionSimpleClient;
```

----------------------------------------

TITLE: NocoBase Client API: SchemaSettingsManager.add
DESCRIPTION: The 'add' method of 'SchemaSettingsManager' is used to register a set of schema settings with the NocoBase application. This makes the defined settings available for use with UI components and ensures they can be properly managed and rendered within the system. It takes a 'SchemaSettings' object as input.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-simple.md#_snippet_15

LANGUAGE: APIDOC
CODE:
```
{
  "method": "add",
  "class": "SchemaSettingsManager",
  "signature": "add(settings: SchemaSettings): void",
  "parameters": [
    {
      "name": "settings",
      "type": "SchemaSettings",
      "description": "The schema settings object to be registered."
    }
  ],
  "returns": {
    "type": "void",
    "description": "This method does not return any value."
  }
}
```

----------------------------------------

TITLE: Testing with MockDatabase in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to use `MockDatabase` for isolated unit testing in NocoBase. It sets up a new mocked database instance before each test, defines a 'posts' collection, synchronizes the database, and then tests creating a post and asserting its title. The `MockDatabase` ensures data isolation between test cases using random table prefixes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/others/testing.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { MockDatabase } from '@nocobase/test';

describe('my suite', () => {
  let db;

  beforeEach(async () => {
    db = new MockDatabase();

    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });

    await db.sync();
  });

  test('my case', async () => {
    const postRepository = db.getRepository('posts');
    const p1 = await postRepository.create({
      values: {
        title: 'hello',
      },
    });

    expect(p1.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the `documentActionSettings` with the NocoBase application's `schemaSettingsManager` within the plugin's `load` method. This makes the defined settings available for use with UI schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/action-simple.md#_snippet_6

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { useDocumentActionProps } from './schema';
import { documentActionSettings } from './settings';

export class PluginInitializerActionSimpleClient extends Plugin {
  async load() {
    this.app.addScopes({ useDocumentActionProps });
    this.app.schemaSettingsManager.add(documentActionSettings);
  }
}

export default PluginInitializerActionSimpleClient;
```

----------------------------------------

TITLE: Testing NocoBase Plugin Actions with MockServer (TypeScript)
DESCRIPTION: This comprehensive test snippet demonstrates how to test a NocoBase plugin's actions using `mockServer`. It initializes the application, loads the plugin, and sets up the database. The test case simulates creating a product, then creating an order for that product, and finally delivering the order, asserting the status and tracking number at each step. It showcases interaction with custom resources and actions defined within a plugin.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/others/testing.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { mockServer } from '@nocobase/test';
import Plugin from '../../src/server';

describe('shop actions', () => {
  let app;
  let agent;
  let db;

  beforeEach(async () => {
    app = mockServer();
    app.plugin(Plugin);
    agent = app.agent();
    db = app.db;

    await app.load();
    await db.sync();
  });

  afterEach(async () => {
    await app.destroy();
  });

  test('product order case', async () => {
    const { body: product } = await agent.resource('products').create({
      values: {
        title: 'iPhone 14 Pro',
        price: 7999,
        enabled: true,
        inventory: 1,
      },
    });
    expect(product.data.price).toEqual(7999);

    const { body: order } = await agent.resource('orders').create({
      values: {
        productId: product.data.id,
      },
    });
    expect(order.data.totalPrice).toEqual(7999);
    expect(order.data.status).toEqual(0);

    const { body: deliveredOrder } = await agent.resource('orders').deliver({
      filterByTk: order.data.id,
      values: {
        provider: 'SF',
        trackingNumber: '123456789',
      },
    });
    expect(deliveredOrder.data.status).toBe(2);
    expect(deliveredOrder.data.delivery.trackingNumber).toBe('123456789');
  });
});
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin Load Method
DESCRIPTION: This snippet demonstrates how to register the previously defined `infoSettings` with the NocoBase application's `schemaSettingsManager`. This registration occurs within the `load` method of the `PluginInitializerBlockDataClient` class, making the settings available for use with the custom data block.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data.md#_snippet_10

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { infoSettings } from './settings';

export class PluginInitializerBlockDataClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(infoSettings)
  }
}

export default PluginInitializerBlockDataClient;
```

----------------------------------------

TITLE: Registering Event Listeners in NocoBase Plugins (TypeScript)
DESCRIPTION: This snippet demonstrates how to register event listeners in a NocoBase plugin using `this.app.on()` and `this.db.on()`. Event registration can occur in `afterAdd()`, which runs after plugin addition, or `beforeLoad()`, which runs only after plugin activation. These methods are crucial for setting up event-driven logic within the NocoBase ecosystem.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/events.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export class MyPlugin extends Plugin {
  // After the plugin is added, afterAdd() is executed with or without activation
  afterAdd() {
    this.app.on();
    this.db.on();
  }

  // beforeLoad() will only be executed after the plugin is activated
  beforeLoad() {
    this.app.on();
    this.db.on();
  }
}
```

----------------------------------------

TITLE: Defining NocoBase Schema Initializer Item for Dynamic Block Creation (TypeScript)
DESCRIPTION: This code defines a `SchemaInitializerItemType` and its associated `Component` for dynamically creating a timeline block. It utilizes `DataBlockInitializer` to handle block creation, capturing collection and data source information. A configuration form (`TimelineInitializerConfigForm`) is used to gather additional fields (`timeField`, `titleField`) before inserting the generated schema into the page using `useSchemaInitializer`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-data-modal.md#_snippet_7

LANGUAGE: tsx
CODE:
```
import React, { useCallback, useState } from 'react';
import { FieldTimeOutlined } from '@ant-design/icons';
import { DataBlockInitializer, SchemaInitializerItemType, useSchemaInitializer } from "@nocobase/client";

import { getTimelineSchema } from '../schema';
import { useT } from '../locale';
import { TimelineConfigFormProps, TimelineInitializerConfigForm } from './ConfigForm';
import { BlockName, BlockNameLowercase } from '../constants';

export const TimelineInitializerComponent = () => {
  const { insert } = useSchemaInitializer();
  const [collection, setCollection] = useState<string>();
  const [dataSource, setDataSource] = useState<string>();
  const [showConfigForm, setShowConfigForm] = useState(false);
  const t = useT()

  const onSubmit: TimelineConfigFormProps['onSubmit'] = useCallback((values) => {
    const schema = getTimelineSchema({ collection, dataSource, timeField: values.timeField, titleField: values.titleField });
    insert(schema);
  }, [collection, dataSource])

  return <>
    {showConfigForm && <TimelineInitializerConfigForm
      visible={showConfigForm}
      setVisible={setShowConfigForm}
      onSubmit={onSubmit}
      collection={collection}
      dataSource={dataSource}
    />}
    <DataBlockInitializer
      name={BlockNameLowercase}
      title={t(BlockName)}
      icon={<FieldTimeOutlined />}
      componentType={BlockName}
      onCreateBlockSchema={({ item }) => {
        const { name: collection, dataSource } = item;
        setCollection(collection);
        setDataSource(dataSource);
        setShowConfigForm(true);
      }}>

    </DataBlockInitializer>
  </>
}

export const timelineInitializerItem: SchemaInitializerItemType = {
  name: 'Timeline',
  Component: TimelineInitializerComponent,
}
```

----------------------------------------

TITLE: Defining Fields within a Collection in NocoBase (TypeScript)
DESCRIPTION: This example illustrates how to define individual fields within a NocoBase collection. Each field requires a `name` and a `type`, which are mandatory. Additional configuration options are available depending on the field type, allowing for detailed data modeling.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    { type: 'string', name: 'name' },
    { type: 'integer', name: 'age' },
    // 其他字段
  ],
});
```

----------------------------------------

TITLE: Define NocoBase Schema Settings for Block Management
DESCRIPTION: This code defines 'imageSettings', a Schema Settings object for the 'Image' block. It includes a 'remove' item with specific 'componentProps' to control its behavior: 'removeParentsIfNoChildren' ensures parent nodes are removed if no children remain, and 'breakRemoveOn' prevents removal beyond a 'Grid' component, which typically wraps blocks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-simple.md#_snippet_8

LANGUAGE: ts
CODE:
```
import { SchemaSettings } from "@nocobase/client";
import { BlockNameLowercase } from "../constants";

export const imageSettings = new SchemaSettings({
  name: `blockSettings:${BlockNameLowercase}`,
  items: [
    {
      type: 'remove',
      name: 'remove',
      componentProps: {
        removeParentsIfNoChildren: true,
        breakRemoveOn: {
          'x-component': 'Grid',
        },
      }
    }
  ]
});
```

----------------------------------------

TITLE: Creating a New NocoBase Plugin and Adding Dependencies (Bash)
DESCRIPTION: This snippet provides bash commands to initialize a new NocoBase plugin using `yarn pm create` and then add `echarts` and `echarts-for-react` as development dependencies using `npx lerna add`. These dependencies are crucial for integrating ECharts into the plugin.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/data-visualization/step-by-step/index.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase/plugin-sample-add-custom-charts
npx lerna add echarts --scope=@nocobase/plugin-sample-add-custom-charts --dev
npx lerna add echarts-for-react --scope=@nocobase/plugin-sample-add-custom-charts --dev
```

----------------------------------------

TITLE: Define NocoBase Schema Initializer Item (TypeScript)
DESCRIPTION: This snippet defines a `SchemaInitializerItem` that allows users to insert the custom 'Image' block into a page. It specifies the item's type, unique name, icon, and a `useComponentProps` function that provides the display title and an `onClick` handler to insert the `imageSchema`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-simple.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { SchemaInitializerItemType, useSchemaInitializer } from '@nocobase/client';

import { useT } from '../locale';
import { imageSchema } from '../schema';
import { BlockName, BlockNameLowercase } from '../constants';

export const imageInitializerItem: SchemaInitializerItemType = {
  type: 'item',
  name: BlockNameLowercase,
  icon: 'FileImageOutlined',
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT()
    return {
      title: t(BlockName),
      onClick: () => {
        insert(imageSchema);
      },
    };
  },
}
```

----------------------------------------

TITLE: Listing Resources using cURL (Shell)
DESCRIPTION: This cURL command demonstrates how to use the `list` action to retrieve a collection of resources. It performs a GET request to the `/api/<resource>:list` endpoint, which can be further refined with parameters like `filter`, `fields`, and `sort`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/actions.md#_snippet_2

LANGUAGE: Shell
CODE:
```
curl -X GET http://localhost:13000/api/users:list
```

----------------------------------------

TITLE: Exporting Submit Action Schema (TypeScript)
DESCRIPTION: This snippet exports all named exports from the `schema.ts` file, making `useFormV3SubmitActionProps` and `submitActionSchema` available for import in other modules. This is a common pattern for organizing and re-exporting modules within a plugin.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/block/block-form.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
export * from './schema';
```

----------------------------------------

TITLE: Finding a Field by Predicate in a Collection (TypeScript)
DESCRIPTION: This method finds a field object in the data table that matches a specified condition. It takes a predicate function as a parameter and returns the matching `Field` object or `undefined`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/collection.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
const posts = db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});

posts.findField((field) => field.name === 'title');
```

----------------------------------------

TITLE: Registering Plugin Settings Page (TSX)
DESCRIPTION: This TSX code defines a NocoBase client-side plugin that registers a new settings page. It uses `pluginSettingsManager.add` to create an entry for 'Plugin Settings Table' with a specified title, icon, and a placeholder component, making the page accessible in the admin interface.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
// @ts-ignore
import { name } from '../../package.json';

export class PluginSettingsTableClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Plugin Settings Table',
      icon: 'TableOutlined',
      Component: () => 'TODO',
    });
  }
}

export default PluginSettingsTableClient;
```

----------------------------------------

TITLE: Configure Nocobase Form Fields from Current Collection
DESCRIPTION: This section explains how to configure fields directly from the current data collection within the form block. These fields are editable and directly correspond to the data model of the current entity.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/ui/blocks/data-blocks/form.md#_snippet_6

LANGUAGE: Plain Text
CODE:
```
Fields in the Current Collection
```

----------------------------------------

TITLE: Register NocoBase Custom Block Component with Plugin
DESCRIPTION: This TypeScript snippet demonstrates how to register the 'Info' block component with the NocoBase client plugin. By adding 'Info' to the application's components, it becomes available for use within the NocoBase UI schema and design system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data.md#_snippet_4

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { Info } from './component';

export class PluginInitializerBlockDataClient extends Plugin {
  async load() {
    this.app.addComponents({ Info });
  }
}

export default PluginInitializerBlockDataClient;
```

----------------------------------------

TITLE: Exporting NocoBase Block Component (TypeScript)
DESCRIPTION: This snippet exports the `Info` component from its module, making it available for import by other parts of the NocoBase plugin. This is a standard practice for module organization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-data.md#_snippet_5

LANGUAGE: tsx
CODE:
```
export * from './Info';
```

----------------------------------------

TITLE: Comparing Rendering of Various Schema Property Types in NocoBase (TSX)
DESCRIPTION: This snippet illustrates the rendering behavior of different schema property types (void, object, array, string) when nested within a custom component (Hello) in NocoBase's SchemaComponent. It highlights that void and object schemas render their properties, while array and string schemas do not, even if properties are defined. This helps understand how x-component and properties interact with different type definitions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/extending.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const Hello = (props) => <h1>Hello, {props.children}!</h1>;
const World = () => <span>world</span>;

const schema = {
  type: 'object',
  properties: {
    title1: {
      type: 'void',
      'x-content': 'Void schema, rendering properties',
    },
    void: {
      type: 'void',
      name: 'hello',
      'x-component': 'Hello',
      properties: {
        world: {
          type: 'void',
          'x-component': 'World',
        },
      },
    },
    title2: {
      type: 'void',
      'x-content': 'Object schema, rendering properties',
    },
    object: {
      type: 'object',
      name: 'hello',
      'x-component': 'Hello',
      properties: {
        world: {
          type: 'string',
          'x-component': 'World',
        },
      },
    },
    title3: {
      type: 'void',
      'x-content': 'Array schema, not rendering properties',
    },
    array: {
      type: 'array',
      name: 'hello',
      'x-component': 'Hello',
      properties: {
        world: {
          type: 'string',
          'x-component': 'World',
        },
      },
    },
    title4: {
      type: 'void',
      'x-content': 'String schema, not rendering properties',
    },
    string: {
      type: 'string',
      name: 'hello',
      'x-component': 'Hello',
      properties: {
        world: {
          type: 'string',
          'x-component': 'World',
        },
      },
    },
  },
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello, World }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Creating React Context for Features (TypeScript)
DESCRIPTION: This TypeScript snippet defines a React Context (`FeaturesContext`) to store feature toggle states. It includes a `FeaturesProvider` component that fetches mock feature data using `useRequest` and provides it to its children. It also exports `useFeatures` and `useFeature` hooks for convenient access to the context data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/provider/context.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import { useRequest } from '@nocobase/client';
import { Spin } from 'antd';
import React, { FC, createContext, ReactNode } from 'react';

const FeaturesContext = createContext<Record<string, boolean>>({});

const mockRequest = () => new Promise((resolve) => {
  resolve({ data: { feature1: true, feature2: false } })
})

export const FeaturesProvider: FC<{ children: ReactNode }> = ({ children }) => {
  const { loading, data } = useRequest<{ data: Record<string, boolean> }>(mockRequest);

  if (loading) return <Spin />;

  return <FeaturesContext.Provider value={data.data}>{children}</FeaturesContext.Provider>;
};

export const useFeatures = () => React.useContext(FeaturesContext);

export const useFeature = (feature: string) => {
  const features = useFeatures();
  return features[feature];
}
```

----------------------------------------

TITLE: Registering Custom Query Operator (TypeScript)
DESCRIPTION: This example shows how to register a custom data query operator, `$dateOn`, which filters records by date. It then demonstrates using this custom operator within a `getRepository().count()` call to query books created on a specific date.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_14

LANGUAGE: TypeScript
CODE:
```
db.registerOperators({
  $dateOn(value) {
    return {
      [Op.and]: [
        { [Op.gte]: stringToDate(value) },
        { [Op.lt]: getNextDay(value) },
      ],
    };
  },
});

db.getRepository('books').count({
  filter: {
    createdAt: {
      // registered operator
      $dateOn: '2020-01-01',
    },
  },
});
```

----------------------------------------

TITLE: Updating Specific Fields via Repository Whitelist - JavaScript
DESCRIPTION: This snippet illustrates how to precisely control which fields are updated during a `repository.update()` operation using the `whitelist` parameter. Only fields specified in the `whitelist` array will be modified, even if other fields are provided in `values`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_13

LANGUAGE: javascript
CODE:
```
await userRepository.update({
  filter: {
    name: 'Mark',
  },
  values: {
    age: 20,
    name: 'Alex',
  },
  whitelist: ['age'], // Only update the age field
});
```

----------------------------------------

TITLE: Registering Custom Page in NocoBase Plugin Client
DESCRIPTION: This code extends the NocoBase `Plugin` class to register `SamplesCustomPage` as a new route within the NocoBase client-side router. The `load` method adds a route 'admin.custom-page2' with a specified path and directly assigns the `SamplesCustomPage` component, enabling local component registration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/local.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { SamplesCustomPage } from './CustomPage';

export class PluginComponentAndScopeLocalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page2', {
      path: '/admin/custom-page2',
      Component: SamplesCustomPage,
    });
  }
}

export default PluginComponentAndScopeLocalClient;
```

----------------------------------------

TITLE: Inserting Schema with `useDesignable()` in React
DESCRIPTION: This React component demonstrates how to use the `useDesignable()` hook to dynamically insert new schema nodes. It provides buttons that, when clicked, call `insertAdjacent()` with different positions (`beforeBegin`, `afterBegin`, `beforeEnd`, `afterEnd`) and a new schema object, effectively adding new 'Hello' components relative to the current component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/designable.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import React from 'react';
import {
  SchemaComponentProvider,
  SchemaComponent,
  useDesignable,
} from '@nocobase/client';
import { observer, Schema, useFieldSchema } from '@formily/react';
import { Button, Space } from 'antd';
import { uid } from '@formily/shared';

const Hello = (props) => {
  const { insertAdjacent } = useDesignable();
  const fieldSchema = useFieldSchema();
  return (
    <div>
      <h1>
        {fieldSchema.title} - {fieldSchema.name}
      </h1>
      <Space>
        <Button
          onClick={() => {
            insertAdjacent('beforeBegin', {
              title: 'beforeBegin',
              'x-component': 'Hello',
            });
          }}
        >
          before begin
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('afterBegin', {
              title: 'afterBegin',
              'x-component': 'Hello',
            });
          }}
        >
          after begin
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('beforeEnd', {
              title: 'beforeEnd',
              'x-component': 'Hello',
            });
          }}
        >
          before end
        </Button>
        <Button
          onClick={() => {
            insertAdjacent('afterEnd', {
              title: 'afterEnd',
              'x-component': 'Hello',
            });
          }}
        >
          after end
        </Button>
      </Space>
      <div style={{ margin: 50 }}>{props.children}</div>
    </div>
  );
};

const Page = (props) => {
  return <div>{props.children}</div>;
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Page, Hello }}>
      <SchemaComponent
        schema={{
          type: 'void',
          name: 'page',
          'x-component': 'Page',
          properties: {
            hello1: {
              type: 'void',
              title: 'Main',
              'x-component': 'Hello',
            },
          },
        }}
      />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Migrating JSON-based SchemaInitializer to new SchemaInitializer() - TypeScript
DESCRIPTION: This diff shows how to refactor an old JSON-based `BlockInitializers` definition to the new `new SchemaInitializer()` constructor. Key changes include using `name` instead of `key`, `Component` instead of `component`, and wrapping the entire definition in `new SchemaInitializer({})`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/welcome/release/upgrade-to/v017.md#_snippet_4

LANGUAGE: diff
CODE:
```
- export const BlockInitializers = {
+ export const blockInitializers = new SchemaInitializer({
+ name: 'BlockInitializers',
  'data-testid': 'add-block-button-in-page',
  title: '{{t("Add block")}}',
  icon: 'PlusOutlined',
  wrap: gridRowColWrap,
   items: [
    {
-     key: 'dataBlocks',
+     name: 'data-blocks',
      type: 'itemGroup',
      title: '{{t("Data blocks")}}',
      children: [
        {
-         key: 'table',
+         name: 'table',
-         type: 'item', // 当有 Component 参数时，就不需要此了
          title: '{{t("Table")}}',
-         component: TableBlockInitializer,
+         Component: TableBlockInitializer,
        },
         {
          key: 'form',
          type: 'item',
          title: '{{t("Form")}}',
          component: FormBlockInitializer,
        }
      ],
    },
  ],
});
```

----------------------------------------

TITLE: Defining Custom Refresh Action Schema and Props (TypeScript)
DESCRIPTION: This snippet defines `useCustomRefreshActionProps`, a React Hook that provides dynamic properties for an `Action` component, and `customRefreshActionSchema`, an `ISchema` object that describes the UI structure of the custom refresh action. It uses `useDataBlockRequest` to enable data refreshing and `useT` for internationalization. The schema specifies the component type, toolbar, and links to the dynamic properties via `x-use-component-props`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/configure-actions.md#_snippet_7

LANGUAGE: ts
CODE:
```
import { ActionProps, useDataBlockRequest, ISchema } from "@nocobase/client";
import { useT } from "../../../../locale";

export const useCustomRefreshActionProps = (): ActionProps => {
  const { runAsync } = useDataBlockRequest();
  const t = useT();
  return {
    type: 'primary',
    title: t('Custom Refresh'),
    async onClick() {
      await runAsync();
    },
  }
}

export const customRefreshActionSchema: ISchema = {
  type: 'void',
  'x-component': 'Action',
  'x-toolbar': 'ActionSchemaToolbar',
  'x-use-component-props': 'useCustomRefreshActionProps'
}
```

----------------------------------------

TITLE: NocoBase Application Root Component Structure with Schema Rendering
DESCRIPTION: This snippet illustrates the typical rendering structure within a NocoBase application. It shows `SchemaComponentProvider` wrapping the application's `Routes`, ensuring that all routed components have access to the global schema context, including registered components and scopes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/rendering.md#_snippet_4

LANGUAGE: tsx
CODE:
```
<Router>
  {/* Context Provider for routing */}
  <SchemaComponentProvider components={app.components} scopes={app.scopes}>
    {/* Custom Provider components - start tag */}
    <Routes />
    {/* Custom Provider components - end tag */}
  </SchemaComponentProvider>
</Router>
```

----------------------------------------

TITLE: Fetching Data from External API using JavaScript
DESCRIPTION: This asynchronous script uses the `fetch` API to retrieve JSON data from a specified URL. It includes error handling for network issues and non-OK HTTP responses, making it suitable for integrating external data sources into a workflow.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/nodes/javascript.md#_snippet_1

LANGUAGE: JavaScript
CODE:
```
/**
 * Fetches data from a specified URL.
 * @param {string} url - The URL to fetch data from.
 * @returns {Promise<object>} A promise that resolves with the JSON data.
 */
async function fetchData(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error fetching data:", error);
    throw error;
  }
}

// Example usage:
// fetchData('https://api.example.com/data')
//   .then(data => console.log('Fetched data:', data))
//   .catch(error => console.error('Failed to fetch:', error));
```

----------------------------------------

TITLE: NocoBase Password Login Security Configuration
DESCRIPTION: This section details configurable parameters for password login security, including maximum invalid attempts, time intervals, and account lock durations. It also provides recommendations for enhancing password security and preventing brute-force attacks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/security.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
Configuration Items:
- Maximum Invalid Password Login Attempts: Set max attempts within a time interval.
- Maximum Invalid Password Login Time Interval (seconds): Interval for calculating attempts.
- Lock Time (seconds): Time to lock user after exceeding limit (0 for no limit). Locked users cannot access via any method, including API keys.

Recommendations:
- Set strong password rules.
- Set reasonable password validity period.
- Combine invalid login attempts and time configuration to prevent brute-force.
- Use lock time cautiously; combine with IP restrictions/API frequency limits to prevent malicious lockouts.
- Change default NocoBase root credentials.
- Set up multiple accounts with password reset/unlock permissions.
```

----------------------------------------

TITLE: Using `x-decorator` for Card Item Wrapping in UI Schema (TypeScript)
DESCRIPTION: This schema demonstrates using `x-decorator` to wrap different components (`Table`, `Kanban`) with a `CardItem` decorator. This pattern ensures consistent styling and structure for various content blocks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/what-is-ui-schema.md#_snippet_20

LANGUAGE: TypeScript
CODE:
```
{
  type: 'void',
  ['x-component']: 'div',
  properties: {
    table: {
      type: 'array',
      'x-decorator': 'CardItem',
      'x-component': 'Table',
    },
    kanban: {
      type: 'array',
      'x-decorator': 'CardItem',
      'x-component': 'Kanban',
    },
  },
}
```

----------------------------------------

TITLE: Implementing NocoBase Plugin Settings Page (TypeScript/React)
DESCRIPTION: This TypeScript/React snippet defines a NocoBase plugin client that adds a custom settings page. It uses `this.app.pluginSettingsManager.add` to register a React component (`MySettingPage`) as the content for the plugin's configuration page, identified by its name, title, and icon. This allows for a dedicated UI for plugin settings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-setting-page-single-route/index.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import React from 'react';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const MySettingPage = () => <div>Hello Setting page</div>;

export class PluginAddSettingPageSingleRouteClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Single Route',
      icon: 'ApiOutlined',
      Component: MySettingPage,
    });
  }
}

export default PluginAddSettingPageSingleRouteClient;
```

----------------------------------------

TITLE: Updating Association Resources - NocoBase HTTP API
DESCRIPTION: This snippet demonstrates how to update a specific association resource for a collection using NocoBase's custom HTTP API. It requires a POST request to the update endpoint, supporting both query and path parameters, along with a JSON body.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/http/rest-api.md#_snippet_16

LANGUAGE: bash
CODE:
```
POST   /api/<collection>/<collectionIndex>/<association>:update?filterByTk=<associationIndex>

{} # JSON body

# Or
POST   /api/<collection>/<collectionIndex>/<association>:update/<associationIndex>

{} # JSON body
```

----------------------------------------

TITLE: Configuring Parent Page Without Custom Layout (TypeScript)
DESCRIPTION: This TypeScript snippet shows an alternative way to configure a parent route in NocoBase when the `MaterialPage` component is used solely as a parent and does not require a custom layout. By omitting the `Component` property, the route still registers the path, allowing sub-routes to render within its `Outlet`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-page/index.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
this.app.router.add('admin.material', {
  path: '/admin/material',
})
```

----------------------------------------

TITLE: Defining Custom UI Components and Schema in NocoBase (TypeScript)
DESCRIPTION: This snippet defines `SamplesHello` (a React functional component) and `useSamplesHelloProps` (a custom hook for dynamic schema props). It then constructs an `ISchema` object that utilizes these components via `x-component` and `x-use-component-props` to render a custom page using `SchemaComponent`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/global.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import { ISchema, SchemaComponent, withDynamicSchemaProps } from "@nocobase/client"
import { uid } from '@formily/shared'
import { useFieldSchema } from '@formily/react'
import React, { FC } from "react"

export const SamplesHello: FC<{ name: string }> = withDynamicSchemaProps(({ name }) => {
  return <div>hello {name}</div>
})

export const useSamplesHelloProps = () => {
  const schema = useFieldSchema();
  return { name: schema.name }
}

const schema: ISchema = {
  type: 'void',
  name: uid(),
  properties: {
    demo1: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-component-props': {
        name: 'demo1',
      },
    },
    demo2: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-use-component-props': 'useSamplesHelloProps',
    },
  }
}

export const SamplesCustomPage = () => {
  return <SchemaComponent schema={schema}></SchemaComponent>
}
```

----------------------------------------

TITLE: Registering FormV3 Scope and Component in NocoBase Plugin (TSX)
DESCRIPTION: This snippet demonstrates how to register a custom `FormV3` component and its associated `useFormV3Props` scope within a NocoBase client plugin. It ensures that the UI schema system can locate and utilize these custom elements for rendering and property handling, making them available for use in `x-component-props` and `x-use-component-props`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/block/block-form.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { FormV3 } from './FormV3';
import { useFormV3Props } from './FormV3.schema';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.addComponents({ FormV3 })
    this.app.addScopes({ useFormV3Props });
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Adding Initializers via NocoBase Plugin Load - TypeScript
DESCRIPTION: This snippet illustrates the new recommended way to add schema initializers and components within a NocoBase plugin's load method. It uses this.app.schemaInitializerManager.add() to register initializers and this.app.addComponents() for components, integrating them directly into the application's lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/upgrade-to/v017.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';

class MyPlugin extends Plugin {
  async load() {
    this.app.schemaInitializerManager.add(blockInitializers);
    this.app.addComponents({ ManualActionDesigner });
  }
}
```

----------------------------------------

TITLE: Registering a React Component in NocoBase Schema (TSX)
DESCRIPTION: This snippet demonstrates how to register a simple React component (`Hello`) directly into the NocoBase Schema component library. It uses `SchemaComponentProvider` to make the custom component available for use within a `SchemaComponent`, allowing it to be referenced by its `x-component` name in the schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/extending.md#_snippet_0

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const Hello = () => <h1>Hello, world!</h1>;

const schema = {
  type: 'void',
  name: 'hello',
  'x-component': 'Hello',
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Migrating registerGroup API in NocoBase JavaScript
DESCRIPTION: This snippet shows the transition from the `registerGroup()` function to the `app.dataSourceManager.addFieldInterfaceGroups()` method for registering field interface groups in NocoBase. This adjustment aligns with the new API structure for managing data source components.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0200-changelog/index.md#_snippet_2

LANGUAGE: JavaScript
CODE:
```
registerGroup()
```

LANGUAGE: JavaScript
CODE:
```
app.dataSourceManager.addFieldInterfaceGroups()
```

----------------------------------------

TITLE: Registering Global Settings Provider in NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to register the `PluginSettingsFormProvider` globally within a NocoBase plugin's client-side application. By adding the provider to `this.app.addProvider()`, the global configuration data becomes accessible throughout the NocoBase client application, ensuring consistent data availability.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/form.md#_snippet_13

LANGUAGE: ts
CODE:
```
import { PluginSettingsFormProvider } from './PluginSettingsFormProvider'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...
    this.app.addProvider(PluginSettingsFormProvider)
  }
}
```

----------------------------------------

TITLE: Register Custom Authentication Types in NocoBase Plugin
DESCRIPTION: To enable a new authentication method in NocoBase, it must be registered with the `authManager`. This JavaScript snippet illustrates how to register your `CustomAuth` class with a unique identifier, making it available for use within your NocoBase application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/auth/dev/guide.md#_snippet_6

LANGUAGE: JavaScript
CODE:
```
class CustomAuthPlugin extends Plugin {
  async load() {
    this.app.authManager.registerTypes('custom-auth-type', {
      auth: CustomAuth,
    });
  }
}
```

----------------------------------------

TITLE: Complete NocoBase Router Example
DESCRIPTION: A comprehensive example demonstrating the setup of a NocoBase application with a memory router, defining a layout component, and adding nested home and about routes. It showcases a typical application routing configuration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/client/router.md#_snippet_7

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { Link, Outlet } from 'react-router-dom';
import { Application } from '@nocobase/client';

const Home = () => <h1>Home</h1>;
const About = () => <h1>About</h1>;

const Layout = () => {
  return (
    <div>
      <div>
        <Link to={'/'}>Home</Link>, <Link to={'/about'}>About</Link>
      </div>
      <Outlet />
    </div>
  );
};

const app = new Application({
  router: {
    type: 'memory',
    initialEntries: ['/'],
  },
});

app.router.add('root', {
  element: <Layout />,
});

app.router.add('root.home', {
  path: '/',
  element: <Home />,
});

app.router.add('root.about', {
  path: '/about',
  element: <About />,
});

export default app.getRootComponent();
```

----------------------------------------

TITLE: NocoBase Client API: `collection.getField(fieldName)`
DESCRIPTION: This section documents the `collection.getField(fieldName)` method from the NocoBase client's data source. It explains its purpose in retrieving detailed information for a specific collection field, as demonstrated in the `InfoItem` component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_8

LANGUAGE: APIDOC
CODE:
```
- `collection.getField(collectionFieldName)`: Used to retrieve detailed information about a specific field within a collection.
```

----------------------------------------

TITLE: Registering an Existing React Component in NocoBase Schema (TypeScript)
DESCRIPTION: This snippet demonstrates how to register and use a simple React component (`Hello`) directly within the NocoBase Schema component library. It shows how to provide the custom component to `SchemaComponentProvider` and reference it in the schema's `x-component` property for rendering.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/extending.md#_snippet_0

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const Hello = () => <h1>Hello, world!</h1>;

const schema = {
  type: 'void',
  name: 'hello',
  'x-component': 'Hello'
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Finding Associated Objects with HasOneRepository in TypeScript
DESCRIPTION: This example demonstrates how to use the `find()` method of `HasOneRepository` to retrieve an associated object. It highlights that the method returns `null` if no associated object exists.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/has-one-repository.md#_snippet_1

LANGUAGE: typescript
CODE:
```
const profile = await UserProfileRepository.find();
// Return null if the associated object does not exist
```

----------------------------------------

TITLE: Registering Event Listeners in NocoBase Plugins (TypeScript)
DESCRIPTION: This snippet demonstrates how to register event listeners within a NocoBase plugin. Event registration typically occurs in the `afterAdd()` method, which runs after the plugin is added (with or without activation), or in `beforeLoad()`, which executes only after the plugin is activated. It shows basic usage of `this.app.on()` for application events and `this.db.on()` for database events.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/events.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export class MyPlugin extends Plugin {
  // After the plugin is added, afterAdd() is executed with or without activation
  afterAdd() {
    this.app.on();
    this.db.on();
  }

  // beforeLoad() will only be executed after the plugin is activated
  beforeLoad() {
    this.app.on();
    this.db.on();
  }
}
```

----------------------------------------

TITLE: Integrating Ant Design Input with Formily Connect (TSX)
DESCRIPTION: This example shows how to integrate a third-party component (Ant Design's `Input`) into the NocoBase Schema using Formily's `connect` function. It utilizes `mapProps` to inject additional properties (like a suffix) and `mapReadPretty` to define a custom read-only view for the component, demonstrating adaptation of external UI libraries.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/extending.md#_snippet_1

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { Input } from 'antd';
import { connect, mapProps, mapReadPretty } from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const ReadPretty = (props) => {
  return <div>{props.value}</div>;
};

const SingleText = connect(
  Input,
  mapProps((props, field) => {
    return {
      ...props,
      suffix: 'Suffix',
    };
  }),
  mapReadPretty(ReadPretty),
);

const schema = {
  type: 'object',
  properties: {
    t1: {
      type: 'string',
      default: 'hello t1',
      'x-component': 'SingleText',
    },
    t2: {
      type: 'string',
      default: 'hello t2',
      'x-component': 'SingleText',
      'x-pattern': 'readPretty',
    },
  },
};

export default () => {
  return (
    <SchemaComponentProvider components={{ SingleText }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Adding Associated Objects with BelongsToManyRepository in TypeScript
DESCRIPTION: Demonstrates how to use the `add()` method of `BelongsToManyRepository` to associate objects, showing examples of passing only target keys and passing target keys with intermediate table field values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/belongs-to-many-repository.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
const t1 = await Tag.repository.create({
  values: { name: 't1' },
});

const t2 = await Tag.repository.create({
  values: { name: 't2' },
});

const p1 = await Post.repository.create({
  values: { title: 'p1' },
});

const PostTagRepository = new BelongsToManyRepository(Post, 'tags', p1.id);

// Pass in the targetKey
PostTagRepository.add([t1.id, t2.id]);

// Pass in intermediate table fields
PostTagRepository.add([
  [t1.id, { tagged_at: '123' }],
  [t2.id, { tagged_at: '456' }],
]);
```

----------------------------------------

TITLE: Create a New NocoBase Plugin with ECharts Dependencies
DESCRIPTION: Follow the plugin development guide to create a new plugin. Add `echarts`, `echarts-for-react`, and `@nocobase/plugin-data-visualization` as dependencies. Place external dependencies in `devDependencies` in `package.json`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/data-visualization/step-by-step/index.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase/plugin-sample-add-custom-charts
npx lerna add echarts --scope=@nocobase/plugin-sample-add-custom-charts --dev
npx lerna add echarts-for-react --scope=@nocobase/plugin-sample-add-custom-charts --dev
```

LANGUAGE: json
CODE:
```
{
  "name": "@nocobase/plugin-sample-add-custom-charts",
  "version": "0.14.0-alpha.7",
  "main": "dist/server/index.js",
  "devDependencies": {
    "echarts": "^5.4.3",
    "echarts-for-react": "^3.0.2"
  },
  "peerDependencies": {
    "@nocobase/client": "0.x",
    "@nocobase/server": "0.x",
    "@nocobase/test": "0.x",
    "@nocobase/plugin-data-visualization": "0.x"
  }
}
```

----------------------------------------

TITLE: Defining NocoBase Backend Data Table with TypeScript
DESCRIPTION: This snippet defines a new data table named `samplesEmailTemplates` using NocoBase's `defineCollection` API. It includes two fields: `subject` of type `string` for single-line text and `content` of type `text` for rich text, establishing the backend schema for email templates.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
import { defineCollection } from '@nocobase/database';

export default defineCollection({
  name: 'samplesEmailTemplates',
  fields: [
    {
      type: 'string',
      name: 'subject',
    },
    {
      type: 'text',
      name: 'content',
    },
  ],
});
```

----------------------------------------

TITLE: Updating Data via Repository Update - JavaScript
DESCRIPTION: Shows how to update records directly using the `update()` method of a `Repository`, applying changes to all records that match a specified filter condition. This is efficient for bulk updates.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_18

LANGUAGE: javascript
CODE:
```
await userRepository.update({
  filter: {
    name: 'Mark',
  },
  values: {
    age: 20,
  },
});
```

----------------------------------------

TITLE: Setting Multiple Fields in a Collection (TypeScript)
DESCRIPTION: This method sets multiple fields to the data table. It accepts an array of `FieldOptions` for each field and an optional `resetFields` boolean to determine if existing fields should be cleared first.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/collection.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
const posts = db.collection({ name: 'posts' });

posts.setFields([
  { type: 'string', name: 'title' },
  { type: 'double', name: 'price' },
]);
```

----------------------------------------

TITLE: Loading Application - TypeScript
DESCRIPTION: Loads and initializes the application. This method can be configured with options for reloading, triggering hooks, and syncing data table configurations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/server/application.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
load(options?: LoadOptions): Promise<void>
```

----------------------------------------

TITLE: Registering Dynamic Props Hook and Component with `SchemaComponent` (TSX)
DESCRIPTION: This TSX snippet demonstrates how to register a custom hook (`useTableProps`) and a component (`MyTable`) within the `SchemaComponent`'s `scope` and `components` props, respectively. This setup allows the UI Schema to correctly resolve and apply dynamic properties to `MyTable`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/what-is-ui-schema.md#_snippet_16

LANGUAGE: TSX
CODE:
```
<SchemaComponent
  scope={{ useTableProps }}
  components={{ MyTable }}
  schema={{
    type: 'void',
    'x-component': 'MyTable',
    'x-use-component-props': 'useTableProps',
  }}
>
```

----------------------------------------

TITLE: Creating a Collection using NocoBase HTTP API
DESCRIPTION: This snippet demonstrates how to create a new collection using the NocoBase HTTP API. It uses a POST request to the ':create' endpoint and requires a JSON body for the collection data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions-v2/rest-api.md#_snippet_0

LANGUAGE: bash
CODE:
```
POST  /api/<collection>:create

{} # JSON body
```

----------------------------------------

TITLE: Rendering Timeline Block with DataBlockProvider in NocoBase (TSX)
DESCRIPTION: This snippet demonstrates how the previously defined UI schema translates into a React component structure. It shows the `DataBlockProvider` wrapping a `CardItem` which in turn contains the `Timeline` component, passing dynamic props via `useTimelineProps` for data display.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data-modal.md#_snippet_1

LANGUAGE: TSX
CODE:
```
<DataBlockProvider collection={collection} dataSource={dataSource} action='list' params={{ sort: `-${timeField}` }} timeline={{ titleField, timeField }}>
  <CardItem>
    <Timeline {...useTimelineProps()} />
  </CardItem>
</DataBlockProvider>
```

----------------------------------------

TITLE: Configure NocoBase JWT Token Policies
DESCRIPTION: Details the configurable JWT (JSON Web Token) policies in NocoBase for server-side API authentication. These settings control session validity, individual token validity, and the refresh limit for expired tokens to balance security and user experience.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/security.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
{
  "Configuration Items": [
    {
      "item": "Session Validity",
      "description": "The maximum valid time for each user login. During the session validity, the Token will be automatically updated. After the timeout, the user is required to log in again."
    },
    {
      "item": "Token Validity",
      "description": "The validity period of each issued API Token. After the Token expires, if it is within the session validity period and has not exceeded the refresh limit, the server will automatically issue a new Token to maintain the user session, otherwise the user is required to log in again. (Each Token can only be refreshed once)"
    },
    {
      "item": "Expired Token Refresh Limit",
      "description": "The maximum time limit allowed for refreshing a Token after it expires."
    }
  ]
}
```

----------------------------------------

TITLE: NocoBase User Lockout Management
DESCRIPTION: This feature, available in Professional Edition and above, allows administrators to manage users locked out due to exceeding invalid password login limits. It enables active unlocking or manual addition of abnormal users to the lockout list, prohibiting system access via any authentication method, including API keys.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/security.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Feature: User Lockout
Edition: Professional Edition and above (requires password policy plugin)
Description: Manage users locked out for exceeding invalid password login limits. Allows active unlocking or manual addition of users to the lockout list. Locked users are prohibited from accessing the system via any authentication method, including API keys.
```

----------------------------------------

TITLE: Registering Asynchronous ACL Middleware with use() in TypeScript
DESCRIPTION: This example demonstrates how to register an asynchronous middleware function with the NocoBase ACL system using `acl.use()`. The middleware receives the context (`ctx`) and a `next` function, allowing for custom logic execution before passing control to the next middleware in the chain.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/acl/acl.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
acl.use(async () => {
  return async function (ctx, next) {
    // ...
    await next();
  };
});
```

----------------------------------------

TITLE: Extend Schema Components: Connecting Third-Party Components with connect
DESCRIPTION: This example illustrates how to use `connect` from `@formily/react` to non-invasively connect to third-party components, such as Ant Design's `Input`. It combines `connect` with `mapProps` to modify component props and `mapReadPretty` to define a read-only display component, adapting the component for schema usage.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/client/ui-schema/extending.md#_snippet_1

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Input } from 'antd';
import { connect, mapProps, mapReadPretty } from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const ReadPretty = (props) => {
  return <div>{props.value}</div>;
};

const SingleText = connect(
  Input,
  mapProps((props, field) => {
    return {
      ...props,
      suffix: 'Suffix'
    };
  }),
  mapReadPretty(ReadPretty)
);

const schema = {
  type: 'object',
  properties: {
    t1: {
      type: 'string',
      default: 'Hello t1',
      'x-component': 'SingleText'
    },
    t2: {
      type: 'string',
      default: 'Hello t2',
      'x-component': 'SingleText',
      'x-pattern': 'readPretty'
    }
  }
};

export default () => {
  return (
    <SchemaComponentProvider components={{ SingleText }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Globally Registering Custom Components and Scopes in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet shows how to modify a NocoBase plugin's `load` method to globally register the `SamplesHello` component using `this.app.addComponents` and the `useSamplesHelloProps` hook using `this.app.addScopes`. This makes them available for use within the NocoBase UI schema system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/global.md#_snippet_6

LANGUAGE: diff
CODE:
```
import { Plugin } from '@nocobase/client';
- import { SamplesCustomPage } from './CustomPage'
+ import { SamplesCustomPage, SamplesHello, useSamplesHelloProps } from './CustomPage'

export class PluginComponentAndScopeGlobalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page1', {
      path: '/admin/custom-page1',
      Component: 'SamplesCustomPage',
    })

-   this.app.addComponents({ SamplesCustomPage })
+   this.app.addComponents({ SamplesCustomPage, SamplesHello })
+   this.app.addScopes({ useSamplesHelloProps })
  }
}

export default PluginComponentAndScopeGlobalClient;
```

----------------------------------------

TITLE: Deleting Associated Objects with HasManyRepository (TypeScript)
DESCRIPTION: This method deletes associated objects based on the provided criteria. It accepts `TK | DestroyOptions` and returns a Promise resolving to the deleted model instance.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/has-many-repository.md#_snippet_6

LANGUAGE: typescript
CODE:
```
async destroy(options?: TK | DestroyOptions): Promise<M>
```

----------------------------------------

TITLE: Removing HasOne Association with HasOneRepository.remove() - TypeScript
DESCRIPTION: This snippet shows how to use the `remove()` method to disassociate the related object without deleting the object itself. After `remove()`, `find()` returns `null` for the association, but the `Profile` collection still contains the original record, demonstrating that only the link is severed.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/relation-repository/has-one-repository.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
await UserProfileRepository.remove();
(await UserProfileRepository.find()) == null; // true

(await Profile.repository.count()) === 1; // true
```

----------------------------------------

TITLE: Adding Association Relationships with HasManyRepository (TypeScript)
DESCRIPTION: This method establishes association relationships between objects. It accepts `TargetKey | TargetKey[] | AssociatedOptions`, where `tk` specifies the target key value(s) of the associated object, and returns a Promise.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/has-many-repository.md#_snippet_7

LANGUAGE: typescript
CODE:
```
async add(options: TargetKey | TargetKey[] | AssociatedOptions)
```

LANGUAGE: typescript
CODE:
```
interface AssociatedOptions extends Transactionable {
  tk?: TargetKey | TargetKey[];
}
```

----------------------------------------

TITLE: Returning Results from a Workflow Instruction in TypeScript
DESCRIPTION: This snippet shows how to return a specific result from a workflow instruction. The RandomStringInstruction class generates a random string based on a digit configuration from node.config and returns it via the result attribute, along with JOB_STATUS.RESOLVED, for use by subsequent nodes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow/development/instruction.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { Instruction, JOB_STATUS } from '@nocobase/plugin-workflow';

export class RandomStringInstruction extends Instruction {
  run(node, input, processor) {
    // customized config from node
    const { digit = 1 } = node.config;
    const result = `${Math.round(10 ** digit * Math.random())}`.padStart(
      digit,
      '0',
    );
    return {
      status: JOB_STATUS.RESOLVED,
      result,
    };
  }
};
```

----------------------------------------

TITLE: Implementing a Basic Workflow Instruction in TypeScript
DESCRIPTION: This snippet defines a basic workflow instruction class, MyInstruction, which extends Instruction. It implements the run method to execute custom logic, logging a message and returning JOB_STATUS.RESOLVED to indicate successful completion. This is the minimal implementation for a workflow command.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow/development/instruction.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { Instruction, JOB_STATUS } from '@nocobase/plugin-workflow';

export class MyInstruction extends Instruction {
  run(node, input, processor) {
    console.log('my instruction runs!');
    return {
      status: JOB_STATUS.RESOLVED,
    };
  }
}
```

----------------------------------------

TITLE: Defining Fields within a NocoBase Collection
DESCRIPTION: This example illustrates how to define individual fields within a NocoBase collection. Each field requires a `name` and `type` (e.g., 'string', 'integer'). These fields correspond to columns in a database table and can have additional configuration based on their type. System fields like `id`, `createdAt`, and `updatedAt` are automatically generated.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/collections-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    { type: 'string', name: 'name' },
    { type: 'integer', name: 'age' },
    // 他のフィールド
  ],
});
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Deletion Events (TypeScript)
DESCRIPTION: These events are triggered before and after data deletion. They are invoked when `repository.destroy()` is called. Use these hooks to perform cleanup operations or prevent deletion based on certain conditions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_18

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.beforeDestroy` | 'beforeDestroy' | `${string}.afterDestroy' | 'afterDestroy', listener: DestroyListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { DestroyOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type DestroyListener = (
  model: Model,
  options?: DestroyOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeDestroy', async (model, options) => {
  // 何かを行う
});

db.on('books.afterDestroy', async (model, options) => {
  // 何かを行う
});
```

----------------------------------------

TITLE: Importing Collections and Setting ACL in NocoBase Plugin (TypeScript)
DESCRIPTION: This code demonstrates how a NocoBase plugin's `load()` method imports all collection definitions from a specified directory using `this.db.import()`. It also shows how to temporarily grant all access permissions (`*`) to `products`, `categories`, and `orders` resources for testing purposes, enabling automatic CRUD HTTP API generation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import path from 'path';
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    await this.db.import({
      directory: path.resolve(__dirname, 'collections'),
    });

    this.app.acl.allow('products', '*');
    this.app.acl.allow('categories', '*');
    this.app.acl.allow('orders', '*');
  }
}
```

----------------------------------------

TITLE: Registering Custom Encryption Field Type (Server-side) - NocoBase TypeScript
DESCRIPTION: This code registers the EncryptionField as a custom field type named 'encryption' with the NocoBase server's database instance. By calling this.db.registerFieldTypes(), the NocoBase ORM becomes aware of this new field type, allowing it to be used in collection schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/interface.md#_snippet_8

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/server';
import { EncryptionField } from './encryption-field';
import { $encryptionEq } from './operators/eq';
import { $encryptionNe } from './operators/ne';

export class PluginFieldInterfaceServer extends Plugin {
  async load() {
    this.db.registerFieldTypes({
      encryption: EncryptionField,
    });
  }
}

export default PluginFieldInterfaceServer;
```

----------------------------------------

TITLE: Registering QRCode Component and Adding to URL Field Interface (TypeScript)
DESCRIPTION: This TypeScript code registers the `QRCode` component with the Nocobase application and adds it as a selectable option for the 'url' field interface. It ensures the component is available for use in the UI and its settings are managed by `qrCodeComponentFieldSettings`. Dependencies include `@nocobase/client` for `Plugin`, and local `QRCode`, `qrCodeComponentFieldSettings`, and `tStr` modules.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/value.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';

import { QRCode } from './QRCode';
import { qrCodeComponentFieldSettings } from './settings';
import { tStr } from './locale';

export class PluginFieldComponentValueClient extends Plugin {
  async load() {
    this.app.addComponents({ QRCode });
    this.schemaSettingsManager.add(qrCodeComponentFieldSettings);
    this.app.addFieldInterfaceComponentOption('url', {
      label: tStr('QRCode'),
      value: 'QRCode',
    });
  }
}

export default PluginFieldComponentValueClient;
```

----------------------------------------

TITLE: Registering Admin Layout Route in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the main 'admin' route for the NocoBase application. It sets the path to `/admin/*` to capture all sub-routes under `/admin` and assigns the `AdminLayout` component as the primary layout for the administrative section. This route serves as the entry point for the NocoBase admin interface.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/router.md#_snippet_2

LANGUAGE: ts
CODE:
```
router.add('admin', {
  path: '/admin/*',
  Component: AdminLayout,
});
```

----------------------------------------

TITLE: Registering Admin Layout Route in NocoBase (TypeScript)
DESCRIPTION: This snippet registers the main admin layout route in NocoBase. It maps the `/admin/*` path to the `AdminLayout` component, serving as the base for all backend management pages.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/router.md#_snippet_2

LANGUAGE: ts
CODE:
```
router.add('admin', {
  path: '/admin/*',
  Component: AdminLayout,
});
```

----------------------------------------

TITLE: Defining Password Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to define a password type field named 'password' for a 'users' collection in NocoBase. It uses `scrypt` for encryption and allows specifying `length` and `randomBytesSize` for customization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'password',
      name: 'password',
      length: 64, // Length, default is 64
      randomBytesSize: 8, // Length of random bytes, default is 8
    },
  ],
});
```

----------------------------------------

TITLE: Defining Integer Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet illustrates how to define an integer type field named 'pages' for a 'books' collection in NocoBase. This field is suitable for storing 32-bit integer values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'integer',
      name: 'pages',
    },
  ],
});
```

----------------------------------------

TITLE: Registering Custom Model Class (TypeScript)
DESCRIPTION: This example demonstrates registering a custom data model class, `MyModel`, with the NocoBase database. It also shows how to link this custom model to a collection named 'myCollection' using the `model` property.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/index.md#_snippet_12

LANGUAGE: TypeScript
CODE:
```
import { Model } from '@nocobase/database';

class MyModel extends Model {
  // ...
}

db.registerModels({
  myModel: MyModel,
});

db.collection({
  name: 'myCollection',
  model: 'myModel',
});
```

----------------------------------------

TITLE: Creating Reactive Components with Formily Observer (TSX)
DESCRIPTION: This snippet illustrates the use of Formily's `observer` to create a reactive component (`UsedObserver`) that automatically re-renders when observable data (like form values accessed via `useForm()`) changes. It contrasts this with a non-observer component (`NotUsedObserver`) to highlight the necessity of `observer` for components that need to react to external observable state changes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/extending.md#_snippet_2

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { Input } from 'antd';
import { connect, observer, useForm } from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const SingleText = connect(Input);

const UsedObserver = observer(
  (props) => {
    const form = useForm();
    return <div>UsedObserver: {form.values.t1}</div>;
  },
  { displayName: 'UsedObserver' },
);

const NotUsedObserver = (props) => {
  const form = useForm();
  return <div>NotUsedObserver: {form.values.t1}</div>;
};

const schema = {
  type: 'object',
  properties: {
    t1: {
      type: 'string',
      'x-component': 'SingleText',
    },
    t2: {
      type: 'string',
      'x-component': 'UsedObserver',
    },
    t3: {
      type: 'string',
      'x-component': 'NotUsedObserver',
    },
  },
};

const components = {
  SingleText,
  UsedObserver,
  NotUsedObserver,
};

export default () => {
  return (
    <SchemaComponentProvider components={components}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Rendering Nested Schema with RecursionField (TSX)
DESCRIPTION: This snippet provides a conceptual example of using `<RecursionField />` to render nested schemas. This component is suitable for all schema types, especially when `props.children` nesting is not applicable (e.g., for non-`void` or `object` types), and allows for custom nesting logic within a component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/extending.md#_snippet_3

LANGUAGE: tsx
CODE:
```
<RecursionField schema={schema} onlyRenderProperties />
```

----------------------------------------

TITLE: Fetching and Displaying Page-Specific Configuration Data (TSX)
DESCRIPTION: This TSX snippet defines `PluginSettingsTablePage`, a React component that fetches configuration data specific to a page using NocoBase's `useRequest` hook. It makes a request to `samplesEmailTemplates:list` and displays the fetched JSON data in a `<pre>` tag, demonstrating page-specific data usage without global state synchronization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_20

LANGUAGE: tsx
CODE:
```
import { useRequest } from '@nocobase/client';
import React from 'react';

export const PluginSettingsTablePage = () => {
  const { data, loading } = useRequest<{ data?: any[] }> ({
    url: 'samplesEmailTemplates:list',
  });

  if (loading) return null;

  return <pre>{JSON.stringify(data?.data, null, 2)}</pre>
}
```

----------------------------------------

TITLE: Exporting SchemaInitializer Items (TypeScript)
DESCRIPTION: This snippet exports all components and types from the 'initializer' directory, making the customRefreshActionInitializerItem available for import in other parts of the NocoBase application. This is a standard practice for module organization and reusability.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/configure-actions.md#_snippet_16

LANGUAGE: TypeScript
CODE:
```
export * from './initializer';
```

----------------------------------------

TITLE: Implementing Multi-Tab Plugin Settings in NocoBase (TypeScript)
DESCRIPTION: This TypeScript/TSX snippet demonstrates how to register multiple configuration pages as tabs within a NocoBase plugin's settings using `this.app.pluginSettingsManager.add()`. It defines a main route and nested routes (e.g., `pluginName.pageName`) which appear as distinct tabs, allowing for organized plugin configurations. The `Component` property specifies the React component to render for each tab, with `Outlet` used for parent routes to render nested content.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-setting-page-tabs-routes/index.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Outlet } from 'react-router-dom';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const TokenPage = () => <div>Token Page</div>

const TemplatePage = () => <div>Template Page</div>

export class PluginAddSettingPageTabsRoutesClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Tabs Routes',
      icon: 'ApiOutlined',
      Component: Outlet, // Can be omitted or use a custom component
    });

    this.app.pluginSettingsManager.add(`${name}.token`, {
      title: 'Token Page',
      Component: TokenPage,
      sort: 1,
    });

    this.app.pluginSettingsManager.add(`${name}.template`, {
      title: 'Template Page',
      Component: TemplatePage,
      sort: 2,
    });

    this.app.pluginSettingsManager.add(`${name}.nestedRoute`, {
      title: 'Test',
      Component: Outlet, // Can be omitted or use a custom component
      sort: 3,
    });

    this.app.pluginSettingsManager.add(`${name}.nestedRoute.a`, {
      title: 'Test A',
      Component: () => <div>Test A page</div>
    });

    this.app.pluginSettingsManager.add(`${name}.nestedRoute.b`, {
      title: 'Test B',
      Component: () => <div>Test B page</div>
    });
  }
}

export default PluginAddSettingPageTabsRoutesClient;
```

----------------------------------------

TITLE: Export Image Block Component for Module Access (TypeScript/TSX)
DESCRIPTION: This TypeScript snippet exports the 'Image' component from its module. This makes the 'Image' component accessible to other parts of the plugin or application, allowing it to be imported and used where needed, such as in the plugin's main entry file for registration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-simple.md#_snippet_3

LANGUAGE: tsx
CODE:
```
export * from './Image';
```

----------------------------------------

TITLE: Custom Hook for Dynamic Table Properties
DESCRIPTION: This TypeScript snippet defines `useTableProps`, a custom React hook that dynamically generates properties for a component. It uses `useRequest` to fetch data and returns a `loading` state, which can then be applied to a `MyTable` component via `x-use-component-props`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/what-is-ui-schema.md#_snippet_13

LANGUAGE: typescript
CODE:
```
const useTableProps = () => {
  const service = useRequest({xx});
  return {
    loading: service.loading,
  };
};
```

----------------------------------------

TITLE: Configuring Email Field with UI Schema in TSX
DESCRIPTION: This snippet shows a detailed configuration for an 'email' field, including its data type (`string`), name, and `uiSchema`. The `uiSchema` specifies that it should be rendered using an `Input` component with large size, validated as an email, and set to an 'editable' pattern. It also includes example data and a corresponding React component usage.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/index.md#_snippet_2

LANGUAGE: tsx
CODE:
```
// Email field, displayed with Input component, using email validation rules
{
  type: 'string',
  name: 'email',
  uiSchema: {
    'x-component': 'Input',
    'x-component-props': { size: 'large' },
    'x-validator': 'email',
    'x-pattern': 'editable', // editable state, and readonly state, read-pretty state
  },
}

// Example data
{
  email: 'admin@nocobase.com',
}

// Component example
<Input name={'email'} size={'large'} value={'admin@nocobase.com'} />
```

----------------------------------------

TITLE: Deleting Data via Repository Destroy - JavaScript
DESCRIPTION: This example illustrates how to perform a deletion operation using the `destroy()` method of a `Repository`. It emphasizes that a filtering condition must always be specified to ensure targeted deletion of records.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_16

LANGUAGE: javascript
CODE:
```
await userRepository.destroy({
  filter: {
    status: 'blocked',
  },
});
```

----------------------------------------

TITLE: Exporting Context Hooks for Cross-Plugin Use (TSX)
DESCRIPTION: This snippet illustrates how to export the `useFeatures` and `useFeature` hooks from the plugin's main entry file. This makes these context consumption hooks available for import and use by other NocoBase plugins, enabling shared global state.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/provider/context.md#_snippet_6

LANGUAGE: tsx
CODE:
```
export { useFeatures, useFeature } from './FeaturesProvider';
```

----------------------------------------

TITLE: Authenticate NocoBase Database Connection
DESCRIPTION: Verifies the database connection. This method can be used to ensure that the application and data are connected. It accepts options for retries, transactions, and logging.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
Signature:
auth(options: QueryOptions & { retry?: number } = {}): Promise<boolean>

Parameters:
- name: options?, type: Object, default: -, description: Validation options
- name: options.retry?, type: number, default: 10, description: Number of retries on validation failure
- name: options.transaction?, type: Transaction, default: -, description: Transaction object
- name: options.logging?, type: boolean | Function, default: false, description: Whether to output logs
```

LANGUAGE: TypeScript
CODE:
```
await db.auth();
```

----------------------------------------

TITLE: Register Nocobase Server Notification Channel Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet illustrates how to register the custom server-side notification channel (`ExampleSever`) with the Nocobase server. It extends `Plugin` and uses the `registerChannelType` method of `PluginNotificationManagerServer` to associate the 'example-sms' type with its server-side implementation, enabling the backend to process notifications for this channel.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/notification-manager/extension.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import PluginNotificationManagerServer from '@nocobase/plugin-notification-manager';
import { Plugin } from '@nocobase/server';
import { ExampleSever } from './example-server';

export class PluginNotificationExampleServer extends Plugin {
  async load() {
    const notificationServer = this.pm.get(PluginNotificationManagerServer) as PluginNotificationManagerServer;
    notificationServer.registerChannelType({ type: 'example-sms', Channel: ExampleSever });
  }
}

export default PluginNotificationExampleServer;
```

----------------------------------------

TITLE: Registering Schema Settings in a NocoBase Client Plugin (TypeScript)
DESCRIPTION: This code demonstrates how to register the previously defined `timelineSettings` with the NocoBase application's `schemaSettingsManager` within a client-side plugin's `load` method. This makes the settings available for use in the UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data-modal.md#_snippet_15

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { timelineSettings } from './settings';

export class PluginInitializerBlockDataModalClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(timelineSettings)
  }
}

export default PluginInitializerBlockDataModalClient;
```

----------------------------------------

TITLE: Deleting Records via Repository Destroy - JavaScript
DESCRIPTION: Explains how to delete records from the database using the `destroy()` method of a `Repository`. A `filter` condition must be provided to specify which records to delete.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_22

LANGUAGE: javascript
CODE:
```
await userRepository.destroy({
  filter: {
    status: 'blocked',
  },
});
```

----------------------------------------

TITLE: Starting NocoBase Development Server (Bash)
DESCRIPTION: This command starts the NocoBase development server, allowing you to access the application and test the installed plugins in a local environment. It's typically run after setting up the project and plugins.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/provider/context.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn dev
```

----------------------------------------

TITLE: Adding belongsTo Category Field to Products Collection - TypeScript
DESCRIPTION: This snippet modifies the 'products' collection definition to include a 'category' field. This field is of type 'belongsTo' and targets the 'categories' collection, establishing a many-to-one relationship where multiple products can belong to a single category. This pairs with the 'hasMany' field in the 'categories' collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
{
  name: 'products',
  fields: [
    // ...
    {
      type: 'belongsTo',
      name: 'category',
      target: 'categories',
    }
  ]
}
```

----------------------------------------

TITLE: Starting NocoBase Development Server (Bash)
DESCRIPTION: This bash command initiates the NocoBase development server, which compiles and serves the application, allowing developers to access and test their NocoBase project and plugins locally.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/global.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn dev
```

----------------------------------------

TITLE: Starting NocoBase Development Server - Bash
DESCRIPTION: This command starts the NocoBase project in development mode, typically making the application accessible via a local URL (e.g., http://localhost:13000).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/form.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn dev
```

----------------------------------------

TITLE: Example of Using NocoBase useRequest() Hook (JavaScript)
DESCRIPTION: This example demonstrates how to use the `useRequest` hook to fetch data from `/users`. It shows destructuring common return values like `data`, `loading`, `refresh`, `run`, and `params`, and also how to dynamically run the request with new parameters.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/api-client.md#_snippet_8

LANGUAGE: js
CODE:
```
const { data, loading, refresh, run, params } = useRequest({ url: '/users' });

// Since useRequest accepts AxiosRequestConfig, the run function also accepts AxiosRequestConfig.
run({
  params: {
    pageSize: 20,
  },
});
```

----------------------------------------

TITLE: Finding Records with Filter - TypeScript
DESCRIPTION: Illustrates how to use the `filter` option in the `find()` method to query records based on specific conditions, including equality and operator-based comparisons (e.g., `$gt` for greater than).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_25

LANGUAGE: typescript
CODE:
```
// Find records with name "foo" and age above 18
repository.find({
  filter: {
    name: 'foo',
    age: {
      $gt: 18,
    },
  },
});
```

----------------------------------------

TITLE: Define Product Data Model Schema for Nocobase
DESCRIPTION: Defines the schema for the Product collection, including fields for product name, price, and inventory. This model is essential for storing product details and is referenced by the Order collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow/triggers/collection.md#_snippet_0

LANGUAGE: JSON
CODE:
```
{
  "Product": {
    "Product Name": { "type": "Single Line Text" },
    "Price": { "type": "Number" },
    "Inventory": { "type": "Integer" }
  }
}
```

----------------------------------------

TITLE: Integrating Ant Design Input with Formily Connect in NocoBase Schema (TypeScript)
DESCRIPTION: This example illustrates how to integrate a third-party component (Ant Design `Input`) into the NocoBase Schema using Formily's `connect`, `mapProps`, and `mapReadPretty`. It customizes the input with a suffix and provides a read-only view, then registers and uses it within the schema for both editable and read-only patterns.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/extending.md#_snippet_1

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { Input } from 'antd';
import { connect, mapProps, mapReadPretty } from '@formily/react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const ReadPretty = (props) => {
  return <div>{props.value}</div>;
};

const SingleText = connect(
  Input,
  mapProps((props, field) => {
    return {
      ...props,
      suffix: 'Suffix'
    };
  }),
  mapReadPretty(ReadPretty)
);

const schema = {
  type: 'object',
  properties: {
    t1: {
      type: 'string',
      default: 'hello t1',
      'x-component': 'SingleText'
    },
    t2: {
      type: 'string',
      default: 'hello t2',
      'x-component': 'SingleText',
      'x-pattern': 'readPretty'
    }
  }
};

export default () => {
  return (
    <SchemaComponentProvider components={{ SingleText }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Finding Records by TargetKey (Primary Key) - TypeScript
DESCRIPTION: This snippet illustrates the use of `filterByTk` as a shortcut for the `filter` parameter in the `find()` method. By default, `filterByTk` queries records using the primary key, providing a concise way to retrieve a single record by its identifier.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_20

LANGUAGE: typescript
CODE:
```
// By default, find records with id 1
repository.find({
  filterByTk: 1,
});
```

----------------------------------------

TITLE: NocoBase Repository Filter Parameter Usage
DESCRIPTION: This snippet demonstrates how to use filter operators within the `filter` parameter of NocoBase Repository's `find` API. NocoBase identifies query operators with a '$' prefix for JSON serialization. For extending operators, refer to `db.registerOperators()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/operators.md#_snippet_0

LANGUAGE: ts
CODE:
```
const repository = db.getRepository('books');

repository.find({
  filter: {
    title: {
      $eq: '春秋',
    },
  },
});
```

----------------------------------------

TITLE: Appending Associated Fields in Repository Queries in NocoBase
DESCRIPTION: Demonstrates using the `appends` parameter to include data from associated objects in the query result, allowing for retrieval of related information.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/repository.md#_snippet_6

LANGUAGE: javascript
CODE:
```
// The result contains data associated with the posts object
userRepository.find({
  appends: ['posts'],
});
```

----------------------------------------

TITLE: Defining Standalone and Associated Resources in NocoBase (TypeScript)
DESCRIPTION: This snippet illustrates how to define both standalone (`posts`) and associated (`posts.user`, `posts.coments`) resources in NocoBase. Associated resources represent relationships (e.g., an article's author or comments) and are defined using dot notation, simplifying the management of related data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
// Equivalent to app.resourcer.define()

// Define article resources
app.resource({
  name: 'posts',
});

// Define the article's author resource
app.resource({
  name: 'posts.user',
});

// Define the article's comment resource
app.resource({
  name: 'posts.coments',
});
```

----------------------------------------

TITLE: Implement NocoBase FormV3 Block Component with React and Formily
DESCRIPTION: This TypeScript React component defines the `FormV3` block, wrapping `@formily/antd-v5`'s Form with NocoBase's `withDynamicSchemaProps` Higher-Order Component. It sets a default layout and prepares the component for dynamic schema properties, enabling flexible UI configuration and integration within the NocoBase ecosystem.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import React, { FC } from 'react';
import { Form, FormProps } from '@formily/antd-v5';
import { withDynamicSchemaProps } from '@nocobase/client';
import { FormV3BlockName } from './constants';

export interface FormV3Props extends FormProps {
  children?: React.ReactNode;
}

export const FormV3: FC<FormV3Props> = withDynamicSchemaProps((props) => {
  return <Form {...props} layout={props.layout || 'vertical'} />;
}, { displayName: FormV3BlockName });
```

----------------------------------------

TITLE: Modify Schema with useFieldSchema and useDesignable (TypeScript)
DESCRIPTION: This snippet shows how to enhance the useComponentProps function to dynamically manage the "showIndex" property. It utilizes useFieldSchema to access the current field's schema and useDesignable to modify it. The onChange handler updates the x-decorator-props.showIndex value, ensuring the UI reflects the schema changes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-settings/add-item.md#_snippet_2

LANGUAGE: typescript
CODE:
```
import { SchemaSettingsItemType, useDesignable } from '@nocobase/client';
import { useFieldSchema } from '@formily/react';

export const tableShowIndexSettingsItem: SchemaSettingsItemType = {
  name: 'showIndex',
  type: 'switch',
  useComponentProps() {
    const fieldSchema = useFieldSchema();
    const dn = useDesignable();
    return {
      title: 'Show Index',
      checked: !!fieldSchema['x-decorator-props'].showIndex,
      onChange(v: boolean) {
        dn.deepMerge({
          'x-uid': fieldSchema['x-uid'],
          'x-decorator-props': {
            ...fieldSchema['x-decorator-props'],
            showIndex: v,
          },
        });
      },
    };
  },
};
```

----------------------------------------

TITLE: Helper Functions for Field Schema Generation and Item Initialization (TSX)
DESCRIPTION: This snippet defines two helper functions: `getInfoItemSchema` which returns a basic schema for a collection field, identified by `x-collection-field`, and `getFieldInitializerItem` which generates a `SchemaInitializerItemType`. The `getFieldInitializerItem` function determines if a field schema exists and, based on its presence, either removes it using `remove` or inserts a new one using `insert`, effectively implementing the switch functionality.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_1

LANGUAGE: TSX
CODE:
```
function getInfoItemSchema(collectionFieldName: string) {
  return {
     type: 'void',
    'x-collection-field': collectionFieldName,
    // TODO
  }
}

interface GetFieldInitializerItemOptions {
  collectionField: CollectionFieldOptions;
  schema: ISchema;
  remove: (schema: ISchema) => void;
  insert: (schema: ISchema) => void;
}

function getFieldInitializerItem(options: GetFieldInitializerItemOptions) {
  const { collectionField, schema, remove, insert } = options;
  const title = collectionField.uiSchema?.title || collectionField.name;
  const name = collectionField.name;
  const collectionFieldSchema = Object.values(schema.properties || {}).find((item) => item['x-collection-field'] === name);
  return {
    name,
    type: 'switch',
    title,
    checked: !!collectionFieldSchema,
    onClick() {
      if (collectionFieldSchema) {
        remove(collectionFieldSchema)
        return;
      }
      insert(getInfoItemSchema(name))
    }
  } as SchemaInitializerItemType;
```

----------------------------------------

TITLE: Define an ACL Role in NocoBase
DESCRIPTION: This method defines a new role within the NocoBase ACL system. It allows specifying the role's unique identifier, its global access strategy, specific action permissions, and associated snippets. The method returns an ACLRole object.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/acl/acl.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
### `define()`

Defines a role.

#### Signature

- `define(options: DefineOptions): ACLRole`

#### Types

```ts
export interface DefineOptions {
  role: string;
  strategy?: string | AvailableStrategyOptions;
  actions?: ResourceActionsOptions;
  snippets?: string[];
}

export interface AvailableStrategyOptions {
  displayName?: string;
  actions?: false | string | string[];
  allowConfigure?: boolean;
  resource?: '*';
}

export interface ResourceActionsOptions {
  [actionName: string]: RoleActionParams;
}

export interface RoleActionParams {
  fields?: string[];
  filter?: any;
  own?: boolean;
  whitelist?: string[];
  blacklist?: string[];
}
```

#### Details

##### DefineOptions

| Property   | Type                                                                | Description                                                                     |
| ---------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `role`     | `string`                                                            | Unique role identifier                                                          |
| `strategy` | `string` | [`AvailableStrategyOptions`](#availablestrategyoptions) | Optional, global access strategy for the role, can be a strategy identifier or configuration. |
| `actions`  | [`{ [actionName: string]: RoleActionParams; }`](#roleactionparams)  | Optional, permission configuration for actions                                  |
| `snippets` | `string[]`                                                          | Optional, defines snippets the role has permissions for                         |

##### AvailableStrategyOptions

| Property         | Type                              | Description                               |
| ---------------- | --------------------------------- | ----------------------------------------- |
| `displayName`    | `string`                          | Optional, strategy display title          |
| `action`         | `false` | `string` | `string[]` | Optional, operation interface             |
| `allowConfigure` | `boolean`                         | Optional, whether to allow configuring the user interface |
| `resource`       | `*`                               | Indicates it applies to all resources     |

##### RoleActionParams

| Property    | Type       | Description                                                                                             |
| ----------- | ---------- | ------------------------------------------------------------------------------------------------------- |
| `fields`    | `string[]` | Optional, data table fields to operate on                                                               |
| `filter`    | `any`      | Optional, filter parameters that must be met, operations can only be performed on records that meet the conditions |
| `own`       | `boolean`  | Optional, whether only records created by oneself can be operated                                       |
| `whitelist` | `string[]` | Optional, field whitelist, only fields in the list can be accessed                                      |
| `blacklist` | `string[]` | Optional, field blacklist, fields in the list cannot be accessed                                        |
```

----------------------------------------

TITLE: Creating Data with Repository create() in TypeScript
DESCRIPTION: This example demonstrates how to use the `create()` method to insert a new record into the database. It also illustrates how to handle related data, either by updating existing related records or creating new ones based on the provided values.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/repository.md#_snippet_9

LANGUAGE: ts
CODE:
```
const posts = db.getRepository('posts');

const result = await posts.create({
  values: {
    title: 'NocoBase 1.0 发布日志',
    tags: [
      // 有关系表主键值时为更新该条数据
      { id: 1 },
      // 没有主键值时为创建新数据
      { name: 'NocoBase' },
    ],
  },
});
```

----------------------------------------

TITLE: Initializing NocoBase Application - Bash
DESCRIPTION: This `bash` snippet guides the user through setting up a new NocoBase project. It includes commands to create the application, navigate into its directory, install necessary dependencies, and perform the initial NocoBase installation with SQLite.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/action-simple.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

----------------------------------------

TITLE: NocoBase TS: Register Global Data Provider
DESCRIPTION: This code demonstrates how to register the `PluginSettingsTableProvider` globally within a NocoBase plugin. By adding the provider to `this.app.addProvider()`, the global settings data context becomes accessible throughout the entire application, enabling real-time data updates.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/plugin-settings/table.md#_snippet_17

LANGUAGE: ts
CODE:
```
import { PluginSettingsTableProvider } from './PluginSettingsTableProvider'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...
    this.app.addProvider(PluginSettingsTableProvider)
  }
}
```

----------------------------------------

TITLE: Using branch() for Authentication in NocoBase TypeScript
DESCRIPTION: This snippet demonstrates how to integrate the `branch()` middleware into a NocoBase application's resourcer. It dynamically selects an authentication handler ('password' or 'sms') based on the `authenticator` parameter found in the request context, defaulting to 'password' if the parameter is not provided. Each handler is an asynchronous function that would contain specific authentication logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/middleware.md#_snippet_4

LANGUAGE: ts
CODE:
```
app.resourcer.use(
  branch(
    {
      password: async (ctx, next) => {
        // ...
      },
      sms: async (ctx, next) => {
        // ...
      }
    },
    (ctx) => {
      return ctx.action.params.authenticator ?? 'password';
    }
  )
);
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Creation Events (TypeScript)
DESCRIPTION: These events are triggered before and after data creation. They are invoked when `repository.create()` is called. Use these hooks to perform actions or modify data during the creation process, such as setting default values or logging.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_15

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.beforeCreate` | 'beforeCreate' | `${string}.afterCreate` | 'afterCreate', listener: CreateListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { CreateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type CreateListener = (
  model: Model,
  options?: CreateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeCreate', async (model, options) => {
  // 何かを行う
});

db.on('books.afterCreate', async (model, options) => {
  const { transaction } = options;
  const result = await model.constructor.findByPk(model.id, {
    transaction,
  });
  console.log(result);
});
```

----------------------------------------

TITLE: Explicitly Defining a Resource and its Actions in NocoBase (TypeScript)
DESCRIPTION: This TypeScript snippet shows how to explicitly define a resource and its standard CRUD actions using `app.resourcer.define`. This method is useful for scenarios requiring fine-grained control over resource definitions beyond automatic conversion.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions-v2/configuration.md#_snippet_5

LANGUAGE: ts
CODE:
```
app.resourcer.define({
  name: 'posts',
  actions: {
    create: {},
    get: {},
    list: {},
    update: {},
    destroy: {},
  },
});
```

----------------------------------------

TITLE: Starting NocoBase Application for Development and Production
DESCRIPTION: These commands are used to start the NocoBase application. `yarn dev` is for development with hot-reloading, while `yarn build` followed by `yarn start` is for production environments after a full build.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/your-fisrt-plugin.md#_snippet_6

LANGUAGE: bash
CODE:
```
yarn dev

# for production
yarn build
yarn start
```

----------------------------------------

TITLE: Defining Custom Resource with Asynchronous Action in NocoBase (TypeScript)
DESCRIPTION: This snippet defines a custom `notifications` resource with an asynchronous `send` action. This action processes the request body using an external `someProvider` and then calls `next()` to continue the middleware chain, demonstrating how to handle non-database-backed resources.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
app.resource({
  name: 'notifications',
  actions: {
    async send(ctx, next) {
      await someProvider.send(ctx.request.body);
      next();
    },
  },
});
```

----------------------------------------

TITLE: Using useCollectionManager Hook (JSX)
DESCRIPTION: This snippet demonstrates the usage of the `useCollectionManager` hook. It is designed to be used within a component wrapped by `CollectionManagerProvider` and provides access to the `collections` array and a `get` function for retrieving specific collections from the context.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/client/extensions/collection-manager.md#_snippet_6

LANGUAGE: jsx
CODE:
```
const { collections, get } = useCollectionManager();
```

----------------------------------------

TITLE: Creating NocoBase App (Stable, MariaDB)
DESCRIPTION: This command initializes a new NocoBase project using the latest stable version, configured for a MariaDB database. It sets essential database connection parameters and timezone via environment variables.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/getting-started/installation/create-nocobase-app.md#_snippet_4

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d mariadb \
   -e DB_HOST=localhost \
   -e DB_PORT=3306 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=UTC \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: Initialize NocoBase Plugin for Data Block Development
DESCRIPTION: This snippet outlines the steps to set up a NocoBase project and initialize a new plugin. It covers creating a new application, installing dependencies, and enabling the custom data block plugin, preparing the environment for development.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
yarn pm create @nocobase-sample/plugin-initializer-block-data
yarn pm enable @nocobase-sample/plugin-initializer-block-data
yarn dev
```

----------------------------------------

TITLE: Install and Start NocoBase with Docker Compose (Bash)
DESCRIPTION: These Bash commands provide the steps to install and start NocoBase using Docker Compose. First, `docker-compose pull` fetches the latest images, then `docker-compose up -d` starts the services in the background. Finally, `docker-compose logs app` allows you to monitor the application's startup process and confirm it's running, typically on `http://localhost:13000/`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/welcome/getting-started/installation/docker-compose.md#_snippet_2

LANGUAGE: bash
CODE:
```
# 拉取最新镜像
$ docker-compose pull
# 在后台运行
$ docker-compose up -d
# 查看 app 进程的情况
$ docker-compose logs app

app-postgres-app-1  | nginx started
app-postgres-app-1  | yarn run v1.22.15
app-postgres-app-1  | $ cross-env DOTENV_CONFIG_PATH=.env node -r dotenv/config packages/app/server/lib/index.js install -s
app-postgres-app-1  | Done in 2.72s.
app-postgres-app-1  | yarn run v1.22.15
app-postgres-app-1  | $ pm2-runtime start --node-args="-r dotenv/config" packages/app/server/lib/index.js -- start
app-postgres-app-1  | 2022-04-28T15:45:38: PM2 log: Launching in no daemon mode
app-postgres-app-1  | 2022-04-28T15:45:38: PM2 log: App [index:0] starting in -fork mode-
app-postgres-app-1  | 2022-04-28T15:45:38: PM2 log: App [index:0] online
app-postgres-app-1  | 🚀 NocoBase server running at: http://localhost:13000/
```

----------------------------------------

TITLE: Creating NocoBase App (Stable, PostgreSQL)
DESCRIPTION: This command initializes a new NocoBase project using the latest stable version, configured for a PostgreSQL database. It sets essential database connection parameters and timezone via environment variables.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/getting-started/installation/create-nocobase-app.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d postgres \
   -e DB_HOST=localhost \
   -e DB_PORT=5432 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=UTC \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: Initializing NocoBase Application (Bash)
DESCRIPTION: This snippet provides the bash commands to create a new NocoBase application named `my-nocobase-app` with SQLite, navigate into its directory, install dependencies, and perform the initial NocoBase installation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/global.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

----------------------------------------

TITLE: Registering Middleware in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register different types of middleware within a NocoBase plugin's `load` method. It shows the registration of resource-permission-level (`app.acl.use()`), resource-level (`app.resourcer.use()`), and application-level (`app.use()`) middlewares, each serving a specific purpose in the request lifecycle.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/middleware.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export class MyPlugin extends Plugin {
  load() {
    this.app.acl.use();
    this.app.resourcer.use();
    this.app.use();
  }
}
```

----------------------------------------

TITLE: Destroying Associated Object with HasOneRepository.destroy() - TypeScript
DESCRIPTION: This example demonstrates the `destroy()` method, which deletes the associated object from the database. After `destroy()`, `find()` returns `null`, and the count of records in the `Profile` collection becomes zero, indicating the object has been permanently removed.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/relation-repository/has-one-repository.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
await UserProfileRepository.destroy();
(await UserProfileRepository.find()) == null; // true
(await Profile.repository.count()) === 0; // true
```

----------------------------------------

TITLE: Setting Associated Objects - HasManyRepository - TypeScript
DESCRIPTION: Sets the associated object(s) for the current relationship, replacing any existing associations. This method utilizes the same parameters as the `add()` method.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/has-many-repository.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
async set(options: TargetKey | TargetKey[] | AssociatedOptions)
```

----------------------------------------

TITLE: Initializing RelationRepository Constructor in TypeScript
DESCRIPTION: Initializes a new instance of `RelationRepository`. This constructor takes the source collection, the association name, and the key value of the source record to establish the context for relation operations. It sets up the repository to manage associated data for a specific record within a collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/relation-repository/index.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
constructor(sourceCollection: Collection, association: string, sourceKeyValue: string | number)
```

----------------------------------------

TITLE: Using React Hooks for Internationalization - TypeScript
DESCRIPTION: This snippet illustrates the use of React hooks (`useApp` and `useTranslation`) for internationalization within NocoBase client components. It shows how to get the `i18n` instance from `useApp` and how to use `useTranslation` with a specific namespace to retrieve translated strings. The example also provides the equivalent `i18n.t` call for clarity.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/i18n.md#_snippet_2

LANGUAGE: ts
CODE:
```
import { useApp } from '@nocobase/client';
import { useTranslation } from 'react-i18next';

const { i18n } = useApp();
const { t } = useTranslation('@nocobase/plugin-sample-i18n');
t('hello');
// Equivalent to
i18n.t('hello', { ns: '@nocobase/plugin-sample-i18n' });
```

----------------------------------------

TITLE: Defining Base Schema Settings for QRCode Component (TypeScript)
DESCRIPTION: This TypeScript code defines the initial `SchemaSettings` object for the `QRCode` component, named `fieldSettings:component:QRCode`. It serves as the container for various configuration items that will be added later to control the component's properties. Dependencies include `@nocobase/client` for `SchemaSettings` and local `tStr`, `useT` modules.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/value.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import { createModalSettingsItem, createSelectSchemaSettingsItem, createSwitchSettingsItem, SchemaSettings } from "@nocobase/client";

import { tStr, useT } from './locale';

export const qrCodeComponentFieldSettings = new SchemaSettings({
  name: 'fieldSettings:component:QRCode',
  items: [
    // TODO
  ]
});
```

----------------------------------------

TITLE: Checking ACL Permissions (TypeScript)
DESCRIPTION: These interfaces define the input arguments and expected output for the `can()` method, which determines if a role has permission to execute a specific action on a resource. `CanArgs` specifies the role, resource, action, and optional context, while `CanResult` provides the details of the granted permission, including any associated parameters.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/acl/acl.md#_snippet_1

LANGUAGE: typescript
CODE:
```
interface CanArgs {
  role: string;
  resource: string;
  action: string;
  ctx?: any;
}

interface CanResult {
  role: string;
  resource: string;
  action: string;
  params?: any;
}
```

----------------------------------------

TITLE: Implement QRCode Editable Component in React
DESCRIPTION: This snippet defines the "QRCodeEditable" React functional component, designed for the editable mode of the QR code field. It integrates "AntdQRCode" for displaying the QR code and "Input.URL" for user input, automatically receiving "value", "disabled", and "onChange" props from the NocoBase framework.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/value.md#_snippet_2

LANGUAGE: TSX
CODE:
```
import React, { FC } from 'react';
import { Input } from '@nocobase/client';
import { QRCode as AntdQRCode, Space, QRCodeProps as AntdQRCodeProps } from 'antd';

interface QRCodeProps extends AntdQRCodeProps {
  onChange: (value: string) => void;
  disabled?: boolean;
}

const QRCodeEditable: FC<QRCodeProps> = ({ value, disabled, onChange, ...otherProps }) => {
  return <Space direction="vertical" align="center">
    <AntdQRCode value={value || '-'} {...otherProps} />
    <Input.URL
      maxLength={60}
      value={value}
      disabled={disabled}
      onChange={(e) => onChange(e.target.value)}
    />
  </Space>;
}
```

----------------------------------------

TITLE: Register QRCode Schema Settings in NocoBase Client Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the `qrCodeComponentFieldSettings` with the NocoBase client application's schema settings manager. By calling `this.schemaSettingsManager.add(qrCodeComponentFieldSettings)` within the plugin's `load` method, the defined settings become available for use in the NocoBase administration interface, allowing users to configure the `QRCode` component's properties.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/value.md#_snippet_9

LANGUAGE: ts
CODE:
```
// ...
import { qrCodeComponentFieldSettings } from './settings';

export class PluginFieldComponentValueClient extends Plugin {
  async load() {
    // ...
    this.schemaSettingsManager.add(qrCodeComponentFieldSettings);
  }
}
```

----------------------------------------

TITLE: Adding Custom Action Initializers to NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to extend a NocoBase client plugin to add custom action initializers. It imports `createDocumentActionInitializerItem` and registers new items for 'table:configureActions', 'details:configureActions', and 'createForm:configureActions' using the `schemaInitializerManager`, enabling custom actions in different UI blocks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/action-simple.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { useDocumentActionProps } from './schema';
import { documentActionSettings } from './settings';
+ import { createDocumentActionInitializerItem } from './initializer';

export class PluginInitializerActionSimpleClient extends Plugin {
  async load() {
    this.app.addScopes({ useDocumentActionProps });
    this.app.schemaSettingsManager.add(documentActionSettings);
+   this.app.schemaInitializerManager.addItem('table:configureActions', 'document', createDocumentActionInitializerItem('table-v2'));
+   this.app.schemaInitializerManager.addItem('details:configureActions', 'document', createDocumentActionInitializerItem('details'));
+   this.app.schemaInitializerManager.addItem('createForm:configureActions', 'document', createDocumentActionInitializerItem('form-v2'));
  }
}

export default PluginInitializerActionSimpleClient;
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Client Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the previously defined `infoSettings` within a NocoBase client plugin. Inside the `load` method of `PluginInitializerBlockDataClient`, `this.app.schemaSettingsManager.add(infoSettings)` is called to make the schema settings available to the application, enabling configuration options for the custom data block.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-data.md#_snippet_10

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { infoSettings } from './settings';

export class PluginInitializerBlockDataClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(infoSettings)
  }
}

export default PluginInitializerBlockDataClient;
```

----------------------------------------

TITLE: Creating Collection Resources using NocoBase HTTP API
DESCRIPTION: This snippet demonstrates how to create a new collection resource using NocoBase's custom HTTP API. It uses a POST request to the `/api/<collection>:create` endpoint with an empty JSON body.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/http/rest-api.md#_snippet_0

LANGUAGE: bash
CODE:
```
POST  /api/<collection>:create

{} # JSON body
```

----------------------------------------

TITLE: Synchronizing NocoBase Collection to Database (TypeScript)
DESCRIPTION: This method synchronizes the definition of a data table collection to the database. It extends Sequelize's default sync logic to also handle relational fields. It returns a Promise<void>, indicating an asynchronous operation. The example demonstrates synchronizing a 'posts' collection.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/collection.md#_snippet_13

LANGUAGE: TypeScript
CODE:
```
const posts = db.collection({
  name: 'posts',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
  ],
});

await posts.sync();
```

----------------------------------------

TITLE: Defining NocoBase Frontend UI Schema for Data Table (TypeScript)
DESCRIPTION: This TypeScript snippet defines the frontend UI schema for the 'samplesEmailTemplates' data table. It maps backend fields ('subject', 'content') to their corresponding frontend interface types ('input', 'richText') and UI components ('Input', 'RichText') with titles and required validations, enabling form rendering.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_9

LANGUAGE: ts
CODE:
```
const emailTemplatesCollection = {
  name: 'samplesEmailTemplates',
  filterTargetKey: 'id',
  fields: [
    {
      type: 'string',
      name: 'subject',
      interface: 'input',
      uiSchema: {
        title: 'Subject',
        required: true,
        'x-component': 'Input',
      },
    },
    {
      type: 'text',
      name: 'content',
      interface: 'richText',
      uiSchema: {
        title: 'Content',
        required: true,
        'x-component': 'RichText',
      },
    },
  ],
};
```

----------------------------------------

TITLE: Defining Deliveries Collection Schema (TypeScript)
DESCRIPTION: This snippet defines the schema for a new 'deliveries' collection. It includes fields for associating with an 'order', 'provider', 'trackingNumber', and 'status', serving as a prerequisite for custom shipping actions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/resources-actions.md#_snippet_10

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'deliveries',
  fields: [
    {
      type: 'belongsTo',
      name: 'order',
    },
    {
      type: 'string',
      name: 'provider',
    },
    {
      type: 'string',
      name: 'trackingNumber',
    },
    {
      type: 'integer',
      name: 'status',
    },
  ],
};
```

----------------------------------------

TITLE: NocoBase API Appends Parameter for Including Related Fields
DESCRIPTION: The `appends` parameter is used in query operations to include related fields in the output. This allows for fetching associated data along with the main resource in a single request.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/http-api/index.md#_snippet_13

LANGUAGE: APIDOC
CODE:
```
Used to include related fields in the query results.
Example: GET /api/posts:get/1?appends=comments,tags
```

----------------------------------------

TITLE: Example: Finding All Schema Nodes with findProperties (TypeScript)
DESCRIPTION: Demonstrates how to use `findProperties` to find all schema nodes where `x-component` is 'Hello'. It shows the input filter and the expected output array of schema objects.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/designable.md#_snippet_7

LANGUAGE: ts
CODE:
```
const items = dn.findProperties({
  filter: {
    'x-component': 'Hello',
  },
});
// [current.properties.hello1, current.properties.hello2]
console.log(items.map((s) => schema.toJSON()));
[
  {
    name: 'hello1',
    type: 'void',
    'x-component': 'Hello',
  },
  {
    name: 'hello2',
    type: 'void',
    'x-component': 'Hello',
  },
];
```

----------------------------------------

TITLE: Filtering by Equality ($eq) in NocoBase - TypeScript
DESCRIPTION: Illustrates the use of the `$eq` operator to find records where the `title` field exactly matches 'Spring and Autumn'. This operator checks for equality, similar to SQL's `=`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/operators.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    title: {
      $eq: 'Spring and Autumn',
    },
  },
});
```

----------------------------------------

TITLE: Defining Schema Settings for NocoBase Block (TypeScript)
DESCRIPTION: This snippet defines a new `SchemaSettings` instance named `orderDetailsSettings`. This object will hold configuration items for a specific block, identified by `blockSettings:${FieldNameLowercase}`. Although the `items` array is currently empty, it serves as the foundation for adding various configuration options for the custom block.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/without-value.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettings } from "@nocobase/client";
import { FieldNameLowercase } from '../constants';
import { orderFieldSchemaSettingsItem } from "./items/orderField";

export const orderDetailsSettings = new SchemaSettings({
  name: `blockSettings:${FieldNameLowercase}`,
  items: [
    // TODO
  ]
});
```

----------------------------------------

TITLE: Updating Collection Resource - NocoBase API (HTTP & REST)
DESCRIPTION: Explains how to update an existing collection resource by its primary key. The NocoBase HTTP API uses POST with a `:update` suffix, while the REST API uses PUT. Both methods require a JSON body containing the update data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions-v2/rest-api.md#_snippet_3

LANGUAGE: bash
CODE:
```
POST   /api/<collection>:update?filterByTk=<collectionIndex>

{} # JSON body

# 或者
POST   /api/<collection>:update/<collectionIndex>

{} # JSON body
```

LANGUAGE: bash
CODE:
```
PUT    /api/<collection>/<collectionIndex>

{} # JSON body
```

----------------------------------------

TITLE: Creating Collection Resources - NocoBase HTTP API
DESCRIPTION: This snippet demonstrates how to create a new collection resource using NocoBase's custom HTTP API. It requires a POST request to the specified endpoint with a JSON body containing the resource data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/http/rest-api.md#_snippet_0

LANGUAGE: bash
CODE:
```
POST  /api/<collection>:create

{} # JSON body
```

----------------------------------------

TITLE: TypeScript: Implement Collection Fields Initializer for Forms
DESCRIPTION: This code shows how to implement the `Configure fields` item by utilizing `CollectionFieldsToFormInitializerItems`. It modifies `packages/plugins/@nocobase-sample/plugin-block-form/src/client/FormV3.configFields/index.ts` to convert data table fields into `Initializer` child items, providing a unique identifier for the collection fields.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_21

LANGUAGE: TypeScript
CODE:
```
import { gridRowColWrap, SchemaInitializer, CollectionFieldsToFormInitializerItems } from "@nocobase/client";

export const formV3ConfigureFieldsInitializer = new SchemaInitializer({
  name: `${FormV3BlockNameLowercase}:configureFields`,
  icon: 'SettingOutlined',
  wrap: gridRowColWrap,
  title: tStr('Configure fields'),
  items: [
    {
      name: 'collectionFields',
      Component: CollectionFieldsToFormInitializerItems,
    },
  ]
});
```

----------------------------------------

TITLE: Extending NocoBase CLI with Custom Commands in Application (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to add a custom command, 'hello', to the NocoBase CLI directly within the application's `app/server/index.ts` file. It utilizes the `app.command().action()` method to define new command-line functionalities for the application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/cli.md#_snippet_2

LANGUAGE: typescript
CODE:
```
const app = new Application(config);

app.command('hello').action(() => {});
```

----------------------------------------

TITLE: Importing Collections and Setting ACL in a NocoBase Plugin
DESCRIPTION: This code demonstrates how a NocoBase plugin's main class (`ShopPlugin`) imports collection definitions during its `load()` lifecycle. It uses `this.db.import()` to load all collections from a specified `directory` (e.g., `collections`). Additionally, it sets broad ACL permissions for `products`, `categories`, and `orders` tables, allowing all actions for testing purposes, which can be refined later.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/collections-fields.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import path from 'path';
import { Plugin } from '@nocobase/server;

export default class ShopPlugin extends Plugin {
  async load() {
    await this.db.import({
      directory: path.resolve(__dirname, 'collections'),
    });

    this.app.acl.allow('products', '*');
    this.app.acl.allow('categories', '*');
    this.app.acl.allow('orders', '*');
  }
}
```

----------------------------------------

TITLE: Implement NocoBase SchemaSettings Item for Lazy Loading in TypeScript
DESCRIPTION: This TypeScript snippet defines a SchemaSettings Item named 'lazy' that allows users to toggle lazy loading for image blocks. It uses a 'switch' type component and NocoBase's designable context to update the schema's 'x-decorator-props' with a boolean value based on the switch state.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-settings/new.md#_snippet_14

LANGUAGE: ts
CODE:
```
import { SchemaSettingsItemType, useDesignable } from "@nocobase/client";
import { useFieldSchema } from '@formily/react';
import { useT } from "../../locale";
import { BlockNameLowercase } from "../../constants";

export const lazySchemaSettingsItem: SchemaSettingsItemType = {
  name: 'lazy',
  type: 'switch',
  useComponentProps() {
    const filedSchema = useFieldSchema();
    const { deepMerge } = useDesignable();
    const t = useT();

    return {
      title: t('Lazy'),
      checked: !!filedSchema['x-decorator-props']?.[BlockNameLowercase]?.lazy,
      onChange(v) {
        deepMerge({
          'x-uid': filedSchema['x-uid'],
          'x-decorator-props': {
            ...filedSchema['x-decorator-props'],
            [BlockNameLowercase]: {
              ...filedSchema['x-decorator-props']?.[BlockNameLowercase],
              lazy: v,
            },
          },
        });
      },
    };
  },
};
```

----------------------------------------

TITLE: Registering a Global NocoBase Provider (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the `PluginSettingsTableProvider` globally within a NocoBase plugin's client-side `load` method. By calling `this.app.addProvider()`, the provider becomes accessible throughout the NocoBase application, ensuring that the global configuration data can be consumed by any component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_23

LANGUAGE: ts
CODE:
```
import { PluginSettingsTableProvider } from './PluginSettingsTableProvider'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...
    this.app.addProvider(PluginSettingsTableProvider)
  }
}
```

----------------------------------------

TITLE: Updating Data with NocoBase Repository (TypeScript)
DESCRIPTION: This snippet demonstrates how to update data in a NocoBase repository using the `update()` method. It shows updating a record by its primary key (`filterByTk`) and simultaneously managing related `tags` data, either updating existing tags by `id` or creating new ones if no `id` is provided. This is equivalent to Sequelize's `Model.update()` with relation handling.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/repository.md#_snippet_12

LANGUAGE: TypeScript
CODE:
```
const posts = db.getRepository('posts');

const result = await posts.update({
  filterByTk: 1,
  values: {
    title: 'NocoBase 1.0 发布日志',
    tags: [
      // 有关系表主键值时为更新该条数据
      { id: 1 },
      // 没有主键值时为创建新数据
      { name: 'NocoBase' }
    ]
  }
});
```

----------------------------------------

TITLE: Configure Database Connections with Nocobase Database
DESCRIPTION: This snippet demonstrates how to initialize a Database instance in Nocobase. It shows configuration parameters for both SQLite and MySQL/PostgreSQL, allowing users to connect to different database types by passing appropriate options to the constructor.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database');

// SQLite データベース設定パラメータ
const database = new Database({
  dialect: 'sqlite',
  storage: 'path/to/database.sqlite'
})

// MySQL \ PostgreSQL データベース設定パラメータ
const database = new Database({
  dialect: /* 'postgres' または 'mysql' */,
  database: 'database',
  username: 'username',
  password: 'password',
  host: 'localhost',
  port: 'port'
})
```

----------------------------------------

TITLE: Defining Collections for Automatic Resource Conversion in NocoBase (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to define collections within a NocoBase plugin. When collections like 'posts' and 'comments' are defined, NocoBase automatically converts them into corresponding resources, enabling standard CRUD operations via generated APIs.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions-v2/configuration.md#_snippet_0

LANGUAGE: ts
CODE:
```
export class PluginSampleToResourcesServer extends Plugin {
  async load() {
    this.db.collection({
      name: 'posts',
      fields: [
        {
          type: 'hasMany',
          name: 'comments',
          target: 'comments',
        },
      ],
    });
    this.db.collection({
      name: 'comments',
    });
  }
}
```

----------------------------------------

TITLE: Defining Core Provider Structure in NocoBase TSX
DESCRIPTION: This snippet illustrates the foundational structure of the `Provider` component within the NocoBase client application. It shows how multiple provider components can be nested within a `Router` to establish a global context and manage application-wide concerns, with `Routes` being rendered as children.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/providers.md#_snippet_0

LANGUAGE: tsx
CODE:
```
<Router>
  {' '}
  {/* Context Provider for routes */}
  <ProviderA>
    <ProviderB>
      {/* Custom Provider components - Opening tag */}
      <Routes />
      {/* Custom Provider components - Closing tag */}
    </ProviderB>
  </ProviderA>
</Router>
```

----------------------------------------

TITLE: Directly Replacing a NocoBase Component Globally
DESCRIPTION: This example demonstrates how a custom plugin can directly replace a globally registered component, such as `LoginPage`, with a `CustomLoginPage`. This approach is useful for modifying the appearance or behavior of specific UI components across the application without altering routing.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/component-and-scope/index.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
class CustomPlugin extends Plugin {
  async load() {
    this.app.addComponent({ LoginPage: CustomLoginPage })
  }
}
```

----------------------------------------

TITLE: Directly Replacing a Registered NocoBase Component
DESCRIPTION: This code demonstrates how a custom NocoBase plugin can directly override an already registered component, like 'LoginPage', by providing a new implementation ('CustomLoginPage'). This allows for targeted customization of specific UI components without altering their associated routes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/component-and-scope/index.md#_snippet_3

LANGUAGE: ts
CODE:
```
class CustomPlugin extends Plugin {
  async load() {
    this.app.addComponent({ LoginPage: CustomLoginPage })
  }
}
```

----------------------------------------

TITLE: Register NocoBase Schema Settings with Plugin
DESCRIPTION: This snippet illustrates how to register the previously defined 'imageSettings' with the NocoBase application's schema settings manager. By calling 'this.app.schemaSettingsManager.add(imageSettings)' within the plugin's 'load' method, the settings become available for use with the corresponding UI schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-simple.md#_snippet_9

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/client';
import { imageSettings } from './settings';

export class PluginInitializerBlockSimpleClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(imageSettings)
  }
}

export default PluginInitializerBlockSimpleClient;
```

----------------------------------------

TITLE: Quickstarting Application Programmatically
DESCRIPTION: This snippet demonstrates how to programmatically quickstart a NocoBase application using `mockServer()` and `app.runCommand('start', '--quickstart')`, which performs auto-installation or upgrade.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/test.md#_snippet_7

LANGUAGE: typescript
CODE:
```
const app = mockServer();
await app.runCommand('start', '--quickstart');
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the `orderDetailsSettings` with the `app.schemaSettingsManager` within the plugin's `load` method. This step makes the custom schema settings accessible and usable throughout the NocoBase application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/without-value.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { orderDetailsSettings } from './settings';

export class PluginFieldComponentWithoutValueClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(orderDetailsSettings)
  }
}

export default PluginFieldComponentWithoutValueClient;
```

----------------------------------------

TITLE: NocoBase CLI: Extending Commands in TypeScript
DESCRIPTION: This snippet illustrates how to extend NocoBase CLI commands using TypeScript. It shows examples of adding custom commands within `app/server/index.ts` or a NocoBase plugin, leveraging the `commander.js` library.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/cli.md#_snippet_2

LANGUAGE: typescript
CODE:
```
const app = new Application(config);

app.command('hello').action(() => {});
```

LANGUAGE: typescript
CODE:
```
class MyPlugin extends Plugin {
  beforeLoad() {
    this.app.command('hello').action(() => {});
  }
}
```

----------------------------------------

TITLE: Breaking Change: Removing Inline db.collection Definition (Diff)
DESCRIPTION: Demonstrates the removal of inline `this.db.collection()` definitions within the plugin's `load` method. Collections should now be defined in separate files within the `src/server/collections` directory.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0190-changelog.md#_snippet_10

LANGUAGE: diff
CODE:
```
export class AuthPlugin extends Plugin {
  async load() {
-   this.db.collection({
-     name: 'examples',
-   });
  }
}
```

----------------------------------------

TITLE: Nocobase Plugin Lifecycle Methods (TypeScript)
DESCRIPTION: This TypeScript snippet defines a Nocobase plugin class, `PluginSampleHelloServer`, demonstrating key lifecycle methods such as `afterAdd`, `beforeLoad`, `load`, `install`, `afterEnable`, `afterDisable`, and `remove`. It shows how to interact with the application, database, and resource manager at different stages of the plugin's existence to customize behavior.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { InstallOptions, Plugin } from '@nocobase/server';

export class PluginSampleHelloServer extends Plugin {
  afterAdd() {
    // After the plugin is registered with pm.add. Mainly used for placing listeners for the app beforeLoad event
    this.app.on('beforeLoad');
  }
  beforeLoad() {
    // Customize classes or methods
    this.db.registerFieldTypes();
    this.db.registerModels();
    this.db.registerRepositories();
    this.db.registerOperators();
    // Event listeners
    this.app.on();
    this.db.on();
  }
  async load() {
    // Define collection
    this.db.collection();
    // Import collection configurations
    this.db.import();
    this.db.addMigrations();

    // Define resource
    this.resourcer.define();
    // Register resource actions
    this.resourcer.registerActions();

    // Register middleware
    this.resourcer.use();
    this.acl.use();
    this.app.use();

    this.app.i18n;
    // Custom commands
    this.app.command();
  }
  async install(options?: InstallOptions) {
    // Installation logic
  }
  async afterEnable() {
    // After activation
  }
  async afterDisable() {
    // After deactivation
  }
  async remove() {
    // Deletion logic
  }
}

export default MyPlugin;
```

----------------------------------------

TITLE: Stopping NocoBase Application with PM2 (Bash)
DESCRIPTION: This command uses the NocoBase CLI to stop the application processes managed by PM2. It's used to gracefully shut down the application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/getting-started/deployment/create-nocobase-app.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn nocobase pm2-stop
```

----------------------------------------

TITLE: Creating and Enabling a NocoBase Plugin (Bash)
DESCRIPTION: This snippet shows how to create a new NocoBase plugin using `yarn pm create` and then enable it within the application using `yarn pm enable`. This integrates the newly created plugin into the NocoBase project.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/router/add-setting-page-layout-routes/index.md#_snippet_1

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase-sample/plugin-add-setting-page-layout-routes
yarn pm enable @nocobase-sample/plugin-add-setting-page-layout-routes
```

----------------------------------------

TITLE: NocoBase: Configure Sub-table Field Permissions within Relationship Fields
DESCRIPTION: This section explains how permissions for fields within a relationship field component, when it acts as a sub-table, are determined by the target data table's permissions. It illustrates a scenario where the relationship field has full access, but the linked target collection (shipment) is read-only, affecting sub-table field visibility during new/edit operations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/acl/user/index.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Configuration:
  - Order Table Permissions:
    - Relationship Field 'shipment': Full Permissions
  - shipment Collection Permissions:
    - Collection Access: Read-only

UI Behavior:
  - 'shipment' relationship field is visible.
  - When switched to sub-table, fields within the sub-table are visible during viewing operations but hidden during new or edit operations.
```

----------------------------------------

TITLE: Integrating Custom Block into Page-Level Add Block (TSX)
DESCRIPTION: This code extends the NocoBase client plugin to add a custom `Timeline` component and its associated `useTimelineProps` scope. It also registers the `timelineSettings` and, crucially, adds the `timelineInitializerItem` to the page-level 'Add block' menu under the `dataBlocks` category, using the `page:addBlock` name.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data-modal.md#_snippet_17

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { Timeline } from './component';
import { useTimelineProps } from './schema';
import { timelineSettings } from './settings';
import { timelineInitializerItem } from './timelineInitializerItem';

export class PluginInitializerBlockDataModalClient extends Plugin {
  async load() {
    this.app.addComponents({ Timeline })
    this.app.addScopes({ useTimelineProps });
    this.app.schemaSettingsManager.add(timelineSettings)

    this.app.schemaInitializerManager.addItem('page:addBlock', `dataBlocks.${timelineInitializerItem.name}`, timelineInitializerItem)
  }
}

export default PluginInitializerBlockDataModalClient;
```

----------------------------------------

TITLE: Validating Carousel Block Schema in NocoBase Client Plugin (React/TypeScript)
DESCRIPTION: This snippet defines a NocoBase client plugin that adds a temporary route (`/admin/carousel-schema`) to validate the `carouselSchema`. It demonstrates how to use `SchemaComponent` with different `x-decorator-props` to test various configurations of the carousel block, including image display, height, object fit, and autoplay. This method allows for visual verification of the schema's rendering and behavior.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/block/block-carousel.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Plugin, SchemaComponent } from '@nocobase/client';
import { Carousel } from './component';
import { carouselSchema } from './schema';

export class PluginBlockCarouselClient extends Plugin {
  async load() {
    this.app.addComponents({ Carousel })
    this.app.addScopes({ useCarouselBlockProps });

    this.app.router.add('admin.carousel-schema', {
      path: '/admin/carousel-schema',
      Component: () => {
        const images = [{ url: 'https://picsum.photos/id/1/1200/300' }, { url: 'https://picsum.photos/id/2/1200/300' }];
        return <>
          <div style={{ marginTop: 20, marginBottom: 20 }}>
            <SchemaComponent schema={{ properties: { test1: carouselSchema } }} />
          </div>
          <div style={{ marginTop: 20, marginBottom: 20 }}>
            <SchemaComponent schema={{ properties: { test2: { ...carouselSchema, 'x-decorator-props': { carousel: { images, height: 100 } } } } }} />
          </div>
          <div style={{ marginTop: 20, marginBottom: 20 }}>
            <SchemaComponent schema={{ properties: { test3: { ...carouselSchema, 'x-decorator-props': { carousel: { images, objectFit: 'contain' } } } } }} />
          </div>
          <div style={{ marginTop: 20, marginBottom: 20 }}>
            <SchemaComponent schema={{ properties: { test4: { ...carouselSchema, 'x-decorator-props': { carousel: { images, autoplay: true } } } } }} />
          </div>
        </>
      }
    });
  }
}

export default PluginBlockCarouselClient;
```

----------------------------------------

TITLE: Initiating Authentication Requests with NocoBase SDK - TypeScript
DESCRIPTION: This snippet demonstrates how to use the `useAPIClient` hook from `@nocobase/client` to access NocoBase's authentication APIs. It shows an example of calling the `signIn` method with `data` and an `authenticator`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/guide.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import { useAPIClient } from '@nocobase/client';

// Use in component
const api = useAPIClient();
api.auth.signIn(data, authenticator);
```

----------------------------------------

TITLE: Registering Data Block Initializer and Components in NocoBase Plugin
DESCRIPTION: This snippet shows the `load` method of the `PluginDataBlockInitializerClient` class, where the custom data block's components (`Info`), scopes (`useInfoProps`), schema settings (`infoSettings`), and the schema initializer item (`infoInitializerItem`) are registered with the NocoBase application. Specifically, `infoInitializerItem` is added to the 'page:addBlock' initializer under the 'dataBlocks' category, making it available for users to add to pages.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data.md#_snippet_12

LANGUAGE: TSX
CODE:
```
import { Plugin } from '@nocobase/client';
import { Info } from './component';
import { useInfoProps } from './schema';
import { infoSettings } from './settings';
import { infoInitializerItem } from './initializer';

export class PluginDataBlockInitializerClient extends Plugin {
  async load() {
    this.app.addComponents({ Info });
    this.app.addScopes({ useInfoProps });

    this.app.schemaSettingsManager.add(infoSettings);

    this.app.schemaInitializerManager.addItem('page:addBlock', `dataBlocks.${infoInitializerItem.name}`, infoInitializerItem)
  }
}

export default PluginDataBlockInitializerClient;
```

----------------------------------------

TITLE: Implementing Custom SchemaSettings Item for Height in NocoBase (TypeScript)
DESCRIPTION: This snippet defines `heightSchemaSettingsItem`, a custom `SchemaSettingsItemType` for NocoBase. It uses an `actionModal` to allow users to edit a 'height' property, leveraging `useFieldSchema` to access current schema data and `useDesignable` for merging changes back into the designable schema. The modal includes an `InputNumber` field for height and updates the `x-decorator-props` on submission.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-settings/new.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettingsItemType, useDesignable, } from "@nocobase/client";
import { useFieldSchema } from '@formily/react';
import { useT } from '../../locale'
import { BlockNameLowercase } from "../../constants";

export const heightSchemaSettingsItem: SchemaSettingsItemType = {
  name: 'height',
  type: 'actionModal',
  useComponentProps() {
    const filedSchema = useFieldSchema();
    const { deepMerge } = useDesignable();
    const t = useT();

    return {
      title: t('Edit height'),
      schema: {
        type: 'object',
        title: t('Edit height'),
        properties: {
          height: {
            title: t('Height'),
            type: 'number',
            default: filedSchema['x-decorator-props']?.[BlockNameLowercase]?.height,
            'x-decorator': 'FormItem',
            'x-component': 'InputNumber',
          },
        },
      },
      onSubmit({ height }: any) {
        deepMerge({
          'x-uid': filedSchema['x-uid'],
          'x-decorator-props': {
            ...filedSchema['x-decorator-props'],
            [BlockNameLowercase]: {
              ...filedSchema['x-decorator-props']?.[BlockNameLowercase],
              height,
            },
          },
        })
      }
    };
  },
};
```

----------------------------------------

TITLE: Implement QRCode Read-Only Component in React
DESCRIPTION: This snippet defines the "QRCodeReadPretty" React functional component, intended for the read-only or preview mode of the QR code field. It displays the QR code using "AntdQRCode" based on the "value" prop, rendering nothing if the value is empty.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/field/value.md#_snippet_3

LANGUAGE: TSX
CODE:
```
const QRCodeReadPretty: FC<QRCodeProps> = ({ value, ...otherProps }) => {
  if (!value) return null;
  return <AntdQRCode value={value} {...otherProps} />;
}
```

----------------------------------------

TITLE: Accessing URL Parameters in ctx.action.params - TypeScript
DESCRIPTION: This snippet demonstrates how to extract specific URL parameters, such as `filterByTk`, directly from `ctx.action.params`. This property holds parameters parsed from the request URL, making them readily available for use in subsequent middleware or action logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/action.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
const { filterByTk } = ctx.action.params;
```

----------------------------------------

TITLE: Defining Timeline Block Schema and Props in NocoBase (TypeScript)
DESCRIPTION: This snippet defines `getTimelineSchema` to generate a UI schema for a `Timeline` block, utilizing `DataBlockProvider` for data fetching and styling with `CardItem`. It also defines `useTimelineProps` to dynamically process and map data for the `Timeline` component, extracting `timeField` and `titleField` from the `DataBlockProvider`'s props and formatting the data for display.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data-modal.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { useDataBlockProps, useDataBlockRequest } from "@nocobase/client";
import { TimelineProps } from '../component';
import { BlockName, BlockNameLowercase } from "../constants";

interface GetTimelineSchemaOptions {
  dataSource?: string;
  collection: string;
  titleField: string;
  timeField: string;
}

export function getTimelineSchema(options: GetTimelineSchemaOptions) {
  const { dataSource, collection, titleField, timeField } = options;
  return {
    type: 'void',
    "x-toolbar": "BlockSchemaToolbar",
    'x-decorator': 'DataBlockProvider',
    'x-decorator-props': {
      dataSource,
      collection,
      action: 'list',
      params: {
        sort: `-${timeField}`
      },
      [BlockNameLowercase]: {
        titleField,
        timeField,
      }
    },
    'x-component': 'CardItem',
    properties: {
      [BlockNameLowercase]: {
        type: 'void',
        'x-component': BlockName,
        'x-use-component-props': 'useTimelineProps',
      }
    }
  }
}

export function useTimelineProps(): TimelineProps {
  const dataProps = useDataBlockProps();
  const props = dataProps[BlockNameLowercase];
  const { loading, data } = useDataBlockRequest<any[]>();
  return {
    loading,
    data: data?.data?.map((item) => ({
      label: item[props.timeField],
      children: item[props.titleField],
    }))
  }
}
```

----------------------------------------

TITLE: Registering Custom Actions in NocoBase Client Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register custom document actions within a NocoBase client plugin. It adds initializer items for 'table:configureActions', 'details:configureActions', and 'createForm:configureActions' to integrate new actions into various UI blocks. This requires the `createDocumentActionInitializerItem` utility and extends the `Plugin` class.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/action-simple.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { useDocumentActionProps } from './schema';
import { documentActionSettings } from './settings';
import { createDocumentActionInitializerItem } from './initializer';

export class PluginInitializerActionSimpleClient extends Plugin {
  async load() {
    this.app.addScopes({ useDocumentActionProps });
    this.app.schemaSettingsManager.add(documentActionSettings);
    this.app.schemaInitializerManager.addItem('table:configureActions', 'document', createDocumentActionInitializerItem('table-v2'));
    this.app.schemaInitializerManager.addItem('details:configureActions', 'document', createDocumentActionInitializerItem('details'));
    this.app.schemaInitializerManager.addItem('createForm:configureActions', 'document', createDocumentActionInitializerItem('form-v2'));
  }
}

export default PluginInitializerActionSimpleClient;
```

----------------------------------------

TITLE: Setting up Server-Side Database Tests with NocoBase and Vitest
DESCRIPTION: This snippet demonstrates how to write server-side tests using `@nocobase/test/server`. It shows how to initialize a mock database, define collections, create records, and assert their values within a Vitest test suite. It includes `beforeEach` and `afterEach` hooks for database setup and teardown.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0180-changelog.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { mockDatabase } from '@nocobase/test/server';

describe('my db suite', () => {
  let db;

  beforeEach(async () => {
    db = mockDatabase();
    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });
    await db.sync();
  });

  afterEach(async () => {
    await db.close();
  });

  test('my case', async () => {
    const repository = db.getRepository('posts');
    const post = await repository.create({
      values: {
        title: 'hello',
      },
    });

    expect(post.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Simulating User Clicks with userEvent (TypeScript)
DESCRIPTION: This snippet illustrates importing `userEvent` from `@nocobase/test/client` to simulate user interactions. Specifically, it demonstrates calling the `click()` method, which is used for testing user interface interactions by mimicking a user's click action.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/test/client.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
import { userEvent } from '@nocobase/test/client';

await userEvent.click();
```

----------------------------------------

TITLE: Implementing Custom SMS Provider Sending Interface (Server-side, TypeScript)
DESCRIPTION: This snippet shows the basic structure for implementing a custom SMS provider on the server side. The `CustomSMSProvider` class extends `SMSProvider` and requires a `send` method. This method is where the actual logic for interacting with the external SMS provider API to send messages (containing the OTP code) should be implemented.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/verification/sms/dev.md#_snippet_1

LANGUAGE: ts
CODE:
```
class CustomSMSProvider extends SMSProvider {
  constructor(options) {
    super(options);
    // options is the configuration object from the client
    const options = this.options;
    // ...
  }

  async send(phoneNumber: string, data: { code: string }) {
    // ...
  }
}
```

----------------------------------------

TITLE: Defining Text Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a text type field named 'content' for a 'books' collection in NocoBase. This field is equivalent to the `TEXT` type in most databases, suitable for longer text.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'text',
      name: 'content',
    },
  ],
});
```

----------------------------------------

TITLE: NocoBase Authentication Flow (Third-Party Callbacks)
DESCRIPTION: This section outlines the authentication process when third-party callbacks are involved. The client obtains a third-party login URL, redirects for login, and the third-party service calls a NocoBase callback interface (e.g., `auth:redirect`) with authentication results. The callback then parses parameters, obtains the authenticator class, and actively calls `auth.signIn()`, which in turn calls `validate()`. Finally, the callback redirects to the frontend with the authenticator ID and token.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/auth/dev/guide.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
1. Client obtains third-party login URL via a registered interface (e.g., `auth:getAuthUrl`), sending app name and authenticator ID.\n2. Client redirects to third-party URL to complete login.\n3. Third-party service calls NocoBase callback interface (e.g., `auth:redirect`) with authentication results, app name, and authenticator ID.\n4. Callback interface parses parameters, gets authenticator class via `AuthManager`, and calls `auth.signIn()`.\n5. `auth.signIn()` calls the authenticator's `validate()` method.\n6. Callback redirects to frontend page with 302 status, including URL parameters `?authenticator=xxx&token=yyy`.
```

----------------------------------------

TITLE: Basic Data Query using Repository in NocoBase
DESCRIPTION: Illustrates a fundamental data query using the `find` method on a `Repository` object. It shows how to filter records based on a specific ID, equivalent to a SQL `SELECT * FROM users WHERE id = 1` statement.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_1

LANGUAGE: javascript
CODE:
```
// SELECT * FROM users WHERE id = 1
userRepository.find({
  filter: {
    id: 1,
  },
});
```

----------------------------------------

TITLE: Defining Fields within a Collection (TypeScript)
DESCRIPTION: This snippet shows how to define fields within a 'users' collection using `db.collection()`. It includes examples of a 'name' field (string) and an 'age' field (integer), highlighting the structure for specifying field names and types.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    { type: 'string', name: 'name' }
    { type: 'integer', name: 'age' }
    // Other fields
  ],
});
```

----------------------------------------

TITLE: Defining Email and Phone Fields with Full UI Schema in TypeScript
DESCRIPTION: This snippet demonstrates the explicit, full configuration for 'email' and 'phone' fields. Each field is defined with its `type` as `string` and a complete `uiSchema` specifying the `Input` component and respective validation rules (`email` or `phone`). This approach, while functional, highlights the verbosity that Field Interfaces aim to reduce.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/index.md#_snippet_3

LANGUAGE: ts
CODE:
```
// email field, string + input, email validation rules
{
  type: 'string',
  name: 'email',
  uiSchema: {
    'x-component': 'Input',
    'x-component-props': {},
    'x-validator': 'email',
  },
}

// phone field, string + input, phone validation rules
{
  type: 'string',
  name: 'phone',
  uiSchema: {
    'x-component': 'Input',
    'x-component-props': {},
    'x-validator': 'phone',
  },
}
```

----------------------------------------

TITLE: Registering a Custom Field Type in NocoBase Plugin (TypeScript)
DESCRIPTION: This code snippet demonstrates how to register a newly created custom field type, 'SnowflakeField', within a NocoBase plugin. By calling `this.db.registerFieldTypes()`, the custom field becomes available for use in collection definitions throughout the application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
import SnowflakeField from '. /fields/snowflake';

export default class ShopPlugin extends Plugin {
  initialize() {
    // ...
    this.db.registerFieldTypes({
      snowflake: SnowflakeField,
    });
    // ...
  }
}
```

----------------------------------------

TITLE: Registering Admin Dynamic Page Route in NocoBase (TypeScript)
DESCRIPTION: This snippet registers a dynamic page route for the NocoBase admin interface. The path `/admin/:name` allows for flexible page names, and the `AdminDynamicPage` component is responsible for rendering content based on the dynamic `:name` parameter. These pages are typically managed through the menu management system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/router.md#_snippet_3

LANGUAGE: ts
CODE:
```
router.add('admin.page', {
  path: '/admin/:name',
  Component: AdminDynamicPage,
});
```

----------------------------------------

TITLE: Registering Parent Route Without Custom Component (TypeScript)
DESCRIPTION: This snippet illustrates an alternative way to register a parent route in the NocoBase router. If the parent page (`/admin/material`) does not require a custom React component or layout, the `Component` property can be omitted, allowing it to serve as a container for sub-routes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/router/add-page/index.md#_snippet_5

LANGUAGE: ts
CODE:
```
this.app.router.add('admin.material', {
  path: '/admin/material',
})
```

----------------------------------------

TITLE: Adding Public About Page in NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to add a new public page (`/about`) to a NocoBase application by modifying the plugin's client-side `index.tsx` file. It defines a React component (`AboutPage`) and uses `this.app.router.add()` to register the page with its path and component, also utilizing `useDocumentTitle` to set the browser tab title.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-page/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import React, { useEffect } from 'react';
import { Plugin, useDocumentTitle } from '@nocobase/client';

const AboutPage = () => {
  const { setTitle } = useDocumentTitle();

  useEffect(() => {
    setTitle('About');
  }, [])

  return <div>About Page</div>;
}

export class PluginAddPageClient extends Plugin {
  async load() {
    this.app.router.add('about', {
      path: '/about',
      Component: AboutPage,
    })
  }
}

export default PluginAddPageClient;
```

----------------------------------------

TITLE: Defining One-to-Many Association with hasMany (TypeScript)
DESCRIPTION: This example shows the 'hasMany' association type, establishing a one-to-many relationship where a user can have multiple posts. The foreign key ('authorId') is stored in the 'posts' table (the association table). It explicitly defines 'foreignKey' and 'sourceKey' for clarity.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_15

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'hasMany',
      name: 'posts',
      foreignKey: 'authorId',
      sourceKey: 'id'
    }
  ]
});
```

----------------------------------------

TITLE: Define ACL Role
DESCRIPTION: Defines a role within the ACL system. This method allows specifying the role's unique identifier, global access policy (strategy), specific action permissions, and associated snippets. It returns an ACLRole object.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/acl/acl.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export interface DefineOptions {
  role: string;
  strategy?: string | AvailableStrategyOptions;
  actions?: ResourceActionsOptions;
  snippets?: string[];
}

export interface AvailableStrategyOptions {
  displayName?: string;
  actions?: false | string | string[];
  allowConfigure?: boolean;
  resource?: '*';
}

export interface ResourceActionsOptions {
  [actionName: string]: RoleActionParams;
}

export interface RoleActionParams {
  fields?: string[];
  filter?: any;
  own?: boolean;
  whitelist?: string[];
  blacklist?: string[];
}
```

LANGUAGE: APIDOC
CODE:
```
### `define()`

Defines a role.

#### Signature

- `define(options: DefineOptions): ACLRole`

#### Details

##### DefineOptions

| Property   | Type                                      | Description                                                               |
|------------|-------------------------------------------|---------------------------------------------------------------------------|
| `role`     | `string`                                  | Unique identifier for the role                                            |
| `strategy` | `string` | `AvailableStrategyOptions` | Optional, global access policy for the role, policy identifier, or policy settings. |
| `actions`  | `{ [actionName: string]: RoleActionParams; }` | Optional, permission settings for operations                              |
| `snippets` | `string[]`                                | Optional, defines snippets that the role has permissions for              |

##### AvailableStrategyOptions

| Property         | Type                        | Description                                     |
|------------------|-----------------------------|-------------------------------------------------|
| `displayName`    | `string`                    | Optional, display title for the policy          |
| `actions`        | `false` | `string` | `string[]` | Optional, operation interface                   |
| `allowConfigure` | `boolean`                   | Optional, whether to allow user interface configuration |
| `resource`       | `*`                         | Applies to all resources                        |

##### RoleActionParams

| Property    | Type       | Description                                                                                             |
|-------------|------------|---------------------------------------------------------------------------------------------------------|
| `fields`    | `string[]` | Optional, fields of the data sheet to operate on                                                        |
| `filter`    | `any`      | Optional, filter parameters that must be met to perform the operation; only records matching the conditions can be operated on. |
| `own`       | `boolean`  | Optional, only records created by oneself can be operated on.                                           |
| `whitelist` | `string[]` | Optional, field whitelist; only fields in the list are accessible.                                      |
| `blacklist` | `string[]` | Optional, field blacklist; fields in the list are not accessible.                                       |
```

----------------------------------------

TITLE: Defining BelongsTo Association in NocoBase Collection (TypeScript)
DESCRIPTION: This example illustrates how to establish a many-to-one relationship using the 'belongsTo' field type in a NocoBase collection. A 'post' is associated with an 'author' (from the 'users' table), with explicit 'target', 'foreignKey', and 'sourceKey' options demonstrating how to customize the relationship's mapping.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_13

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'posts',
  fields: [
    {
      type: 'belongsTo',
      name: 'author',
      target: 'users', // Default table name is the plural form of <name>
      foreignKey: 'authorId', // Default is '<name> + Id'
      sourceKey: 'id', // Default is id of the <target> table
    },
  ],
});
```

----------------------------------------

TITLE: Registering a Custom Workflow Instruction in NocoBase Plugin (TypeScript)
DESCRIPTION: This code snippet shows how to register a custom workflow instruction, such as `MyInstruction`, with the NocoBase workflow plugin. This registration typically occurs within the `load` method of a custom NocoBase plugin, making the instruction available for use in workflow definitions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/development/instruction.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
export default class MyPlugin extends Plugin {
  load() {
    // get workflow plugin instance
    const workflowPlugin = this.app.getPlugin<WorkflowPlugin>(WorkflowPlugin);

    // register instruction
    workflowPlugin.registerInstruction('my-instruction', MyInstruction);
  }
}
```

----------------------------------------

TITLE: HasMany Association Interface and Example
DESCRIPTION: This snippet presents the TypeScript interface for a 'hasMany' association, outlining parameters such as `name`, `target`, `sourceKey`, and `foreignKey`. The example demonstrates a one-to-many relationship where 'posts' have many 'comments', using `sourceKey` for the posts' primary key and `foreignKey` for the comments' foreign key.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/association-fields.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
interface HasMany {
  type: 'hasMany';
  name: string;
  // defaults to name
  target?: string;
  // The default value is the primary key of the source model, usually 'id'
  sourceKey?: string;
  // the default value is the singular form of the source collection name + 'Id'
  foreignKey?: string;
}

// The posts table's primary key id is concatenated with the comments table's postId
{
  name: 'posts',
  fields: [
    {
      type: 'hasMany',
      name: 'comments',
      target: 'comments',
      sourceKey: 'id', // posts table's primary key
      foreignKey: 'postId', // foreign key in the comments table
    }
  ],
}
```

----------------------------------------

TITLE: Connecting to NocoBase Database - JavaScript
DESCRIPTION: This snippet demonstrates how to initialize a NocoBase `Database` instance. It shows configurations for connecting to SQLite using a storage path, and for connecting to MySQL or PostgreSQL requiring dialect, database name, credentials, host, and port.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_0

LANGUAGE: javascript
CODE:
```
const { Database } = require('@nocobase/database');

// SQLite database configuration parameters
const database = new Database({
  dialect: 'sqlite',
  storage: 'path/to/database.sqlite'
})
```

LANGUAGE: javascript
CODE:
```
// MySQL \ PostgreSQL database configuration parameters
const database = new Database({
  dialect: /* 'postgres' or 'mysql' */,
  database: 'database',
  username: 'username',
  password: 'password',
  host: 'localhost',
  port: 'port'
})
```

----------------------------------------

TITLE: Defining CollectionField in Schema (TypeScript)
DESCRIPTION: Provides an example of how `CollectionField` is defined within a schema. It specifies the field's `name`, decorators (`x-decorator`), component (`x-component`), and their respective props, indicating its use in schema-driven UI scenarios.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/extensions/collection-manager.md#_snippet_5

LANGUAGE: ts
CODE:
```
{
  name: 'title',
  'x-decorator': 'FormItem',
  'x-decorator-props': {},
  'x-component': 'CollectionField',
  'x-component-props': {},
  properties: {},
}
```

----------------------------------------

TITLE: Defining a Collection Field in Schema (TypeScript)
DESCRIPTION: This is a versatile field component designed for use within a Schema context, requiring `<CollectionProvider/>` as a parent. It retrieves the field schema by `name` from the `CollectionProvider` and allows for extended configuration via its own schema properties, primarily used for dynamic form generation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/client/extensions/collection-manager.md#_snippet_5

LANGUAGE: ts
CODE:
```
{
  name: 'title',
  'x-decorator': 'FormItem',
  'x-decorator-props': {},
  'x-component': 'CollectionField',
  'x-component-props': {},
  properties: {},
}
```

----------------------------------------

TITLE: Hiding Component While Retaining Data in TypeScript Schema
DESCRIPTION: Demonstrates `'x-display': 'hidden'`, which hides the component from the UI but keeps its corresponding data model intact, allowing data manipulation even when the component is not visible.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/what-is-ui-schema.md#_snippet_19

LANGUAGE: ts
CODE:
```
{
  type: 'void',
  'x-component': 'div',
  'x-component-props': { className: 'form-item' },
  properties: {
    title: {
      type: 'string',
      'x-component': 'input',
      'x-display': 'hidden'
    }
  }
}
```

LANGUAGE: tsx
CODE:
```
<div className={'form-item'}>
  {/* No input component is output here, but the field model with name=title still exists */}
</div>
```

----------------------------------------

TITLE: Defining Action Button Schema and Props in TypeScript
DESCRIPTION: This snippet defines `useDocumentActionProps` to provide dynamic properties for an action button, including its title and an `onClick` handler to open a URL. It also defines `createDocumentActionSchema`, a function that generates a UI schema for an 'Action' component, embedding a custom `x-doc-url` property and linking to the dynamic props.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/action-simple.md#_snippet_4

LANGUAGE: typescript
CODE:
```
import { useFieldSchema } from '@formily/react';
import { ISchema } from "@nocobase/client"
import { useT } from '../locale';
import { ActionName } from '../constants';

export function useDocumentActionProps() {
  const fieldSchema = useFieldSchema();
  const t = useT();
  return {
    title: t(ActionName),
    type: 'primary',
    onClick() {
      window.open(fieldSchema['x-doc-url'])
    }
  }
}

export const createDocumentActionSchema = (blockComponent: string): ISchema & { 'x-doc-url': string } => {
  return {
    type: 'void',
    'x-component': 'Action',
    'x-doc-url': `https://client.docs.nocobase.com/components/${blockComponent}`,
    'x-use-component-props': 'useDocumentActionProps',
  }
}
```

----------------------------------------

TITLE: Integrate useSubmitActionProps Hook into NocoBase SchemaComponent
DESCRIPTION: This diff snippet shows how to pass the `useSubmitActionProps` hook into the `SchemaComponent`'s `scope` prop. This makes the custom hook available for use within the schema definition, specifically for `x-use-component-props`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/plugin-settings/table.md#_snippet_11

LANGUAGE: diff
CODE:
```
export const PluginSettingsTable = () => {
  return (
    <ExtendCollectionsProvider collections={[emailTemplatesCollection]}>
-     <SchemaComponent schema={schema} />
+     <SchemaComponent schema={schema} scope={{ useSubmitActionProps }} />
    </ExtendCollectionsProvider>
  );
};
```

----------------------------------------

TITLE: NocoBase Plugin Directory Structure Overview
DESCRIPTION: This snippet illustrates the typical directory structure of a NocoBase plugin, highlighting key folders like `client` (for client-side code), `locale` (for localization), and `server` (for server-side logic), along with their respective entry points and sub-components.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/action-modal.md#_snippet_3

LANGUAGE: text
CODE:
```
.
├── client # Client-side plugin
│   ├── initializer # Initializer
│   ├── index.tsx # Client-side plugin entry point
│   ├── locale.ts # Localization utility functions
│   ├── constants.ts # Constants
│   ├── schema # Schema
│   └── settings # Schema Settings
├── locale # Localization files
│   ├── en-US.json # English
│   └── zh-CN.json # Chinese
├── index.ts # Server-side plugin entry point
└── server # Server-side plugin
```

----------------------------------------

TITLE: APIClient Request Method Signature (TypeScript)
DESCRIPTION: Defines the signature of the `request` method within the `APIClient` class, indicating it accepts `AxiosRequestConfig` or `ResourceActionOptions` and returns a Promise. This method is used for client-side requests.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/api-client.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
class APIClient {
  // Client-side requests, supporting AxiosRequestConfig and ResourceActionOptions
  request<T = any, R = AxiosResponse<T>, D = any>(
    config: AxiosRequestConfig<D> | ResourceActionOptions,
  ): Promise<R>;
}
```

----------------------------------------

TITLE: Nocobase Database Constructor API Reference
DESCRIPTION: This section provides the API documentation for the Database constructor. It details the signature and all available options parameters, including host, port, credentials, dialect, storage, logging, and NocoBase-specific extensions like tablePrefix and migrator.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Signature:
- constructor(options: DatabaseOptions)

Description: Creates a database instance.

Parameters:
| Parameter Name | Type | Default Value | Description |
|---|---|---|---|
| options.host | string | 'localhost' | Database host |
| options.port | number | - | Database service port, corresponds to the default port for the database in use |
| options.username | string | - | Database username |
| options.password | string | - | Database password |
| options.database | string | - | Database name |
| options.dialect | string | 'mysql' | Database type |
| options.storage? | string | ':memory:' | SQLite storage mode |
| options.logging? | boolean | false | Whether to enable logging |
| options.define? | Object | {} | Default table definition parameters |
| options.tablePrefix? | string | '' | NocoBase extension, table name prefix |
| options.migrator? | UmzugOptions | {} | NocoBase extension, migration manager related parameters, refer to Umzug implementation |
```

----------------------------------------

TITLE: NocoBase Sync Listener Type Definition (TypeScript)
DESCRIPTION: This snippet defines the `SyncListener` type, which is used for database synchronization event callbacks. It imports `SyncOptions` and `HookReturn` from `sequelize/types`, indicating the expected parameters and return type for the listener function.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_25

LANGUAGE: TypeScript
CODE:
```
import type { SyncOptions, HookReturn } from 'sequelize/types';

type SyncListener = (options?: SyncOptions) => HookReturn;
```

----------------------------------------

TITLE: Initializing NocoBase Application and Plugin
DESCRIPTION: This snippet provides the necessary bash commands to initialize a new NocoBase application, install dependencies, and then create and enable a new plugin. These steps are prerequisites for developing custom SchemaSettings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-settings/new.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
yarn pm create @nocobase-sample/plugin-schema-settings-new
yarn pm enable @nocobase-sample/plugin-schema-settings-new
yarn dev
```

----------------------------------------

TITLE: Creating and Enabling NocoBase Plugin (Bash)
DESCRIPTION: These commands create a new NocoBase plugin with a specific name and then enable it within the NocoBase system. This makes the plugin available for development and integration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_1

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase-sample/plugin-initializer-configure-fields
yarn pm enable @nocobase-sample/plugin-initializer-configure-fields
```

----------------------------------------

TITLE: Initializing NocoBase Application and Plugin (Bash)
DESCRIPTION: This snippet provides the necessary bash commands to set up a new NocoBase application, install its dependencies, and then create and enable a new plugin within that application. These steps are prerequisites for developing and integrating custom plugin pages.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/router/add-setting-page-layout-routes/index.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d sqlite
cd my-nocobase-app
yarn install
yarn nocobase install
```

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase-sample/plugin-add-setting-page-layout-routes
yarn pm enable @nocobase-sample/plugin-add-setting-page-layout-routes
```

----------------------------------------

TITLE: Define Data Models and Sync with Nocobase Collection
DESCRIPTION: This example illustrates how to define data models using Nocobase's Collection object, which represents database tables. After defining fields like 'name' and 'age', the database.sync() method is called to synchronize the defined structure with the actual database.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_1

LANGUAGE: javascript
CODE:
```
// Collection を定義
const UserCollection = database.collection({
  name: 'users',
  fields: [
    {
      name: 'name',
      type: 'string',
    },
    {
      name: 'age',
      type: 'integer',
    },
  ],
});

await database.sync();
```

----------------------------------------

TITLE: TypeScript: `$is` Operator for Null/Boolean Check
DESCRIPTION: Checks if a field's value is the specified value, equivalent to SQL's `IS`. Commonly used for `null` checks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/operators.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    title: {
      $is: null,
    },
  },
});
```

----------------------------------------

TITLE: TypeScript: Define Resources with ResourceManager
DESCRIPTION: The `define()` method allows you to register new resources and their associated actions within NocoBase's ResourceManager. It takes an options object to configure the resource name and custom action handlers. This method is crucial for extending the application's resource capabilities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/resourcer/resource-manager.md#_snippet_0

LANGUAGE: ts
CODE:
```
app.resourceManager.define({
  name: 'auth',
  actions: {
    check: async (ctx, next) => {
      // ...
      await next();
    }
  }
});
```

LANGUAGE: APIDOC
CODE:
```
define(options: ResourceOptions): Resource
```

LANGUAGE: APIDOC
CODE:
```
export interface ResourceOptions {
  name: string;
  type?: ResourceType;
  actions?: {
    [key: string]: ActionType;
  };
  only?: Array<ActionName>;
  except?: Array<ActionName>;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
}

export type ResourceType =
  | 'single'
  | 'hasOne'
  | 'hasMany'
  | 'belongsTo'
  | 'belongsToMany';

export type ActionType = HandlerType | ActionOptions;
export type HandlerType = (
  ctx: ResourcerContext,
  next: () => Promise<any>,
) => any;
export interface ActionOptions {
  values?: any;
  fields?: string[];
  appends?: string[];
  except?: string[];
  whitelist?: string[];
  blacklist?: string[];
  filter?: FilterOptions;
  sort?: string[];
  page?: number;
  pageSize?: number;
  maxPageSize?: number;
  middleware?: MiddlewareType;
  middlewares?: MiddlewareType;
  handler?: HandlerType;
  [key: string]: any;
}
```

LANGUAGE: APIDOC
CODE:
```
ResourceOptions Parameters:
- name: string (Resource name)
- type: ResourceType (Resource type, default: 'single')
- actions: { [key: string]: ActionType } (Operations)
- only: ActionName[] (Actions whitelist)
- except: ActionName[] (Actions blacklist)
- middleware: MiddlewareType (Middleware)
- middlewares: MiddlewareType (Middleware)
```

LANGUAGE: APIDOC
CODE:
```
ActionType:
- HandlerType: This type directly defines operation methods via middleware. Example:
  app.resourceManager.define({
    name: 'users',
    actions: {
      updateProfile: async (ctx, next) => {
        // ...
        await next();
      },
    },
  });
- ActionOptions: This type is mainly used to override request parameters for an existing operation. Example:
  app.resourceManager.define({
    name: 'users',
    actions: {
      list: {
        fields: [],
        filter: {},
        // ...
      },
    },
  });
```

LANGUAGE: APIDOC
CODE:
```
ActionType Parameters:
- values: any (Default values for operation request)
- filter: Filter (Filter parameters, refer to Filter Operators)
- fields: string[] (Fields to retrieve)
- except: string[] (Fields to exclude)
- appends: string[] (Relationship fields to append)
- whitelist: string[] (Field whitelist)
- blacklist: string[] (Field blacklist)
- sort: string[] (Sort parameters)
- page: number (Current page)
- pageSize: number (Items per page)
- maxPageSize: number (Maximum items)
- middleware: MiddlewareType (Middleware)
- middlewares: MiddlewareType (Middleware)
- handler: HandlerType (Method to execute for the current operation)
- [key: string]: any (Other extended configurations)
```

----------------------------------------

TITLE: Handling Before/After Validate Events in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to register listeners for 'beforeValidate' and 'afterValidate' events. These events are triggered during data validation, which occurs before data creation or update operations via `repository.create()` or `repository.update()`. The listeners receive the model instance and validation options, allowing for custom validation logic or side effects.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_27

LANGUAGE: TypeScript
CODE:
```
on(eventName: `${string}.beforeValidate` | 'beforeValidate' | `${string}.afterValidate' | 'afterValidate', listener: ValidateListener): this
```

LANGUAGE: TypeScript
CODE:
```
import type { ValidationOptions } from 'sequelize/types/lib/instance-validator';
import type { HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

type ValidateListener = (
  model: Model,
  options?: ValidationOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'tests',
  fields: [
    {
      type: 'string',
      name: 'email',
      validate: {
        isEmail: true,
      },
    },
  ],
});

// all models
db.on('beforeValidate', async (model, options) => {
  // do something
});
// tests model
db.on('tests.beforeValidate', async (model, options) => {
  // do something
});

// all models
db.on('afterValidate', async (model, options) => {
  // do something
});
// tests model
db.on('tests.afterValidate', async (model, options) => {
  // do something
});

const repository = db.getRepository('tests');
await repository.create({
  values: {
    email: 'abc', // checks for email format
  },
});
// or
await repository.update({
  filterByTk: 1,
  values: {
    email: 'abc', // checks for email format
  },
});
```

----------------------------------------

TITLE: TypeScript: `$lte` Operator for Less Than or Equal
DESCRIPTION: Checks if a field's value is less than or equal to the specified value, equivalent to SQL's `<=`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/operators.md#_snippet_17

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    price: {
      $lte: 100,
    },
  },
});
```

----------------------------------------

TITLE: Defining the UI Schema Interface in TypeScript
DESCRIPTION: This TypeScript interface defines the structure of the UI Schema, outlining properties for component type, name, title, component wrappers (`x-decorator`), components (`x-component`), their properties, display states, content, child schemas, field reactions, UI interaction patterns, validators, default values, and designer-related properties like initializers and settings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/what-is-ui-schema.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
interface ISchema {
  type: 'void' | 'string' | 'number' | 'object' | 'array';
  name?: string;
  title?: any;
  // 包装器组件
  ['x-decorator']?: string;
  // 包装器组件属性
  ['x-decorator-props']?: any;
  // 动态包装器组件属性
  ['x-use-decorator-props']?: any;
  // 组件
  ['x-component']?: string;
  // 组件属性
  ['x-component-props']?: any;
  // 动态组件属性
  ['x-use-component-props']?: any;
  // 展示状态，默认为 'visible'
  ['x-display']?: 'none' | 'hidden' | 'visible';
  // 组件的子节点，简单使用
  ['x-content']?: any;
  // children 节点 schema
  properties?: Record<string, ISchema>;

  // 以下仅字段组件时使用

  // 字段联动
  ['x-reactions']?: SchemaReactions;
  // 字段 UI 交互模式，默认为 'editable'
  ['x-pattern']?: 'editable' | 'disabled' | 'readPretty';
  // 字段校验
  ['x-validator']?: Validator;
  // 默认数据
  default: ?:any;

  // 设计器相关

  // 初始化器，决定当前 schema 相邻位置可以插入什么
  ['x-initializer']?: string;
  ['x-initializer-props']?: any;

  // 区块设置，决定当前 schema 可以配置哪些参数
  ['x-settings']?: string;
  ['x-settings-props']?: any;

  // 工具栏组件
  ['x-toolbar']?: string;
  ['x-toolbar-props']?: any;
}
```

----------------------------------------

TITLE: Redefining Component-based Initializer with new SchemaInitializer() - TSX
DESCRIPTION: This snippet shows how a previously component-defined schema initializer is refactored to use the new SchemaInitializer() constructor. It highlights the use of name for items, useChildren for dynamic children generation, and Component instead of component for rendering initializer items.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/upgrade-to/v017.md#_snippet_6

LANGUAGE: TSX
CODE:
```
const bulkEditFormItemInitializers = new SchemaInitializer({
  name: 'BulkEditFormItemInitializers',
  'data-testid': 'configure-fields-button-of-bulk-edit-form-item',
  wrap: gridRowColWrap,
  icon: 'SettingOutlined',
  // 原 insertPosition 和 component 是透传的，这里不用管，也是透传的
  items: [
    {
      type: 'itemGroup',
      title: t('Display fields'),
      name: 'displayFields', // 记得加上 name
      useChildren: useCustomBulkEditFormItemInitializerFields, // 使用到了 useChildren
    },
    {
      type: 'divider',
    },
    {
      title: t('Add text'),
      name: 'addText',
      Component: BlockItemInitializer, // component 替换为 Component
    },
  ],
});
```

----------------------------------------

TITLE: Implementing Custom Snowflake ID Field Type (TypeScript)
DESCRIPTION: This snippet defines a custom `SnowflakeField` class for NocoBase, extending `Field` to generate unique Snowflake IDs. It leverages `nodejs-snowflake` for ID generation and sets the database type to `BIGINT`. The `setValue` method ensures an ID is automatically assigned `beforeCreate` for records using this field.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/collections-fields.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { DataTypes } from 'sequelize';
// 引入算法工具包
import { Snowflake } from 'nodejs-snowflake';
// 引入字段类型基类
import { Field, BaseColumnFieldOptions } from '@nocobase/database';

export interface SnowflakeFieldOptions extends BaseColumnFieldOptions {
  type: 'snowflake';
  epoch: number;
  instanceId: number;
}

export class SnowflakeField extends Field {
  get dataType() {
    return DataTypes.BIGINT;
  }

  constructor(options: SnowflakeFieldOptions, context) {
    super(options, context);

    const {
      epoch: custom_epoch,
      instanceId: instance_id = process.env.INSTANCE_ID
        ? Number.parseInt(process.env.INSTANCE_ID)
        : 0,
    } = options;
    this.generator = new Snowflake({ custom_epoch, instance_id });
  }

  setValue = (instance) => {
    const { name } = this.options;
    instance.set(name, this.generator.getUniqueID());
  };

  bind() {
    super.bind();
    this.on('beforeCreate', this.setValue);
  }

  unbind() {
    super.unbind();
    this.off('beforeCreate', this.setValue);
  }
}

export default SnowflakeField;
```

----------------------------------------

TITLE: Modifying NocoBase Plugin Server Class (TypeScript)
DESCRIPTION: This TypeScript code extends the NocoBase `Plugin` class, defining the server-side logic for the 'hello' plugin. The `load` method is overridden to expose all actions of the 'hello' collection to the public, demonstrating basic Access Control List (ACL) configuration.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/your-fisrt-plugin.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/server';

export class PluginHelloServer extends Plugin {
  async afterAdd() {}

  async beforeLoad() {}

  async load() {
    // This is just an example. Expose all actions of the hello collection to the public
    this.app.acl.allow('hello', '*', 'public');
  }

  async install() {}

  async afterEnable() {}

  async afterDisable() {}

  async remove() {}
}

export default PluginHelloServer;
```

----------------------------------------

TITLE: Modifying Axios Default Headers (JavaScript)
DESCRIPTION: Shows how to set default headers for all outgoing Axios requests using `axios.defaults.headers.common` and `axios.defaults.headers.post`. This configures authorization and content type.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/api-client.md#_snippet_3

LANGUAGE: JavaScript
CODE:
```
axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
axios.defaults.headers.post['Content-Type'] =
  'application/x-www-form-urlencoded';
```

----------------------------------------

TITLE: Installing MySQL Client in NocoBase Docker Image (Dockerfile)
DESCRIPTION: This Dockerfile extends the NocoBase image to include MySQL client tools. It updates Debian repositories, downloads the MySQL community client core package, extracts it, and copies the 'mysqldump' and 'mysql' binaries into the system's PATH.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/backups/installation/mysql.md#_snippet_0

LANGUAGE: Dockerfile
CODE:
```
# Based on the "next" version
FROM nocobase/nocobase:latest

# Update sources.list to use the official Debian repositories
RUN tee /etc/apt/sources.list > /dev/null <<EOF
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free
deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free
EOF

# Execute the installation script.
# Please replace the link below with the appropriate MySQL version link if necessary.
RUN apt-get update && apt-get install -y wget && \
 wget https://downloads.mysql.com/archives/get/p/23/file/mysql-community-client-core_8.1.0-1debian11_amd64.deb && \
 dpkg -x mysql-community-client-core_8.1.0-1debian11_amd64.deb /tmp/mysql-client && \
 cp /tmp/mysql-client/usr/bin/mysqldump /usr/bin/ && \
 cp /tmp/mysql-client/usr/bin/mysql /usr/bin/
```

----------------------------------------

TITLE: Starting NocoBase Development Server (Bash)
DESCRIPTION: This command starts the NocoBase development server, allowing you to access the application and test the newly created and enabled plugin in a local environment.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data-modal.md#_snippet_2

LANGUAGE: bash
CODE:
```
yarn dev
```

----------------------------------------

TITLE: Creating NocoBase App (Stable, MySQL)
DESCRIPTION: This command initializes a new NocoBase project using the latest stable version, configured for a MySQL database. It sets essential database connection parameters and timezone via environment variables.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/getting-started/installation/create-nocobase-app.md#_snippet_3

LANGUAGE: bash
CODE:
```
yarn create nocobase-app my-nocobase-app -d mysql \
   -e DB_HOST=localhost \
   -e DB_PORT=3306 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=UTC \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: Authenticating Database Connection (TypeScript)
DESCRIPTION: This asynchronous function performs a database connection check and a version check. It returns a Promise that resolves when authentication is complete.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/server/application.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
authenticate(): Promise<void>
```

----------------------------------------

TITLE: Testing Database with mockDatabase() in TypeScript
DESCRIPTION: This snippet demonstrates how to use `mockDatabase()` to create an isolated database testing environment. It sets up a 'posts' collection, syncs the database, and then tests creating and retrieving a post, ensuring data isolation and proper cleanup with `beforeEach` and `afterEach` hooks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/test.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { mockDatabase } from '@nocobase/test';

describe('my db suite', () => {
  let db;

  beforeEach(async () => {
    db = mockDatabase();
    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });
    await db.sync();
  });

  afterEach(async () => {
    await db.close();
  });

  test('my case', async () => {
    const repository = db.getRepository('posts');
    const post = await repository.create({
      values: {
        title: 'hello',
      },
    });

    expect(post.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Sorting by Associated Object Fields in NocoBase Repository
DESCRIPTION: Demonstrates how to sort query results based on a field within an associated object using dot notation in the `sort` parameter.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_7

LANGUAGE: javascript
CODE:
```
await userRepository.find({
  sort: 'profile.createdAt',
});
```

----------------------------------------

TITLE: Registering Custom Authentication Type Client-Side in TypeScript
DESCRIPTION: This snippet illustrates how to register a new client-side authentication type using `plugin.registerType()`. It shows how to provide custom React components for sign-in, sign-up, and admin settings forms, allowing for a tailored authentication UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/api.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import AuthPlugin from '@nocobase/plugin-auth/client';

class CustomAuthPlugin extends Plugin {
  async load() {
    const auth = this.app.pm.get(AuthPlugin);
    auth.registerType('custom-auth-type', {
      components: {
        SignInForm,
        // SignInButton
        SignUpForm,
        AdminSettingsForm,
      },
    });
  }
}
```

----------------------------------------

TITLE: Configure NocoBase Token Client Storage Type
DESCRIPTION: Explains how to change the client-side storage for user tokens in NocoBase. By default, tokens are stored in LocalStorage for persistent sessions. Setting `API_CLIENT_STORAGE_TYPE=sessionStorage` ensures users log in every time they open the page.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/security.md#_snippet_1

LANGUAGE: Shell
CODE:
```
API_CLIENT_STORAGE_TYPE=sessionStorage
```

----------------------------------------

TITLE: NocoBase DB Hooks: Handle Data Creation with Associations (TypeScript)
DESCRIPTION: This event is triggered after data with hierarchical relationships has been created. It is invoked when `repository.create()` is called. Use this hook to perform actions that require the full associated data structure to be available.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/index.md#_snippet_19

LANGUAGE: APIDOC
CODE:
```
on(eventName: `${string}.afterCreateWithAssociations` | 'afterCreateWithAssociations', listener: CreateWithAssociationsListener): this
```

LANGUAGE: APIDOC
CODE:
```
import type { CreateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type CreateWithAssociationsListener = (
  model: Model,
  options?: CreateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('afterCreateWithAssociations', async (model, options) => {
  // 何かを行う
});

db.on('books.afterCreateWithAssociations', async (model, options) => {
  // 何かを行う
});
```

----------------------------------------

TITLE: Define NocoBase UI Block Schema with TypeScript
DESCRIPTION: This snippet defines the UI Schema for a NocoBase 'Info' block, enabling dynamic page rendering. It includes `useInfoProps` for handling dynamic component properties and `getInfoSchema` for generating the block's structure based on dynamic data sources and collections. Dependencies include `@nocobase/client` for UI Schema and data block functionalities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-data.md#_snippet_6

LANGUAGE: typescript
CODE:
```
import { useCollection, useDataBlockRequest } from "@nocobase/client";

import { InfoProps } from "../component";
import { BlockName, BlockNameLowercase } from "../constants";

export function useInfoProps(): InfoProps {
  const collection = useCollection();
  const { data, loading } = useDataBlockRequest<any[]>();

  return {
    collectionName: collection.name,
    data: data?.data,
    loading: loading
  }
}

export function getInfoSchema({ dataSource = 'main', collection }) {
  return {
    type: 'void',
    'x-decorator': 'DataBlockProvider',
    'x-decorator-props': {
      dataSource,
      collection,
      action: 'list',
    },
    'x-component': 'CardItem',
    "x-toolbar": "BlockSchemaToolbar",
    properties: {
      [BlockNameLowercase]: {
        type: 'void',
        'x-component': BlockName,
        'x-use-component-props': 'useInfoProps',
      }
    }
  }
}
```

LANGUAGE: APIDOC
CODE:
```
getInfoSchema(options: { dataSource: string, collection: string }): object
  Description: Returns the UI Schema for the Info block.
  Properties:
    type: 'void' (Indicates no data associated with this schema node)
    x-decorator: 'DataBlockProvider' (Provides data for the block)
    x-decorator-props:
      dataSource: string (The data source for the block)
      collection: string (The collection/data table for the block)
      action: 'list' (The operation type, fetches a list of data)
    x-component: 'CardItem' (Wraps the block for styling, layout, and drag-and-drop)
    properties:
      [BlockNameLowercase]:
        type: 'void'
        x-component: BlockName (The actual Info component)
        x-use-component-props: 'useInfoProps' (Specifies the function to provide dynamic props)

useInfoProps(): InfoProps
  Description: Hook to process dynamic properties for the Info component.
  Returns: InfoProps (An object containing collectionName, data, and loading status)
  Dependencies:
    useCollection(): Retrieves the current collection from DataBlockProvider context.
    useDataBlockRequest(): Fetches data block requests from DataBlockProvider context.
```

LANGUAGE: tsx
CODE:
```
<DataBlockProvider collection={collection} dataSource={dataSource} action='list'>
  <CardItem>
    <Info {...useInfoProps()} />
  </CardItem>
</DataBlockProvider>
```

----------------------------------------

TITLE: Registering Components and Schema Settings in NocoBase Plugin (TS)
DESCRIPTION: This snippet demonstrates how a NocoBase plugin, `PluginInitializerComplexDataBlockClient`, registers custom components and schema settings. During its `load` method, it adds `InfoBlock` and `InfoItem` components to the application's component registry and registers `infoBlockSettings` and `infoItemSettings` with the schema settings manager, making them available for use in the UI schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_10

LANGUAGE: ts
CODE:
```
export class PluginInitializerComplexDataBlockClient extends Plugin {
  async load() {
    this.app.addComponents({ InfoBlock, InfoItem });
    this.app.schemaSettingsManager.add(infoBlockSettings, infoItemSettings);
  }
}
```

----------------------------------------

TITLE: Defining Frontend UI Schema for Collection (TypeScript)
DESCRIPTION: This TypeScript snippet defines the frontend UI schema for the 'samplesEmailTemplates' collection. It specifies how fields like 'subject' and 'content' should be rendered in the UI, including their types, interfaces (e.g., 'input', 'richText'), titles, required status, and the NocoBase UI components to be used for rendering forms.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/plugin-settings/table.md#_snippet_6

LANGUAGE: typescript
CODE:
```
const emailTemplatesCollection = {
  name: 'samplesEmailTemplates',
  filterTargetKey: 'id',
  fields: [
    {
      type: 'string',
      name: 'subject',
      interface: 'input',
      uiSchema: {
        title: 'Subject',
        required: true,
        'x-component': 'Input',
      },
    },
    {
      type: 'text',
      name: 'content',
      interface: 'richText',
      uiSchema: {
        title: 'Content',
        required: true,
        'x-component': 'RichText',
      },
    },
  ],
};
```

----------------------------------------

TITLE: Registering Plugin Setting Page in NocoBase Client (TypeScript)
DESCRIPTION: This TypeScript/React snippet demonstrates how to register a new plugin setting page within the NocoBase client application. It imports the `Plugin` class and defines a simple `PluginSettingPage` React component. Inside the `load` method of the plugin's client class, it uses `this.app.pluginSettingsManager.add` to register the page, associating it with a title, icon, and the defined component. This makes the page accessible via the NocoBase admin settings.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/router/add-setting-page-layout-routes/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import React from 'react';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const PluginSettingPage = () => <div>
  details
</div>

export class PluginAddSettingPageLayoutRoutesClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Different Layout',
      icon: 'ApiOutlined',
      Component: PluginSettingPage,
    });
  }
}

export default PluginAddSettingPageLayoutRoutesClient;
```

----------------------------------------

TITLE: Type Definitions for Repository Find Options
DESCRIPTION: This section defines the TypeScript types and interfaces used for configuring the `find()` method's options, including filtering, field selection, appends, sorting, and pagination parameters.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/repository.md#_snippet_1

LANGUAGE: typescript
CODE:
```
type Filter = FilterWithOperator | FilterWithValue | FilterAnd | FilterOr;
type Appends = string[];
type Except = string[];
type Fields = string[];
type Sort = string[] | string;

interface SequelizeFindOptions {
  limit?: number;
  offset?: number;
}

interface FilterByTk {
  filterByTk?: TargetKey;
}

interface CommonFindOptions extends Transactionable {
  filter?: Filter;
  fields?: Fields;
  appends?: Appends;
  except?: Except;
  sort?: Sort;
}

type FindOptions = SequelizeFindOptions & CommonFindOptions & FilterByTk;
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the defined 'documentActionModalSettings' with the NocoBase application's schema settings manager. This registration occurs within the 'load' method of a NocoBase client plugin, making the settings available for use across the application's UI schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/action-modal.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';
import { documentActionModalSettings } from './settings';

export class PluginInitializerActionModalClient extends Plugin {
  async load() {
    this.app.schemaSettingsManager.add(documentActionModalSettings);
  }
}

export default PluginInitializerActionModalClient;
```

----------------------------------------

TITLE: Using useCollectionManager Hook in JSX
DESCRIPTION: Demonstrates the `useCollectionManager` hook, which provides access to the context from `CollectionManagerProvider`. It allows destructuring properties like `collections` (all managed collections) and `get` (a method to retrieve a specific collection).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/extensions/collection-manager.md#_snippet_6

LANGUAGE: jsx
CODE:
```
const { collections, get } = useCollectionManager();
```

----------------------------------------

TITLE: Implementing Lazy Loading SchemaSettings Item (Switch Type) in NocoBase
DESCRIPTION: This snippet defines `lazySchemaSettingsItem`, a `SchemaSettingsItemType` of `switch` type. Similar to `objectFit`, it uses `useFieldSchema` and `useDesignable` to manage schema updates. This item provides a toggle for enabling or disabling lazy loading for a component, updating the `lazy` property within the `x-decorator-props` of the current schema node.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-settings/new.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettingsItemType, useDesignable, } from "@nocobase/client";
import { useFieldSchema } from '@formily/react';
import { useT } from "../../locale";
import { BlockNameLowercase } from "../../constants";

export const lazySchemaSettingsItem: SchemaSettingsItemType = {
  name: 'lazy',
  type: 'switch',
  useComponentProps() {
    const filedSchema = useFieldSchema();
    const { deepMerge } = useDesignable();
    const t = useT();

    return {
      title: t('Lazy'),
      checked: !!filedSchema['x-decorator-props']?.[BlockNameLowercase]?.lazy,
      onChange(v) {
        deepMerge({
          'x-uid': filedSchema['x-uid'],
          'x-decorator-props': {
            ...filedSchema['x-decorator-props'],
            [BlockNameLowercase]: {
              ...filedSchema['x-decorator-props']?.[BlockNameLowercase],
              lazy: v,
            },
          },
        })
      },
    };
  },
};
```

----------------------------------------

TITLE: Registering Admin Settings Layout Route in NocoBase (TypeScript)
DESCRIPTION: This snippet registers the 'admin.settings' route, mapping the '/admin/settings/*' path to the `AdminSettingsLayout` component. This route is specifically designed for plugin configuration pages, with menus and tabs managed by `app.pluginSettingsManager`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/router.md#_snippet_4

LANGUAGE: typescript
CODE:
```
router.add('admin.settings', {
  path: '/admin/settings/*',
  Component: AdminSettingsLayout,
});
```

----------------------------------------

TITLE: Initializing a Calendar Collection with a Template in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to initialize a specialized NocoBase collection named 'events' by applying a predefined 'calendar' template. This approach automatically configures the collection with specific fields like 'cron' and 'exclude' as defined by the template.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/collection-template.md#_snippet_3

LANGUAGE: ts
CODE:
```
db.collection({
  name: 'events',
  template: 'calendar',
});
```

----------------------------------------

TITLE: Importing Collections and Setting ACL in a NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how a NocoBase plugin's `load()` method imports collection definitions from a specified directory using `this.db.import()`. It also temporarily sets broad ACL permissions for 'products', 'categories', and 'orders' collections for testing purposes.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections-fields.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
import path from 'path';
import { Plugin } from '@nocobase/server';

export default class ShopPlugin extends Plugin {
  async load() {
    await this.db.import({
      directory: path.resolve(__dirname, 'collections'),
    });

    this.app.acl.allow('products', '*');
    this.app.acl.allow('categories', '*');
    this.app.acl.allow('orders', '*');
  }
}
```

----------------------------------------

TITLE: Registering a Global Data Provider with NocoBase Application (TypeScript)
DESCRIPTION: This code demonstrates how to register the `PluginSettingsTableProvider` globally within a NocoBase plugin's client-side `load` method. By calling `this.app.addProvider()`, the provider becomes available across the entire NocoBase application, allowing components to access the shared configuration data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_23

LANGUAGE: ts
CODE:
```
import { PluginSettingsTableProvider } from './PluginSettingsTableProvider'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...
    this.app.addProvider(PluginSettingsTableProvider)
  }
}
```

----------------------------------------

TITLE: Defining Schema Node Types in TypeScript
DESCRIPTION: This TypeScript snippet defines the `SchemaTypes` union type, which enumerates all possible types for a UI Schema node (string, object, array, number, boolean, void). It also shows how this `type` property is integrated into the `ISchema` interface, indicating the fundamental nature of the schema node.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/what-is-ui-schema.md#_snippet_5

LANGUAGE: typescript
CODE:
```
type SchemaTypes =
  | 'string'
  | 'object'
  | 'array'
  | 'number'
  | 'boolean'
  | 'void';
interface ISchema {
  type?: SchemaTypes;
}
```

----------------------------------------

TITLE: Defining a Resource with ActionOptions for List Action in NocoBase ResourceManager (TypeScript)
DESCRIPTION: This snippet demonstrates defining a 'users' resource where the `list` action is configured using `ActionOptions`. This allows overriding default request parameters like `fields` and `filter` for the `list` operation, providing fine-grained control over how data is retrieved for this specific action.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/resourcer/resource-manager.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
app.resourceManager.define({
  name: 'users',
  actions: {
    list: {
      fields: [],
      filter: {},
      // ...
    },
  },
});
```

----------------------------------------

TITLE: Replace AuthLayout Component via Router Override in NocoBase Client Plugin (TypeScript)
DESCRIPTION: This TypeScript code demonstrates how to dynamically replace a default NocoBase component by overriding its associated route. Within a client-side plugin, the `router.add()` method is used to map the 'auth' route name to the `CustomAuthLayout` component, effectively replacing the original layout for authentication pages.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/router/replace-page/index.md#_snippet_3

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/client';
import { CustomAuthLayout } from './AuthLayout';

export class PluginReplacePageClient extends Plugin {
  async load() {
    this.app.router.add('auth', {
      Component: CustomAuthLayout,
    });
  }
}

export default PluginReplacePageClient;
```

----------------------------------------

TITLE: Define Info Block React Component with Dynamic Schema Props
DESCRIPTION: This React component defines the structure and behavior of the 'Info' data block. It uses `withDynamicSchemaProps` to handle dynamic properties from the UI schema, displaying the collection name and a JSON representation of the data list. It expects `collectionName`, `data`, and `loading` as props.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-data.md#_snippet_2

LANGUAGE: tsx
CODE:
```
import React, { FC } from 'react';
import { withDynamicSchemaProps } from '@nocobase/client'
import { BlockName } from '../constants';

export interface InfoProps {
  collectionName: string;
  data?: any[];
  loading?: boolean;
}

export const Info: FC<InfoProps> = withDynamicSchemaProps(({ collectionName, data }) => {
  return <div>
    <div>collection: {collectionName}</div>
    <div>data list: <pre>{JSON.stringify(data, null, 2)}</pre></div>
  </div>
}, { displayName: BlockName })
```

----------------------------------------

TITLE: Registering New Schema Initializer in NocoBase Plugin (TypeScript)
DESCRIPTION: This example demonstrates how to register a newly defined `SchemaInitializer` instance with the application's `schemaInitializerManager` using the `add()` method within a NocoBase plugin's `load` lifecycle method. It includes a detailed `helloBlock` item configuration that inserts a simple 'Hello, world!' `h1` component into the schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/initializer.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class PluginDemoAddSchemaInitializer extends Plugin {
  async load() {
    const myInitializer = new SchemaInitializer({
      name: 'myInitializer',
      title: 'Add block',
      wrap: Grid.wrap,
      items: [
        {
          name: 'helloBlock',
          type: 'item',
          useComponentProps() {
            const { insert } = useSchemaInitializer();
            return {
              title: 'Hello',
              onClick: () => {
                insert({
                  type: 'void',
                  'x-decorator': 'CardItem',
                  'x-component': 'h1',
                  'x-content': 'Hello, world!',
                });
              },
            };
          },
        },
      ],
    });
    this.schemaInitializerManager.add(myInitializer);
  }
}
```

----------------------------------------

TITLE: Triggering Workflow for Single Data Entry via HTTP API (Bash)
DESCRIPTION: This `curl` command demonstrates how to trigger a NocoBase workflow for a single, existing data entry. It uses a POST request to the `samples:trigger` endpoint, requiring the data row's ID (`<:id>`) and specifying the workflow key via the `triggerWorkflows` parameter. Authentication headers (`Authorization` and `X-Role`) are mandatory.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow-custom-action-trigger/http-api.md#_snippet_0

LANGUAGE: bash
CODE:
```
curl -X POST -H 'Authorization: Bearer <your token>' -H 'X-Role: <roleName>' \
  "http://localhost:3000/api/samples:trigger/<:id>?triggerWorkflows=workflowKey"
```

----------------------------------------

TITLE: Registering New Schema Settings in Plugin (TypeScript)
DESCRIPTION: Demonstrates how to register a newly defined 'SchemaSettings' instance globally within a NocoBase plugin's 'load' method using 'schemaSettingsManager.add()'. This makes the settings available for use across the application. It also shows how to define an item with dynamic properties using 'useComponentProps'.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/settings.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class PluginDemoAddSchemaSettings extends Plugin {
  async load() {
    // Register global components
    this.app.addComponents({ CardItem, HomePage });
    const mySettings = new SchemaSettings({
      name: 'mySettings',
      items: [
        {
          type: 'item',
          name: 'edit',
          useComponentProps() {
            // TODO: Add relevant settings logic
            return {
              title: 'Edit',
              onClick() {
                // todo
              },
            };
          },
        },
      ],
    });
    this.schemaSettingsManager.add(mySettings);
  }
}
```

----------------------------------------

TITLE: Defining NocoBase Field Component UI Schema (TypeScript)
DESCRIPTION: This snippet defines a NocoBase UI Schema for the `OrderDetails` field component. The `getOrderDetailsSchema` function returns an `ISchema` object that specifies the component's type (`void`), its decorator (`FormItem`), toolbar (`FormItemSchemaToolbar`), the component itself (`FieldComponentName`), and its properties (`x-component-props`) including `orderField`. This schema is used to dynamically render the `OrderDetails` component within the NocoBase UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/field/without-value.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
import { ISchema } from "@nocobase/client"
import { FieldComponentName } from '../constants';

export const getOrderDetailsSchema = (orderField: string): ISchema => ({
  type: 'void',
  'x-decorator': 'FormItem',
  'x-toolbar': 'FormItemSchemaToolbar',
  'x-component': FieldComponentName,
  'x-component-props': {
    'orderField': orderField,
  }
})
```

----------------------------------------

TITLE: Configuring x-initializer for Grid Component (TypeScript)
DESCRIPTION: This snippet demonstrates how to apply the `x-initializer` parameter to a `Grid` component in a UI schema. The `x-initializer` property specifies a schema initializer to be rendered. Note that only `Grid`, `ActionBar`, and `Tabs` components natively support this parameter, while custom components can use `useSchemaInitializerRender()` for handling.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/what-is-ui-schema.md#_snippet_32

LANGUAGE: TypeScript
CODE:
```
{
  type: 'void',
  'x-component': 'Grid',
  'x-initializer': 'myInitializer',
}
```

----------------------------------------

TITLE: Defining Data Table Collection (TypeScript)
DESCRIPTION: This snippet illustrates how to define a data table collection in memory using the `collection` method, similar to Sequelize's `define`. It specifies the table name and its fields. To persist this definition to the actual database, the `sync` method must be called subsequently.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'books',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
    {
      type: 'float',
      name: 'price',
    },
  ],
});

// sync collection as table to db
await db.sync();
```

----------------------------------------

TITLE: Registering Custom Password Field Type in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to extend NocoBase's field types by registering a custom 'password' field. It involves creating a 'PasswordField' class that extends 'Field' and defines its 'dataType', then registering it within a NocoBase plugin's 'beforeLoad' method. This allows the database to correctly handle the new field type.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/collections/field-extension.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
export class MyPlugin extends Plugin {
  beforeLoad() {
    this.db.registerFieldTypes({
      password: PasswordField,
    });
  }
}

export class PasswordField extends Field {
  get dataType() {
    return DataTypes.STRING;
  }
}
```

----------------------------------------

TITLE: Registering Custom Snowflake Field Type in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet shows how to register the newly defined `SnowflakeField` into the NocoBase database instance within a plugin's `initialize` method. By calling `this.db.registerFieldTypes({ snowflake: SnowflakeField })`, the custom `snowflake` type becomes available for use in collection definitions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_9

LANGUAGE: ts
CODE:
```
import SnowflakeField from '. /fields/snowflake';

export default class ShopPlugin extends Plugin {
  initialize() {
    // ...
    this.db.registerFieldTypes({
      snowflake: SnowflakeField,
    });
    // ...
  }
}
```

----------------------------------------

TITLE: Implementing Custom Authentication Class with Auth Abstract Class (TypeScript)
DESCRIPTION: This snippet demonstrates how to extend the `Auth` abstract class from `@nocobase/auth` to create a custom authentication type. It shows the basic structure for implementing required methods like `check()` and `signIn()`, which are essential for handling authentication logic within NocoBase. This approach is used when building a new authentication mechanism from scratch.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/auth/dev/guide.md#_snippet_0

LANGUAGE: typescript
CODE:
```
import { Auth } from '@nocobase/auth';

class CustomAuth extends Auth {
  set user(user) {}
  get user() {}

  async check() {}
  async signIn() {}
}
```

----------------------------------------

TITLE: Example: Registering a Custom Workflow Trigger
DESCRIPTION: This example illustrates how to define and register a custom trigger (`MyTrigger`) that extends the `Trigger` base class. It demonstrates implementing `on` and `off` methods for event subscription and unsubscription, and how to use `this.workflow.trigger()` to initiate a workflow based on a custom event.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/handbook/workflow/development/api.md#_snippet_2

LANGUAGE: typescript
CODE:
```
import PluginWorkflowServer, { Trigger } from '@nocobase/plugin-workflow;

function handler(this: MyTrigger, workflow: WorkflowModel, message: string) {
  // trigger workflow
  this.workflow.trigger(workflow, { data: message.data });
}

class MyTrigger extends Trigger {
  messageHandlers: Map<number, WorkflowModel> = new Map();
  on(workflow: WorkflowModel) {
    const messageHandler = handler.bind(this, workflow);
    // listen some event to trigger workflow
    process.on(
      'message',
      this.messageHandlers.set(workflow.id, messageHandler),
    );
  }

  off(workflow: WorkflowModel) {
    const messageHandler = this.messageHandlers.get(workflow.id);
    // remove listener
    process.off('message', messageHandler);
  }
}

export default class MyPlugin extends Plugin {
  load() {
    // get workflow plugin instance
    const workflowPlugin =
      this.app.pm.get<PluginWorkflowServer>(PluginWorkflowServer);

    // register trigger
    workflowPlugin.registerTrigger('myTrigger', MyTrigger);
  }
}
```

----------------------------------------

TITLE: Querying by Nested Associated Fields in NocoBase Repository
DESCRIPTION: Shows how to perform queries on deeply nested associated fields using extended dot notation in the `filter` parameter. The example finds users whose associated posts have comments containing specific keywords.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/repository.md#_snippet_5

LANGUAGE: javascript
CODE:
```
// Find the user objects whose associated posts have comments containing "keywords"
await userRepository.find({
  filter: {
    'posts.comments.content': {
      $like: '%keywords%',
    },
  },
});
```

----------------------------------------

TITLE: Overriding a NocoBase Route with a Custom Component
DESCRIPTION: This snippet shows how a custom NocoBase plugin can replace an existing route, such as 'auth.login', by adding a new route definition with the same name but pointing to a 'CustomLoginPage' component. This method allows for complete replacement of a page's routing and associated component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/component-and-scope/index.md#_snippet_2

LANGUAGE: ts
CODE:
```
class CustomPlugin extends Plugin {
  async load() {
    this.app.router.add('auth.login', {
      path: '/login',
      Component: CustomLoginPage,
    })
  }
}
```

----------------------------------------

TITLE: Using useCollectionField Hook in JSX
DESCRIPTION: Shows the `useCollectionField` hook, which provides access to the context from `CollectionFieldProvider`. It allows destructuring properties like `name`, `uiSchema` (UI configuration), and `resource` (for record-level data context, typically with `RecordProvider`).
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/extensions/collection-manager.md#_snippet_8

LANGUAGE: jsx
CODE:
```
const { name, uiSchema, resource } = useCollectionField();
```

----------------------------------------

TITLE: Extend Schema Components: Achieving Dynamic Props with withDynamicSchemaProps
DESCRIPTION: The `withDynamicSchemaProps` utility is used to non-invasively achieve dynamic properties for schema components. This method allows for flexible property manipulation without altering the component's original structure.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/client/ui-schema/extending.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Method: withDynamicSchemaProps
Description: Used to non-invasively achieve dynamic props for schema components.
Usage: Typically wraps a component to enable dynamic property assignment based on schema context or other reactive data.
```

----------------------------------------

TITLE: NocoBase TS: Register Page Component with Router
DESCRIPTION: This code shows how to integrate a new page component, `PluginSettingsTablePage`, into the NocoBase application router. It adds a new route path, `/admin/plugin-settings-table-page`, and associates it with the component, making the page accessible within the NocoBase admin interface.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/plugin-settings/table.md#_snippet_15

LANGUAGE: ts
CODE:
```
import { PluginSettingsTablePage } from './PluginSettingsTablePage'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...

    this.app.router.add(`admin.${name}-page`, {
      path: '/admin/plugin-settings-table-page',
      Component: PluginSettingsTablePage,
    })
  }
}
```

----------------------------------------

TITLE: Register Custom Component and Route Globally (TypeScript/TSX)
DESCRIPTION: This snippet modifies the plugin's index.ts to globally register SamplesCustomPage using this.app.addComponents(). It also adds a new administrative route, /admin/custom-page1, mapping it to the globally registered SamplesCustomPage component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/component-and-scope/global.md#_snippet_2

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { SamplesCustomPage } from './CustomPage'

export class PluginComponentAndScopeGlobalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page1', {
      path: '/admin/custom-page1',
      Component: 'SamplesCustomPage',
    })

    this.app.addComponents({ SamplesCustomPage })
  }
}

export default PluginComponentAndScopeGlobalClient;
```

----------------------------------------

TITLE: Importing Collection Configurations in a Plugin (TypeScript)
DESCRIPTION: This example demonstrates how a NocoBase plugin can import collection configurations from a specified directory during its loading phase. It uses `path.resolve(__dirname, './collections')` to point to the directory containing collection definition files like `books.ts`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_10

LANGUAGE: ts
CODE:
```
class Plugin {
  async load() {
    await this.app.db.import({
      directory: path.resolve(__dirname, './collections'),
    });
  }
}
```

----------------------------------------

TITLE: Creating Association Resource (NocoBase HTTP API)
DESCRIPTION: This snippet demonstrates how to create a new association resource linked to a specific collection using NocoBase's custom HTTP API. It uses a POST request to the nested endpoint /api/<collection>/<collectionIndex>/<association>:create and expects a JSON body for the new association's data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_10

LANGUAGE: bash
CODE:
```
POST    /api/<collection>/<collectionIndex>/<association>:create

{} # JSON body
```

----------------------------------------

TITLE: Deleting Collection Resource by ID (NocoBase HTTP API)
DESCRIPTION: This snippet demonstrates how to delete a specific collection resource by its primary key using NocoBase's custom HTTP API. It uses a POST request, supporting filterByTk query parameter or embedding the ID directly in the path.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_8

LANGUAGE: bash
CODE:
```
POST      /api/<collection>:destroy?filterByTk=<collectionIndex>
# 或者
POST      /api/<collection>:destroy/<collectionIndex>
```

----------------------------------------

TITLE: Creating a New User (Bash)
DESCRIPTION: This example illustrates how to create a new user resource via a POST request to `/api/users:create`. The request body contains the `email` and `name` fields for the new user. The expected response is a 200 OK with an empty `data` object, indicating successful creation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/http-api/action-api.md#_snippet_1

LANGUAGE: bash
CODE:
```
POST  /api/users:create

Request Body
{
  "email": "demo@nocobase.com",
  "name": "Admin"
}

Response 200 (application/json)
{
  "data": {},
}
```

----------------------------------------

TITLE: Deleting Collection Resource by ID (Standard REST API)
DESCRIPTION: This snippet demonstrates how to delete a specific collection resource by its primary key using standard RESTful API conventions. It uses a DELETE request to the /api/<collection>/<collectionIndex> endpoint.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_9

LANGUAGE: bash
CODE:
```
DELETE    /api/<collection>/<collectionIndex>
```

----------------------------------------

TITLE: Creating Association Resource (Standard REST API)
DESCRIPTION: This snippet demonstrates how to create a new association resource linked to a specific collection using standard RESTful API conventions. It uses a POST request to the nested endpoint /api/<collection>/<collectionIndex>/<association> and expects a JSON body for the new association's data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_11

LANGUAGE: bash
CODE:
```
POST    /api/<collection>/<collectionIndex>/<association>

{} # JSON body
```

----------------------------------------

TITLE: Updating Association Resource by ID (Standard REST API)
DESCRIPTION: This snippet shows how to update an existing association resource by its primary key, linked to a collection, using standard RESTful API conventions. It uses a PUT request to the nested endpoint /api/<collection>/<collectionIndex>/<association>:update/<associationIndex>, with the updated resource data in the JSON body.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/http-api/rest-api.md#_snippet_17

LANGUAGE: bash
CODE:
```
PUT    /api/<collection>/<collectionIndex>/<association>:update/<associationIndex>

{} # JSON 数据
```

----------------------------------------

TITLE: Delete Data Objects with Repository
DESCRIPTION: Explains how to perform delete operations using the `Repository`'s `destroy()` method. A filter condition must be specified to determine which records to delete.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/repository.md#_snippet_10

LANGUAGE: JavaScript
CODE:
```
await userRepository.destroy({
  filter: {
    status: 'blocked',
  },
});
```

----------------------------------------

TITLE: Update Data Objects with Repository
DESCRIPTION: Covers two methods for updating data: directly modifying a retrieved `Model` object and calling `save()`, or using `Repository.update()` with filter conditions. It also shows controlling update fields using the `whitelist` parameter.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/repository.md#_snippet_8

LANGUAGE: JavaScript
CODE:
```
const user = await userRepository.findOne({
  filter: {
    name: '张三',
  },
});

user.age = 20;
await user.save();
```

LANGUAGE: JavaScript
CODE:
```
// フィルタ条件に一致するデータレコードを更新
await userRepository.update({
  filter: {
    name: '张三',
  },
  values: {
    age: 20,
  },
});
```

LANGUAGE: JavaScript
CODE:
```
await userRepository.update({
  filter: {
    name: '张三',
  },
  values: {
    age: 20,
    name: '李四',
  },
  whitelist: ['age'], // age フィールドのみ更新
});
```

----------------------------------------

TITLE: Schema Node Insertion Points in TypeScript
DESCRIPTION: This TypeScript object literal demonstrates various insertion points for new schema nodes within an existing schema structure. It illustrates how new properties can be placed relative to a current node or its children, using comments to indicate 'beforeBegin', 'afterBegin', 'beforeEnd', and 'afterEnd' positions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/client/schema-designer/schema-initializer.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
{
  properties: {
    // beforeBegin - Insert in front of the current node
    node1: {
      properties: {
        // afterBegin - Insert in front of the first child node of the current node
        // ...
        // beforeEnd - After the last child node of the current node
      },
    },
    // afterEnd - After the current node
  },
}
```

----------------------------------------

TITLE: Basic Schema Rendering with React and NocoBase Client
DESCRIPTION: This snippet demonstrates the fundamental usage of `SchemaComponentProvider` to establish a rendering context and `SchemaComponent` to render a defined schema. It shows how to register a custom React component ('Hello') and link it to the schema via 'x-component'.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/ui-schema/rendering.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const Hello = () => <h1>Hello, world!</h1>;

const schema = {
  type: 'void',
  name: 'hello',
  'x-component': 'Hello'
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Globally Registering Component and Route in NocoBase Plugin
DESCRIPTION: This snippet demonstrates how to register a custom React component (`SamplesCustomPage`) globally using `this.app.addComponents()` and then associate it with a new route (`/admin/custom-page1`) using `this.app.router.add()`. The string-based `Component` field in `add()` automatically resolves to the globally registered component.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/component-and-scope/global.md#_snippet_4

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { SamplesCustomPage } from './CustomPage'

export class PluginComponentAndScopeGlobalClient extends Plugin {
  async load() {
    this.app.router.add('admin.custom-page1', {
      path: '/admin/custom-page1',
      Component: 'SamplesCustomPage',
    })

    this.app.addComponents({ SamplesCustomPage })
  }
}

export default PluginComponentAndScopeGlobalClient;
```

----------------------------------------

TITLE: Implement 'Remove Block' Operation in NocoBase Schema Settings
DESCRIPTION: This snippet guides on adding a built-in `remove` operation to the block's schema settings. It explains the `removeParentsIfNoChildren` property for recursive parent removal and `breakRemoveOn` for specifying conditions (e.g., `{'x-component': 'Grid'}`) to halt the removal process, ensuring controlled UI element deletion.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_14

LANGUAGE: typescript
CODE:
```
import { SchemaSettings } from '@nocobase/client';
import { FormV3BlockNameLowercase } from '../constants';

export const formV3Settings = new SchemaSettings({
  name: `blockSettings:${FormV3BlockNameLowercase}`,
  items: [
    {
      type: 'remove',
      name: 'remove',
      componentProps: {
        removeParentsIfNoChildren: true,
        breakRemoveOn: {
          'x-component': 'Grid'
        }
      }
    }
  ]
});
```

----------------------------------------

TITLE: Defining NocoBase SchemaSettingsItem (TypeScript)
DESCRIPTION: This snippet defines a basic `SchemaSettingsItemType` named `showIndex` with a `switch` type. It serves as a placeholder for a new configuration item within NocoBase's SchemaSettings, initially returning an empty object for component properties.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-settings/add-item.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import { SchemaSettingsItemType, useDesignable } from '@nocobase/client';
import { useFieldSchema } from '@formily/react';

export const tableShowIndexSettingsItem: SchemaSettingsItemType = {
  name: 'showIndex',
  type: 'switch',
  useComponentProps() {
    return {};
  },
};
```

----------------------------------------

TITLE: Basic Schema Rendering with React TSX
DESCRIPTION: Demonstrates the fundamental setup for rendering a schema using `SchemaComponentProvider` to supply component context and `SchemaComponent` to render the defined schema. It shows how to register a custom React component ('Hello') to be used within the schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/rendering.md#_snippet_0

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

const Hello = () => <h1>Hello, world!</h1>;

const schema = {
  type: 'void',
  name: 'hello',
  'x-component': 'Hello'
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: NocoBase API: SchemaComponent React Component
DESCRIPTION: A React component used to render a NocoBase UI Schema. It takes a `schema` prop to define the structure and content to be rendered.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/block-data.md#_snippet_14

LANGUAGE: APIDOC
CODE:
```
{
  "name": "SchemaComponent",
  "type": "React Component",
  "description": "Used to render a NocoBase UI Schema.",
  "properties": [
    {"name": "schema", "type": "object", "description": "The UI Schema object to be rendered."}
  ],
  "link": "https://client.docs.nocobase.com/core/ui-schema/schema-component#schemacomponent-1"
}
```

----------------------------------------

TITLE: Defining Deliveries Collection Schema (TypeScript)
DESCRIPTION: This code defines the schema for a new 'deliveries' collection. It includes fields for linking to an 'order', storing the 'provider' and 'trackingNumber', and managing the 'status' of the delivery. This collection is used to store detailed shipping information.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/server/resources-actions.md#_snippet_1

LANGUAGE: typescript
CODE:
```
export default {
  name: 'deliveries',
  fields: [
    {
      type: 'belongsTo',
      name: 'order',
    },
    {
      type: 'string',
      name: 'provider',
    },
    {
      type: 'string',
      name: 'trackingNumber',
    },
    {
      type: 'integer',
      name: 'status',
    },
  ],
};
```

----------------------------------------

TITLE: Define Independent and Associated Resources
DESCRIPTION: Demonstrates how to define independent data type resources (e.g., 'posts') and associated resources (e.g., 'posts.user', 'posts.comments') using `app.resource()`, which is equivalent to `app.resourcer.define()`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/resources-actions.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
// app.resourcer.define() is equivalent

// Define post resource
app.resource({
  name: 'posts'
});

// Define post author resource
app.resource({
  name: 'posts.user'
});

// Define post comments resource
app.resource({
  name: 'posts.comments'
});
```

----------------------------------------

TITLE: Conditionally Caching Data with wrapWithCondition in TypeScript
DESCRIPTION: This method is similar to `wrap()` but allows for conditional caching based on external parameters or data results. It takes a cache `key`, a function `fn` to generate the value, and an `options` object to control caching behavior, including `useCache` for external control, `isCacheable` for data-based conditions, and `ttl` for time-to-live.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/cache/cache.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
async wrapWithCondition<T>(
  key: string,
  fn: () => T | Promise<T>,
  options?: {
    // External parameter to control whether to use cache results
    useCache?: boolean;
    // Determine whether to cache based on data results
    isCacheable?: (val: unknown) => boolean | Promise<boolean>;
    ttl?: Milliseconds;
  },
): Promise<T> {
```

----------------------------------------

TITLE: Integrate Custom Refresh Action into NocoBase Initializer (TypeScript)
DESCRIPTION: This TypeScript snippet modifies the `configureActionsInitializer` by adding `customRefreshActionInitializerItem` to its `items` array. This integration makes the custom refresh action available as an option within the 'Configure Actions' initializer in the NocoBase administration interface, allowing users to easily add this functionality.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/configure-actions.md#_snippet_9

LANGUAGE: typescript
CODE:
```
import { SchemaInitializer } from "@nocobase/client";
import { customRefreshActionInitializerItem } from "./items/customRefresh";

export const configureActionsInitializer = new SchemaInitializer({
  name: 'info:configureActions',
  title: 'アクションの設定',
  icon: 'SettingOutlined',
  style: {
    marginLeft: 8,
  },
  items: [
    {
      name: 'customRequest',
      title: '{{t("カスタムリクエスト")}}',
      Component: 'CustomRequestInitializer',
      'x-align': 'right',
    },
    customRefreshActionInitializerItem
  ]
});
```

----------------------------------------

TITLE: Add Custom Block to NocoBase 'Add block' Menu
DESCRIPTION: This snippet demonstrates how to integrate a new custom block (FormV3) into the NocoBase UI's 'Add block' functionality using `app.schemaInitializerManager.addItem`. It highlights the importance of identifying the correct `name` attributes (e.g., `page:addBlock`, `dataBlocks`) for proper placement within the UI hierarchy, allowing the new block to appear in the 'Add block' menu.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_9

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';

import { FormV3 } from './FormV3';
import { useFormV3Props } from './FormV3.schema';
import { formV3InitializerItem } from './FormV3.initializer';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.addComponents({ FormV3 });
    this.app.addScopes({ useFormV3Props });

    this.app.schemaInitializerManager.addItem('page:addBlock', `dataBlocks.${formV3InitializerItem.name}`, formV3InitializerItem);
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Installing PostgreSQL Client in Docker (Bash)
DESCRIPTION: This Bash script checks for the presence of `pg_dump` and, if not found, proceeds to install the PostgreSQL client (version 16) within a Debian-based Docker environment. It updates package lists, installs `wget` and `gnupg`, configures the PostgreSQL APT repository, and then installs `postgresql-client-16` to enable database interaction.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/backups/install.md#_snippet_1

LANGUAGE: bash
CODE:
```
#!/bin/bash

# Check if pg_dump is installed
if [ ! -f /usr/bin/pg_dump ]; then
    echo "pg_dump is not installed, starting PostgreSQL client installation..."

    # Install necessary tools and clean cache
    apt-get update && apt-get install -y --no-install-recommends wget gnupg \
      && rm -rf /var/lib/apt/lists/*

    # Configure PostgreSQL source
    echo "deb [signed-by=/usr/share/keyrings/pgdg.asc] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O /usr/share/keyrings/pgdg.asc https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc

    # Install PostgreSQL client
    apt-get update && apt-get install -y --no-install-recommends postgresql-client-16 \
      && rm -rf /var/lib/apt/lists/*

    echo "PostgreSQL client installation completed."
else
    echo "pg_dump is already installed, skipping PostgreSQL client installation."
fi
```

----------------------------------------

TITLE: NocoBase: Manage Relationship Block Field Permissions
DESCRIPTION: This section explains that the permissions for fields displayed within a relationship block are governed by the permissions set on the target table's fields. It demonstrates how to configure the target table to allow viewing of only specific fields within the block.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/acl/user/index.md#_snippet_8

LANGUAGE: APIDOC
CODE:
```
Configuration:
  - Target Table: Customer
  - Field Permissions (Customer Table):
    - Specific fields: Configured for 'View only' access

UI Behavior:
  - Only the specifically configured fields within the 'Customer' relationship block are visible.
```

----------------------------------------

TITLE: Creating Multiple Records by Count with mockRecords (TypeScript)
DESCRIPTION: This snippet illustrates how to use `mockRecords` to generate a specified number of records for a given collection. Here, it creates 10 records for the 'posts' collection, useful for populating test data quickly.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/test/e2e.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
import { test } from '@nocobase/test/e2e';

test('learn how to use mockRecords', async ({ mockRecords }) => {
  await mockRecords('posts', 10);
});
```

----------------------------------------

TITLE: Defining Server-side Plugin Lifecycle Hook in NocoBase TypeScript
DESCRIPTION: This snippet illustrates the 'beforeLoad' lifecycle hook within a NocoBase server-side plugin class. The 'beforeLoad' method is an asynchronous function that is executed before the plugin's main loading process, providing an opportunity to perform initial setup or resource preparation. It's a common entry point for plugin initialization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/life-cycle.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
class PluginSampleHelloServer extends Plugin {
  async beforeLoad() {}
}
```

----------------------------------------

TITLE: Defining Server-side Plugin Lifecycle Hook (TypeScript)
DESCRIPTION: This TypeScript example illustrates the basic structure for defining a server-side plugin's lifecycle hook. It shows an empty `beforeLoad` asynchronous method within a `Plugin` class, which serves as an entry point for plugin-specific initialization logic before the application fully loads.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/life-cycle.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
class PluginSampleHelloServer extends Plugin {
  async beforeLoad() {}
}
```

----------------------------------------

TITLE: Defining NocoBase Schema Initializer Item for Timeline Block (TSX)
DESCRIPTION: This code defines `timelineInitializerItem`, a NocoBase Schema Initializer Item. Its `Component`, `TimelineInitializerComponent`, uses `DataBlockInitializer` to enable users to select a collection and data source, then configure `timeField` and `titleField` via a form. Upon submission, it generates and inserts a timeline schema into the page, facilitating dynamic block creation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-data-modal.md#_snippet_6

LANGUAGE: TSX
CODE:
```
import React, { useCallback, useState } from 'react';
import { FieldTimeOutlined } from '@ant-design/icons';
import { DataBlockInitializer, SchemaInitializerItemType, useSchemaInitializer } from "@nocobase/client";

import { getTimelineSchema } from '../schema';
import { useT } from '../locale';
import { TimelineConfigFormProps, TimelineInitializerConfigForm } from './ConfigForm';
import { BlockName, BlockNameLowercase } from '../constants';

export const TimelineInitializerComponent = () => {
  const { insert } = useSchemaInitializer();
  const [collection, setCollection] = useState<string>();
  const [dataSource, setDataSource] = useState<string>();
  const [showConfigForm, setShowConfigForm] = useState(false);
  const t = useT()

  const onSubmit: TimelineConfigFormProps['onSubmit'] = useCallback((values) => {
    const schema = getTimelineSchema({ collection, dataSource, timeField: values.timeField, titleField: values.titleField });
    insert(schema);
  }, [collection, dataSource])

  return <>
    {showConfigForm && <TimelineInitializerConfigForm
      visible={showConfigForm}
      setVisible={setShowConfigForm}
      onSubmit={onSubmit}
      collection={collection}
      dataSource={dataSource}
    />}
    <DataBlockInitializer
      name={BlockNameLowercase}
      title={t(BlockName)}
      icon={<FieldTimeOutlined />}
      componentType={BlockName}
      onCreateBlockSchema={({ item }) => {
        const { name: collection, dataSource } = item;
        setCollection(collection);
        setDataSource(dataSource);
        setShowConfigForm(true);
      }}>

    </DataBlockInitializer>
  </>
}

export const timelineInitializerItem: SchemaInitializerItemType = {
  name: 'Timeline',
  Component: TimelineInitializerComponent,
}
```

----------------------------------------

TITLE: Utilize NocoBase AuthModel Methods for User Management
DESCRIPTION: The `AuthModel` provides convenient methods for searching and creating user records within your custom authentication logic. This TypeScript snippet demonstrates how to access and use `findUser()`, `newUser()`, and `findOrCreateUser()` methods via `this.authenticator` for efficient user data operations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/auth/dev/guide.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import { AuthModel } from '@nocobase/plugin-auth';

class CustomAuth extends BaseAuth {
  async validate() {
    // ...
    const authenticator = this.authenticator as AuthModel;
    this.authenticator.findUser(); // Search for user
    this.authenticator.newUser(); // Create new user
    this.authenticator.findOrCreateUser(); // Search for or create user
    // ...
  }
}
```

----------------------------------------

TITLE: Using useCollection Hook (JSX)
DESCRIPTION: The `useCollection` hook provides context about the current collection being processed. It requires `<CollectionProvider/>` to be present in the component tree. This snippet shows how to destructure properties such as `name`, `fields`, `getField`, `findField`, and `resource` to interact with the current collection's schema and data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/client/extensions/collection-manager.md#_snippet_11

LANGUAGE: JSX
CODE:
```
const { name, fields, getField, findField, resource } = useCollection();
```

----------------------------------------

TITLE: Inserting Schema with createDesignable in React
DESCRIPTION: This React component illustrates the use of `createDesignable` to insert a new schema node at an adjacent position relative to a *specified* schema node, rather than the current one. It demonstrates how to obtain a designable instance for a specific schema property (`hello2`) and then use its `insertAdjacent` method to add a new 'Hello' component `afterEnd`, followed by a refresh of the component context.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/designable.md#_snippet_5

LANGUAGE: tsx
CODE:
```
import React from 'react';
import {
  SchemaComponentProvider,
  SchemaComponent,
  createDesignable,
  useSchemaComponentContext,
} from '@nocobase/client';
import { observer, Schema, useFieldSchema } from '@formily/react';
import { Button } from 'antd';
import { uid } from '@formily/shared';

const Hello = (props) => {
  const fieldSchema = useFieldSchema();
  return (
    <h1>
      {fieldSchema.title} - {fieldSchema.name}
    </h1>
  );
};

const Page = (props) => {
  const fieldSchema = useFieldSchema();
  const { refresh } = useSchemaComponentContext();

  return (
    <div>
      <Button
        onClick={() => {
          const dn = createDesignable({
            refresh,
            current: fieldSchema.properties.hello2,
          });
          dn.on('insertAdjacent', refresh);
          dn.insertAdjacent('afterEnd', {
            title: 'afterEnd',
            'x-component': 'Hello',
          });
        }}
      >
        Add after Title2
      </Button>
      {props.children}
    </div>
  );
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Page, Hello }}>
      <SchemaComponent
        schema={{
          type: 'void',
          name: 'page',
          'x-component': 'Page',
          properties: {
            hello1: {
              type: 'void',
              title: 'Title1',
              'x-component': 'Hello',
            },
            hello2: {
              type: 'void',
              title: 'Title2',
              'x-component': 'Hello',
            },
            hello3: {
              type: 'void',
              title: 'Title3',
              'x-component': 'Hello',
            },
          },
        }}
      />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Globally Registering Components and Scopes in a NocoBase Plugin
DESCRIPTION: This TypeScript snippet demonstrates how to globally register 'MyComponent' and 'MyScope' within a NocoBase plugin's 'load' method using 'this.app.addComponents()' and 'this.app.addScopes()'. Global registration makes these entities available throughout the application for use in UI Schemas or other contexts.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/component-and-scope/index.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
class MyPlugin extends Plugin {
  async load() {
    this.app.addComponents({ MyComponent })
    this.app.addScopes({ MyScope })
  }
}
```

----------------------------------------

TITLE: Defining Custom Refresh Action Settings (TypeScript)
DESCRIPTION: This snippet defines `customRefreshActionSettings` using `SchemaSettings`. It sets up a basic settings panel for the custom action, initially including only a 'remove' operation. This allows administrators to configure or manage the action within the NocoBase UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/configure-actions.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettings } from "@nocobase/client";
import { ActionNameLowercase } from "./constants";

export const customRefreshActionSettings = new SchemaSettings({
  name: `actionSettings:${ActionNameLowercase}`,
  items: [
    {
      name: 'remove',
      type: 'remove',
    }
  ]
})
```

----------------------------------------

TITLE: Exposing Custom Hook to NocoBase SchemaComponent Scope (TypeScript)
DESCRIPTION: This snippet demonstrates how to make the `useSubmitActionProps` custom hook available within the NocoBase `SchemaComponent`'s scope. By passing the hook in the `scope` prop, it can be referenced by `x-use-component-props` in the schema, enabling the submit button to utilize the defined submission logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_14

LANGUAGE: TypeScript
CODE:
```
export const PluginSettingsTable = () => {
  return (
    <ExtendCollectionsProvider collections={[emailTemplatesCollection]}>
      <SchemaComponent schema={schema} scope={{ useSubmitActionProps }} />
    </ExtendCollectionsProvider>
  );
};
```

----------------------------------------

TITLE: Defining a New Schema Initializer Configuration (TypeScript)
DESCRIPTION: This code defines a new `SchemaInitializer` instance, specifying its unique `name`, display `title`, a `wrap` function (e.g., `Grid.wrap` for layout), an `insertPosition`, and an array of `items` that will appear in its dropdown menu. This configuration serves as a blueprint for a new UI initializer.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/client/ui-schema/initializer.md#_snippet_1

LANGUAGE: TypeScript
CODE:
```
const myInitializer = new SchemaInitializer({
  // Unique identifier for the initializer
  name: 'myInitializer',
  title: 'Add Block',
  // Wrapper, for example, inserting into a Grid requires using Grid.wrap (adds row and column tags)
  wrap: Grid.wrap,
  // Insertion position, defaults to beforeEnd, supports 'beforeBegin' | 'afterBegin' | 'beforeEnd' | 'afterEnd'
  insertPosition: 'beforeEnd',
  // Dropdown menu items
  items: [
    {
      name: 'a',
      type: 'item',
      useComponentProps() {},
    },
  ],
});
```

----------------------------------------

TITLE: Defining UI Components and Schema for NocoBase
DESCRIPTION: This TypeScript snippet defines `SamplesHello` as a React functional component and `useSamplesHelloProps` as a custom hook for dynamic schema properties. It also constructs an `ISchema` object that utilizes these components for rendering UI elements via `SchemaComponent`, demonstrating how to integrate custom components and their props within the NocoBase UI schema protocol.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/component-and-scope/global.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import { ISchema, SchemaComponent, withDynamicSchemaProps } from "@nocobase/client"
import { uid } from '@formily/shared'
import { useFieldSchema } from '@formily/react'
import React, { FC } from "react"

export const SamplesHello: FC<{ name: string }> = withDynamicSchemaProps(({ name }) => {
  return <div>hello {name}</div>
})

export const useSamplesHelloProps = () => {
  const schema = useFieldSchema();
  return { name: schema.name }
}

const schema: ISchema = {
  type: 'void',
  name: uid(),
  properties: {
    demo1: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-component-props': {
        name: 'demo1',
      },
    },
    demo2: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-use-component-props': 'useSamplesHelloProps',
    },
  }
}

export const SamplesCustomPage = () => {
  return <SchemaComponent schema={schema}></SchemaComponent>
}
```

----------------------------------------

TITLE: Testing Database with mockDatabase() in TypeScript
DESCRIPTION: Demonstrates how to use `mockDatabase()` to create an isolated database testing environment. It includes setting up a collection, syncing the database, creating a repository, and performing a data creation and assertion test. `beforeEach` and `afterEach` hooks are used for setup and teardown.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/test.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import { mockDatabase } from '@nocobase/test';

describe('my db suite', () => {
  let db;

  beforeEach(async () => {
    db = mockDatabase();
    db.collection({
      name: 'posts',
      fields: [
        {
          type: 'string',
          name: 'title',
        },
      ],
    });
    await db.sync();
  });

  afterEach(async () => {
    await db.close();
  });

  test('my case', async () => {
    const repository = db.getRepository('posts');
    const post = await repository.create({
      values: {
        title: 'hello',
      },
    });

    expect(post.get('title')).toEqual('hello');
  });
});
```

----------------------------------------

TITLE: Inserting Middleware with Tags and Position (TypeScript)
DESCRIPTION: This snippet demonstrates advanced middleware insertion using `tag`, `before`, and `after` options. It shows how to place custom middlewares (`m1` through `m5`) relative to built-in middleware tags like `restApi`, `parseToken`, and `checkRole`, allowing fine-grained control over execution order.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/development/server/middleware.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
app.use(m1, { tag: 'restApi' });
app.resourcer.use(m2, { tag: 'parseToken' });
app.resourcer.use(m3, { tag: 'checkRole' });
// m4 will come before m1
app.use(m4, { before: 'restApi' });
// m5 will be inserted between m2 and m3
app.resourcer.use(m5, { after: 'parseToken', before: 'checkRole' });
```

----------------------------------------

TITLE: Import Workflow Plugin Server API Components
DESCRIPTION: This snippet demonstrates how to import essential classes and enums from the @nocobase/plugin-workflow package, which are crucial for interacting with the server-side workflow functionalities.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/workflow/development/api.md#_snippet_0

LANGUAGE: ts
CODE:
```
import PluginWorkflowServer, {
  Trigger,
  Instruction,
  EXECUTION_STATUS,
  JOB_STATUS,
} from '@nocobase/plugin-workflow';
```

----------------------------------------

TITLE: Configure Nocobase Workflow Loop Node
DESCRIPTION: The Loop node in Nocobase workflows enables iterative execution of operations, similar to programming language loops. It generates an internal branch for nested nodes, providing access to both workflow context and local loop variables like current data object or iteration index. This node is pre-installed and requires no additional setup.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/workflow-loop/index.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
Loop Node:
  Description: Repeats operations or iterates over datasets.
  Installation: Pre-installed, no setup required.
  Creation:
    Method: Add via '+' in workflow configuration interface.
    Structure: Generates an internal branch for nested nodes.
    Variables:
      - Workflow Context Variables: Accessible globally.
      - Local Loop Variables: Scoped to the loop (e.g., current item, index).
      - Nested Loops: Supports variables specific to each loop level.
```

----------------------------------------

TITLE: Define NocoBase Schema Initializer Item for Custom Refresh (TypeScript)
DESCRIPTION: This TypeScript/TSX snippet defines `customRefreshActionInitializerItem`, an object of `SchemaInitializerItemType`. It specifies an item that, when clicked, inserts the `customRefreshActionSchema` into the UI. The item's `type` is 'item', its `name` is a unique identifier, and its `title` is displayed to the user, facilitating the addition of custom refresh functionality.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/configure-actions.md#_snippet_7

LANGUAGE: tsx
CODE:
```
import { SchemaInitializerItemType, useSchemaInitializer } from "@nocobase/client";
import { customRefreshActionSchema } from "./schema";
import { ActionName } from "./constants";
import { useT } from "../../../../locale";

export const customRefreshActionInitializerItem: SchemaInitializerItemType = {
  type: 'item',
  name: ActionName,
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT();
    return {
      title: t(ActionName),
      onClick() {
        insert(customRefreshActionSchema)
      },
    };
  },
};
```

----------------------------------------

TITLE: Adding Edit Block Title Operation in NocoBase (TypeScript)
DESCRIPTION: This snippet shows how to integrate an 'Edit Block title' operation into a NocoBase block's schema settings. It leverages the `SchemaSettingsBlockTitleItem` component provided by NocoBase for common title editing logic, adding it to the `items` array of the `carouselSettings` object. This allows users to modify the block's display title directly.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/block/block-carousel.md#_snippet_7

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettings, SchemaSettingsBlockTitleItem } from '@nocobase/client';
import { BlockNameLowercase } from '../constants';
import { heightSchemaSettingsItem } from './items/height';
import { objectFitSchemaSettingsItem } from './items/objectFit';
import { imagesSchemaSettingsItem } from './items/images';
import { autoplaySchemaSettingsItem } from './items/autoplay';

export const carouselSettings = new SchemaSettings({
  name: `blockSettings:${BlockNameLowercase}`,
  items: [
    {
      name: 'editBlockTitle',
      Component: SchemaSettingsBlockTitleItem
    },
    {
      type: 'remove',
      name: 'remove',
      componentProps: {
        removeParentsIfNoChildren: true,
        breakRemoveOn: {
          'x-component': 'Grid'
        }
      }
    }
  ]
});
```

----------------------------------------

TITLE: Extend Custom Block to NocoBase Mobile Add Block
DESCRIPTION: This TypeScript code snippet further extends the custom 'Image' block's availability to the mobile 'Add block' menu. It adds an additional `app.schemaInitializerManager.addItem` call, targeting the `mobilePage:addBlock` name, ensuring the block is accessible on mobile interfaces.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-simple.md#_snippet_13

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';

import { Image } from './component';
import { imageSettings } from './settings';
import { imageInitializerItem } from './initializer';

export class PluginInitializerBlockSimpleClient extends Plugin {
  async load() {
    this.app.addComponents({ Image });
    this.app.schemaSettingsManager.add(imageSettings);

    this.app.schemaInitializerManager.addItem('page:addBlock', `otherBlocks.${imageInitializerItem.name}`, imageInitializerItem);
    this.app.schemaInitializerManager.addItem('popup:addNew:addBlock', `otherBlocks.${imageInitializerItem.name}`, imageInitializerItem);
    this.app.schemaInitializerManager.addItem('mobilePage:addBlock', `otherBlocks.${imageInitializerItem.name}`, imageInitializerItem);
  }
}

export default PluginInitializerBlockSimpleClient;
```

----------------------------------------

TITLE: Define NocoBase UI Schema for Carousel Block (TypeScript)
DESCRIPTION: This snippet defines the `carouselSchema` for a NocoBase UI block. It specifies the structure for rendering the `Carousel` component within a `CardItem`, including how component properties are dynamically retrieved using `useCarouselBlockProps`. This schema is crucial for enabling the `Carousel` block to be added and configured dynamically in NocoBase pages.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/block/block-carousel.md#_snippet_7

LANGUAGE: tsx
CODE:
```
import { ISchema } from '@nocobase/client';
import { useFieldSchema } from '@formily/react'

import { BlockName, BlockNameLowercase } from '../constants';

export function useCarouselBlockProps() {
  const fieldSchema = useFieldSchema();
  return fieldSchema.parent?.['x-decorator-props']?.[BlockNameLowercase]
}

export const carouselSchema: ISchema = {
  type: 'void',
  'x-component': 'CardItem',
  'x-decorator-props': {
    [BlockNameLowercase]: {},
  },
  properties: {
    carousel: {
      type: 'void',
      'x-component': BlockName,
      'x-use-component-props': 'useCarouselBlockProps'
    }
  }
};
```

----------------------------------------

TITLE: Define Node Availability Context and Method
DESCRIPTION: This TypeScript snippet defines the `isAvailable` method within the `Instruction` class and the `NodeAvailableContext` type. The `isAvailable` method allows developers to control whether a node can be added to a workflow based on context like workflow instance, upstream nodes, or branch index. Returning `false` makes the node unavailable.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/workflow/development/instruction.md#_snippet_4

LANGUAGE: ts
CODE:
```
// タイプ定義
export abstract class Instruction {
  isAvailable?(ctx: NodeAvailableContext): boolean;
}

export type NodeAvailableContext = {
  // 工作流插件实例
  engine: WorkflowPlugin;
  // 工作流实例
  workflow: object;
  // 上游节点
  upstream: object;
  // 是否是分支节点（分支编号）
  branchIndex: number;
};
```

----------------------------------------

TITLE: Create Nocobase Message Configuration Form Component (TypeScript)
DESCRIPTION: This TypeScript snippet defines `MessageConfigForm.tsx`, a React component for configuring message settings within Nocobase. It uses `SchemaComponent` to render a dynamic form for recipients (`to`) and message content, accepting `variableOptions` for variable input. This component is crucial for customizing message templates in the notification system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/notification-manager/extension.md#_snippet_0

LANGUAGE: TypeScript
CODE:
```
import React from 'react';
import { SchemaComponent } from '@nocobase/client';
import useLocalTranslation from './useLocalTranslation';

const MessageConfigForm = ({ variableOptions }) => {
  const { t } = useLocalTranslation();
  return (
    <SchemaComponent
      scope={{ t }}
      schema={{
        type: 'object',
        properties: {
          to: {
            type: 'array',
            required: true,
            title: `{{t("Receivers")}}`,
            'x-decorator': 'FormItem',
            'x-component': 'ArrayItems',
            items: {
              type: 'void',
              'x-component': 'Space',
              properties: {
                sort: {
                  type: 'void',
                  'x-decorator': 'FormItem',
                  'x-component': 'ArrayItems.SortHandle',
                },
                input: {
                  type: 'string',
                  'x-decorator': 'FormItem',
                  'x-component': 'Variable.Input',
                  'x-component-props': {
                    scope: variableOptions,
                    useTypedConstant: ['string'],
                    placeholder: `{{t("Phone number")}}`,
                  },
                },
                remove: {
                  type: 'void',
                  'x-decorator': 'FormItem',
                  'x-component': 'ArrayItems.Remove',
                },
              },
            },
            properties: {
              add: {
                type: 'void',
                title: `{{t("Add phone number")}}`,
                'x-component': 'ArrayItems.Addition',
              },
            },
          },
          content: {
            type: 'string',
            required: true,
            title: `{{t("Content")}}`,
            'x-decorator': 'FormItem',
            'x-component': 'Variable.RawTextArea',
            'x-component-props': {
              scope: variableOptions,
              placeholder: 'Hi,',
              autoSize: {
                minRows: 10,
              },
            },
          },
        },
      }}
    />
  );
};

export default MessageConfigForm;
```

----------------------------------------

TITLE: Using app.i18n for CLI Internationalization (TypeScript)
DESCRIPTION: Demonstrates how to use the global app.i18n instance within a NocoBase plugin's CLI command to provide internationalized prompts and output for command-line interactions, including language switching.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/i18n.md#_snippet_1

LANGUAGE: ts
CODE:
```
import { select } from '@inquirer/select';
import { input } from '@inquirer/input';

export class PluginSampleI18nServer extends Plugin {
  load() {
    this.app.command('test-i18n').action(async () => {
      const answer1 = await select({
        message: 'Select a language',
        choices: [
          {
            name: '中文',
            value: 'zh-CN',
          },
          {
            name: 'English',
            value: 'en-US',
          }
        ]
      });
      await this.app.changeLanguage(answer1);
      const answer2 = await input({
        message: this.app.i18n.t('Enter your name')
      });
      console.log(this.app.i18n.t(`Your name is {{name}}`, { name: answer2 }));
    });
  }
}
```

----------------------------------------

TITLE: Creating NocoBase Plugin and Adding ECharts Dependencies (Bash)
DESCRIPTION: This snippet provides `yarn` and `npx lerna` commands to create a new NocoBase plugin and add `echarts` and `echarts-for-react` as development dependencies. These commands ensure the necessary charting libraries are available within the plugin's scope.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/data-visualization/step-by-step/index.md#_snippet_0

LANGUAGE: bash
CODE:
```
yarn pm create @nocobase/plugin-sample-add-custom-charts
npx lerna add echarts --scope=@nocobase/plugin-sample-add-custom-charts --dev
npx lerna add echarts-for-react --scope=@nocobase/plugin-sample-add-custom-charts --dev
```

----------------------------------------

TITLE: Upload File to Specific Storage via HTTP API (Server-side)
DESCRIPTION: This snippet shows how to upload a file to a specific storage engine configured for an attachment field. It uses the 'attachmentField' query parameter to specify the target collection and field name. If the field is not configured, the file will be uploaded to the default storage engine. Authentication requires a JWT token.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/handbook/file-manager/http-api.md#_snippet_1

LANGUAGE: Shell
CODE:
```
curl -X POST\
    -H "Authorization: Bearer <JWT>"\
    -F "file=@<path/to/file>"\
    "http://localhost:3000/api/attachments:create?attachmentField=<collection_name>.<field_name>"
```

----------------------------------------

TITLE: NocoBase API Whitelist Parameter for Data Creation/Update
DESCRIPTION: The `whitelist` parameter specifies a list of allowed fields for data creation and update operations. Any fields not included in the whitelist will be filtered out and not written to the database, ensuring data integrity and security.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/http-api/index.md#_snippet_15

LANGUAGE: bash
CODE:
```
POST  /api/posts:create?whitelist=title
```

LANGUAGE: json
CODE:
```
{
  "title": "My first post",
  "date": "2022-05-19"      // date field will be filtered and not written to the database
}
```

----------------------------------------

TITLE: Implementing Bordered Switch Schema Setting for QRCode (TypeScript)
DESCRIPTION: This TypeScript code adds a `createSwitchSettingsItem` to the `qrCodeComponentFieldSettings` to control the `QRCode` component's border visibility. It stores the boolean value in `x-component-props.bordered` and defaults to `true`. It depends on `createSwitchSettingsItem` from `@nocobase/client` and local `tStr` for localization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/value.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
export const qrCodeComponentFieldSettings = new SchemaSettings({
  name: 'fieldSettings:component:QRCode',
  items: [
    // ...
    createSwitchSettingsItem({
      name: 'bordered',
      schemaKey: 'x-component-props.bordered',
      title: tStr('Bordered'),
      defaultValue: true,
    }),
  ],
});
```

----------------------------------------

TITLE: Registering Custom Request UI Permissions in NocoBase ACL (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to register a permission snippet for the 'Custom Request' UI within the NocoBase Access Control List (ACL) system. It uses `this.app.acl.registerSnippet` to define 'ui.customRequests' with broad 'customRequests:*' actions, which is essential for controlling user access to the custom request configuration interface.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/action-custom-request/index.md#_snippet_0

LANGUAGE: typescript
CODE:
```
this.app.acl.registerSnippet({
  name: 'ui.customRequests', // Permission for configuring interface related to ui.*
  actions: ['customRequests:*'],
});
```

----------------------------------------

TITLE: Updating Order Status on Delivery Creation (TypeScript)
DESCRIPTION: This snippet demonstrates how to update an order's status to 'shipped' (status: 2) immediately after a shipping record is created. It listens for the `deliveries.afterCreate` event and uses `this.db.getRepository('orders').update` to modify the associated order, leveraging the transaction context from the delivery event.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/events.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
class ShopPlugin extends Plugin {
  load() {
    this.db.on('deliveries.afterCreate', async (delivery, options) => {
      const orderRepo = this.db.getRepository('orders');
      await orderRepo.update({
        filterByTk: delivery.orderId,
        value: {
          status: 2
        },
        transaction: options.transaction
      });
    });
  }
}
```

----------------------------------------

TITLE: Define Custom Encryption Field Class for NocoBase Server
DESCRIPTION: This snippet defines the 'EncryptionField' class, extending NocoBase's 'Field' class to handle encrypted data. It sets the 'dataType' to 'DataTypes.STRING' for database storage. The 'get' method decrypts the value when retrieved, and the 'set' method encrypts the value before saving. This ensures data is automatically encrypted/decrypted during database interactions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/field/interface.md#_snippet_8

LANGUAGE: TypeScript
CODE:
```
import { BaseColumnFieldOptions, Field, FieldContext } from '@nocobase/database';
import { DataTypes } from 'sequelize';
import { decryptSync, encryptSync } from './utils';

export interface EncryptionFieldOptions extends BaseColumnFieldOptions {
  type: 'encryption';
}

export class EncryptionField extends Field {
  get dataType() {
    return DataTypes.STRING;
  }

  constructor(options?: any, context?: FieldContext) {
    const { name, iv } = options;
    super(
      {
        get() {
          const value = this.getDataValue(name);
          if (!value) return null;
          return decryptSync(value, iv);
        },
        set(value) {
          if (!value?.length) value = null;
          else {
            value = encryptSync(value, iv);
          }
          this.setDataValue(name, value);
        },
        ...options,
      },
      context,
    );
  }
}
```

----------------------------------------

TITLE: Define SchemaComponent and Related Components/Hooks (TypeScript/TSX)
DESCRIPTION: This code updates CustomPage.tsx to integrate SchemaComponent for rendering UI schemas. It defines SamplesHello as a component and useSamplesHelloProps as a hook, both designed to be used within the schema for dynamic property resolution.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/component-and-scope/global.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import { ISchema, SchemaComponent, withDynamicSchemaProps } from "@nocobase/client"
import { uid } from '@formily/shared'
import { useFieldSchema } from '@formily/react'
import React, { FC } from "react"

export const SamplesHello: FC<{ name: string }> = withDynamicSchemaProps(({ name }) => {
  return <div>hello {name}</div>
})

export const useSamplesHelloProps = () => {
  const schema = useFieldSchema();
  return { name: schema.name }
}

const schema: ISchema = {
  type: 'void',
  name: uid(),
  properties: {
    demo1: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-component-props': {
        name: 'demo1'
      }
    },
    demo2: {
      type: 'void',
      'x-component': 'SamplesHello',
      'x-use-component-props': 'useSamplesHelloProps'
    }
  }
}

export const SamplesCustomPage = () => {
  return <SchemaComponent schema={schema}></SchemaComponent>
}
```

----------------------------------------

TITLE: NocoBase Client API: `useDesignable` and `useSchemaInitializer`
DESCRIPTION: This section provides API documentation for `useDesignable` and `useSchemaInitializer` hooks in NocoBase client. It explains their purpose, key methods like `insert` and `remove`, and the rationale for using `useSchemaInitializer().insert` for hierarchical schema manipulation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
- `useDesignable()`: Method for adding, deleting, updating, and retrieving schemas.
- `useSchemaInitializer()`: Used to provide the schema initializer context.
  - `insert`: Used to insert schemas. The reason for using the insert method provided by `useSchemaInitializer()` is that schemas are hierarchical, and what is obtained by `useSchemaInitializer()` is the hierarchy of `SchemaInitializer`, while what is obtained by `useDesignable()` is the hierarchy of the current schema. Therefore, it is necessary to insert into the sibling hierarchy of `SchemaInitializer`, so the insert method of `useSchemaInitializer()` is used.
```

----------------------------------------

TITLE: Register NocoBase SchemaInitializer in Plugin Client
DESCRIPTION: This TSX snippet demonstrates how to register the previously defined 'formV3ConfigureActionsInitializer' with the NocoBase application's 'schemaInitializerManager'. This makes the initializer available for use within the application's UI.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_18

LANGUAGE: TSX
CODE:
```
// ...
import { formV3ConfigureActionsInitializer } from './FormV3.configActions';

export class PluginBlockFormClient extends Plugin {
  async load() {
    this.app.schemaInitializerManager.add(formV3ConfigureActionsInitializer);

    // ...
  }
}
```

----------------------------------------

TITLE: Implementing NocoBase Plugin Settings Page (TypeScript)
DESCRIPTION: This TypeScript snippet defines a NocoBase client-side plugin that registers a new settings page. It uses `pluginSettingsManager.add` to associate a component (`MySettingPage`) with the plugin's name, title, and icon, making it accessible via the admin panel.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/router/add-setting-page-single-route/index.md#_snippet_3

LANGUAGE: typescript
CODE:
```
import React from 'react';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const MySettingPage = () => <div>Hello Setting page</div>;

export class PluginAddSettingPageSingleRouteClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Single Route',
      icon: 'ApiOutlined',
      Component: MySettingPage,
    });
  }
}

export default PluginAddSettingPageSingleRouteClient;
```

----------------------------------------

TITLE: Registering Schema Settings in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the previously defined `timelineSettings` with the NocoBase application's `schemaSettingsManager`. This is done within the `load` method of the client-side plugin class, making the settings available for use in block schemas.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/block-data-modal.md#_snippet_9

LANGUAGE: ts
CODE:
```
import { Plugin } from '@nocobase/client';
import { timelineSettings } from './settings';

export class PluginInitializerBlockDataModalClient extends Plugin {
  async load() {
    // ...
    this.app.schemaSettingsManager.add(timelineSettings)
  }
}

export default PluginInitializerBlockDataModalClient;
```

----------------------------------------

TITLE: Registering UI Components and Schema Settings (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the newly defined `InfoBlock` and `InfoItem` UI components, along with their associated schema settings (`infoBlockSettings`, `infoItemSettings`), with the NocoBase application. This registration makes the components and their configuration options available for use within the application's UI schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
export class PluginInitializerComplexDataBlockClient extends Plugin {
  async load() {
    this.app.addComponents({ InfoBlock, InfoItem });
    this.app.schemaSettingsManager.add(infoBlockSettings, infoItemSettings);
  }
}
```

----------------------------------------

TITLE: Register Custom Block and Add to NocoBase Page-Level Add Block
DESCRIPTION: This TypeScript code snippet demonstrates how to register a custom 'Image' component, add its schema settings, and integrate it into the NocoBase page-level 'Add block' menu. It uses `app.addComponents`, `app.schemaSettingsManager.add`, and `app.schemaInitializerManager.addItem` to make the custom block available.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-simple.md#_snippet_11

LANGUAGE: TypeScript
CODE:
```
import { Plugin } from '@nocobase/client';

import { Image } from './component';
import { imageSettings } from './settings';
import { imageInitializerItem } from './initializer';

export class PluginInitializerBlockSimpleClient extends Plugin {
  async load() {
    this.app.addComponents({ Image });
    this.app.schemaSettingsManager.add(imageSettings);
    this.app.schemaInitializerManager.addItem('page:addBlock', `otherBlocks.${imageInitializerItem.name}`, imageInitializerItem);
  }
}

export default PluginInitializerBlockSimpleClient;
```

LANGUAGE: APIDOC
CODE:
```
### app.schemaSettingsManager.add
**Description**: Registers a set of schema settings with the application's schema settings manager. This allows custom components to define their configurable properties within the NocoBase UI.
**Parameters**:
- `settings` (object): An object defining the schema settings to be added.
**Return Type**: `void`
**Reference**: [https://client.docs.nocobase.com/core/ui-schema/schema-settings-manager#schemasettingsmanageradd](https://client.docs.nocobase.com/core/ui-schema/schema-settings-manager#schemasettingsmanageradd)

### app.schemaInitializerManager.addItem
**Description**: Adds a new item to a specified schema initializer menu. This method is crucial for extending NocoBase's UI with custom blocks or components by making them available through 'Add block' or similar initializer points.
**Parameters**:
- `initializerName` (string): The unique identifier for the target initializer menu (e.g., 'page:addBlock', 'popup:addNew:addBlock', 'mobilePage:addBlock').
- `itemName` (string): A unique name for the item being added, often including a parent category (e.g., `otherBlocks.yourCustomItemName`).
- `item` (object): The configuration object for the initializer item, defining its properties like `name`, `title`, `component`, etc.
**Return Type**: `void`
**Reference**: [https://client.docs.nocobase.com/core/ui-schema/schema-initializer-manager#schemainitializermanageradditem](https://client.docs.nocobase.com/core/ui-schema/schema-initializer-manager#schemainitializermanageradditem)
```

----------------------------------------

TITLE: Register NocoBase Components and Schema Settings
DESCRIPTION: This snippet demonstrates how to register custom components (`InfoBlock`, `InfoItem`) and schema settings (`infoBlockSettings`, `infoItemSettings`) with the NocoBase application. This step is crucial for making the defined UI elements and their configurations available within the system.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/schema-initializer/configure-fields-bk.md#_snippet_9

LANGUAGE: ts
CODE:
```
export class PluginInitializerComplexDataBlockClient extends Plugin {
  async load() {
    this.app.addComponents({ InfoBlock, InfoItem });
    this.app.schemaSettingsManager.add(infoBlockSettings, infoItemSettings);
  }
}
```

----------------------------------------

TITLE: Register Schema Settings in NocoBase Client Plugin
DESCRIPTION: This snippet explains how to register the defined `SchemaSettings` instance with the NocoBase client application. By calling `this.app.schemaSettingsManager.add()`, the schema settings become available for use and linkage with specific UI schemas, enabling dynamic configuration of blocks.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_12

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { formV3Settings } from './FormV3.settings';

export class PluginBlockFormClient extends Plugin {
  async load() {
    // ... other initializations
    this.app.schemaSettingsManager.add(formV3Settings);
  }
}

export default PluginBlockFormClient;
```

----------------------------------------

TITLE: Defining a Product Collection in a Plugin File
DESCRIPTION: This snippet shows how to define a `products` collection within a dedicated TypeScript file (`collections/products.ts`) for a NocoBase plugin. It exports a default object specifying the collection's `name` and its `fields`, including `title` (string), `price` (integer), `enabled` (boolean), and `inventory` (integer). This modular definition allows for easier management and import within the plugin's main class.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/development/server/collections-fields.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'products',
  fields: [
    {
      type: 'string',
      name: 'title',
    },
    {
      type: 'integer',
      name: 'price',
    },
    {
      type: 'boolean',
      name: 'enabled',
    },
    {
      type: 'integer',
      name: 'inventory',
    },
  ],
};
```

----------------------------------------

TITLE: Registering NocoBase Server-Side Plugins
DESCRIPTION: This TypeScript snippet demonstrates how to register a server-side NocoBase plugin with the application instance. It shows the instantiation of an `Application` and the use of `app.plugin()` to integrate a custom `Plugin` class, defining its lifecycle methods. This setup ensures the server controls the plugin's lifecycle and functionality.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/welcome/release/v0080-changelog.md#_snippet_5

LANGUAGE: typescript
CODE:
```
import { Application } from '@nocobase/server';

const app = new Application({
  // ...
});

class MyPlugin extends Plugin {
  afterAdd() {}
  beforeLoad() {}
  load() {}
  install() {}
  afterEnable() {}
  afterDisable() {}
  remove() {}
}

app.plugin(MyPlugin, { name: 'my-plugin' });
```

----------------------------------------

TITLE: Defining NocoBase Upgrade Migration Class (TypeScript)
DESCRIPTION: This snippet shows the structure of a NocoBase migration class, which is used to manage application upgrades. It defines properties like `on` to specify when the migration should run (e.g., 'beforeLoad'), and `appVersion` or `pluginVersion` to set conditions based on version numbers. The `up()` method contains the actual upgrade script logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0190-changelog.md#_snippet_2

LANGUAGE: typescript
CODE:
```
export default class extends Migration {
  // When to perform the migration
  on = 'beforeLoad';
  // Execute only when the following app version number is met.
  appVersion = '<=0.13.0-alpha.5';
  // Execute only when the following plugin version number is met.
  pluginVersion = '<=0.13.0-alpha.5';
  // Upgrade script.
  async up() {}
}
```

----------------------------------------

TITLE: Defining Deliveries Collection Schema in NocoBase (TypeScript)
DESCRIPTION: This snippet defines the schema for a new 'deliveries' collection. It includes fields for associating with an 'order', 'provider', 'trackingNumber', and 'status'. This collection is used to store shipping information related to orders, enabling more granular control over delivery details.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/resources-actions.md#_snippet_10

LANGUAGE: TypeScript
CODE:
```
export default {
  name: 'deliveries',
  fields: [
    {
      type: 'belongsTo',
      name: 'order',
    },
    {
      type: 'string',
      name: 'provider',
    },
    {
      type: 'string',
      name: 'trackingNumber',
    },
    {
      type: 'integer',
      name: 'status',
    },
  ],
};
```

----------------------------------------

TITLE: Registering NocoBase Block Component with Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the `Info` component with the NocoBase application within a plugin's `load` method. It extends `Plugin` from `@nocobase/client` and uses `this.app.addComponents({ Info })` to make the component available globally.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/schema-initializer/block-data.md#_snippet_6

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { Info } from './component';

export class PluginInitializerBlockDataClient extends Plugin {
  async load() {
    this.app.addComponents({ Info })
  }
}

export default PluginInitializerBlockDataClient;
```

----------------------------------------

TITLE: Registering Carousel Component and Scope in NocoBase Plugin (TypeScript)
DESCRIPTION: This snippet demonstrates how to register both the `Carousel` component and the `useCarouselBlockProps` scope within a NocoBase plugin's `load` method. Registering `useCarouselBlockProps` as a scope is crucial for the `x-use-component-props` mechanism in the UI Schema to correctly locate and apply dynamic properties to the `Carousel` component. This ensures the component can be properly configured and rendered within the NocoBase application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/block/block-carousel.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import { Plugin } from '@nocobase/client';
import { Carousel } from './component';
import { useCarouselBlockProps } from './schema';

export class PluginBlockCarouselClient extends Plugin {
  async load() {
    this.app.addComponents({ Carousel })
    this.app.addScopes({ useCarouselBlockProps });
  }
}

export default PluginBlockCarouselClient;
```

----------------------------------------

TITLE: Using $notEmpty Operator for Non-Empty Field Check - TypeScript
DESCRIPTION: Demonstrates the `$notEmpty` operator, which checks if a general field is not empty. For string fields, it checks for a non-empty string; for array fields, it checks for a non-empty array.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/operators.md#_snippet_9

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    title: {
      $notEmpty: true,
    },
  },
});
```

----------------------------------------

TITLE: TypeScript: `$lt` Operator for Less Than
DESCRIPTION: Checks if a field's value is less than the specified value, equivalent to SQL's `<`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/database/operators.md#_snippet_16

LANGUAGE: TypeScript
CODE:
```
repository.find({
  filter: {
    price: {
      $lt: 100,
    },
  },
});
```

----------------------------------------

TITLE: Defining Data Block Schema Initializer Item in TSX
DESCRIPTION: This snippet defines `infoInitializerItem`, a `SchemaInitializerItemType` for a custom data block. It uses `DataBlockInitializer` as its component, configuring its title, icon, and an `onCreateBlockSchema` callback to insert the block's schema using `getInfoSchema` when a data table is selected. It leverages `useSchemaInitializer` for schema insertion and `useT` for internationalization.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/schema-initializer/block-data.md#_snippet_8

LANGUAGE: TSX
CODE:
```
import React from 'react';
import { SchemaInitializerItemType, useSchemaInitializer } from '@nocobase/client'
import { CodeOutlined } from '@ant-design/icons';

import { getInfoSchema } from '../schema'
import { useT } from '../locale';
import { BlockName, BlockNameLowercase } from '../constants';

export const infoInitializerItem: SchemaInitializerItemType = {
  name: BlockNameLowercase,
  Component: 'DataBlockInitializer',
  useComponentProps() {
    const { insert } = useSchemaInitializer();
    const t = useT();
    return {
      title: t(BlockName),
      icon: <CodeOutlined />,
      componentType: BlockName,
      useTranslationHooks: useT,
      onCreateBlockSchema({ item }) {
        insert(getInfoSchema({ dataSource: item.dataSource, collection: item.name }))
      },
    };
  },
}
```

----------------------------------------

TITLE: Conceptual React Component Structure from FormV3 Schema (TSX)
DESCRIPTION: This snippet illustrates the equivalent React component structure that the `getFormV3Schema` function (defined in the previous snippet) would render. It shows how the `CardItem`, `DataBlockProvider`, and `FormV3` components are nested, with `DataBlockProvider` supplying `dataSource`, `collection`, and `formV3` props, and `FormV3` consuming its properties via `useFormV3Props`. This helps in understanding the runtime rendering of the defined UI Schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/block/block-form.md#_snippet_2

LANGUAGE: tsx
CODE:
```
<CardItem>
  <DataBlockProvider dataSource={dataSource} collection={collection} formV3={{}}>
    <FormV3 {...useFormV3Props()}>
      {children}
    </FormV3>
  </DataBlockProvider>
</CardItem>
```

----------------------------------------

TITLE: Register ACL Snippet
DESCRIPTION: Registers a snippet, which defines a collection of actions. Snippets allow for unified management of a set of operation permissions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/api/acl/acl.md#_snippet_2

LANGUAGE: TypeScript
CODE:
```
export type SnippetOptions = {
  name: string;
  actions: string[];
};
```

LANGUAGE: APIDOC
CODE:
```
### `registerSnippet()`

Registers a snippet.

#### Signature

- `registerSnippet(snippet: SnippetOptions)`
```

----------------------------------------

TITLE: Intercepting Routes with NocoBase Provider TSX
DESCRIPTION: This example demonstrates how a NocoBase `Provider` component can act as an interceptor, conditionally rendering content based on the current route. The `MyProvider` component uses `useLocation` to check the pathname and can display alternative content or redirect, effectively controlling access or modifying the UI flow before rendering its children.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/providers.md#_snippet_3

LANGUAGE: tsx
CODE:
```
import { Plugin, Application } from '@nocobase/client';
import { useLocation } from 'react-router';
import { Link } from 'react-router-dom';

// Create a component and ensure children are rendered
const MyProvider = (props) => {
  const { children, name } = props;
  const location = useLocation();
  if (location.pathname === '/about') {
    return (
      <div>
        Content intercepted. Return to <Link to={'/'}>Home</Link>
      </div>
    );
  }
  return (
    <div>
      <div>Hello, {name}</div>
      <Link to={'/'}>Home</Link>, <Link to={'/about'}>About</Link>
      {children}
    </div>
  );
};

class PluginSampleProvider extends Plugin {
  async load() {
    this.app.addProvider(MyProvider);
    this.app.router.add('home', {
      path: '/',
      Component: () => <div>Home page</div>,
    });
  }
}

const app = new Application({
  router: {
    type: 'memory',
    initialEntries: ['/'],
  },
  plugins: [PluginSampleProvider],
});

export default app.getRootComponent();
```

----------------------------------------

TITLE: Carouselコンポーネントのエクスポート (TypeScript/TSX)
DESCRIPTION: このシンプルなTypeScript/TSXスニペットは、`Carousel`コンポーネントをそのモジュールから再エクスポートします。このパターンは、JavaScript/TypeScriptプロジェクトでディレクトリのコンポーネントに対して単一のエントリポイントを作成し、アプリケーションの他の場所でのインポートを簡素化するためによく使用されます。
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-carousel.md#_snippet_3

LANGUAGE: tsx
CODE:
```
export * from './Carousel';
```

----------------------------------------

TITLE: Connect Editable and Read-Only QRCode Components in TSX
DESCRIPTION: This TSX snippet demonstrates how to use '@formily/react's 'connect' and 'mapReadPretty' functions. It combines the 'QRCodeEditable' and 'QRCodeReadPretty' components into a single 'QRCode' export, enabling automatic pattern switching based on the UI schema.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/field/value.md#_snippet_4

LANGUAGE: tsx
CODE:
```
import { connect, mapReadPretty } from '@formily/react';

export const QRCode: FC<QRCodeProps>  = connect(QRCodeEditable, mapReadPretty(QRCodeReadPretty));

QRCode.displayName = 'QRCode';
```

----------------------------------------

TITLE: Registering Delete Action Props in NocoBase Schema (TypeScript)
DESCRIPTION: This diff snippet demonstrates how to register the `useDeleteActionProps` hook within the `SchemaComponent`'s `scope` property. This makes the custom hook available for use in the schema, allowing the 'Delete' action to function correctly in the NocoBase client application.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_19

LANGUAGE: diff
CODE:
```
export const PluginSettingsTable = () => {
  return (
    <ExtendCollectionsProvider collections={[emailTemplatesCollection]}>
-     <SchemaComponent schema={schema} scope={{ useSubmitActionProps, useEditFormProps }} />
+     <SchemaComponent schema={schema} scope={{ useSubmitActionProps, useEditFormProps, useDeleteActionProps }} />
    </ExtendCollectionsProvider>
  );
};
```

----------------------------------------

TITLE: Adding Public About Page in NocoBase Plugin (TypeScript)
DESCRIPTION: This TypeScript snippet demonstrates how to add a new public page (`/about`) to a NocoBase application using the client-side plugin. It defines a React component for the page content and registers it with the application's router, also showing how to set the document title using `useDocumentTitle`. This page is accessible without login.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/router/add-page/index.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import React, { useEffect } from 'react';
import { Plugin, useDocumentTitle } from '@nocobase/client';

const AboutPage = () => {
  const { setTitle } = useDocumentTitle();

  useEffect(() => {
    setTitle('About');
  }, [])

  return <div>About Page</div>;
}

export class PluginAddPageClient extends Plugin {
  async load() {
    this.app.router.add('about', {
      path: '/about',
      Component: AboutPage,
    })
  }
}

export default PluginAddPageClient;
```

----------------------------------------

TITLE: Defining Custom Refresh Action Schema and Props (TypeScript)
DESCRIPTION: This snippet defines `useCustomRefreshActionProps`, a React Hook that provides dynamic properties for an `Action` component, including its type, title, and an asynchronous `onClick` handler to refresh data using `useDataBlockRequest`. It also defines `customRefreshActionSchema`, an `ISchema` object that specifies the UI component (`Action`), its type (`void`), and references the `useCustomRefreshActionProps` hook for its dynamic behavior.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/configure-actions.md#_snippet_6

LANGUAGE: TypeScript
CODE:
```
import { ActionProps, useDataBlockRequest, ISchema } from "@nocobase/client";
import { useT } from "../../../../locale";

export const useCustomRefreshActionProps = (): ActionProps => {
  const { runAsync } = useDataBlockRequest();
  const t = useT();
  return {
    type: 'primary',
    title: t('Custom Refresh'),
    async onClick() {
      await runAsync();
    },
  }
}

export const customRefreshActionSchema: ISchema = {
  type: 'void',
  'x-component': 'Action',
  'x-toolbar': 'ActionSchemaToolbar',
  'x-use-component-props': 'useCustomRefreshActionProps'
}
```

----------------------------------------

TITLE: Defining HasMany Association in NocoBase Collection (TypeScript)
DESCRIPTION: This example demonstrates how to create a one-to-many relationship using the 'hasMany' field type in a NocoBase collection. A 'user' can have multiple 'posts', with the 'foreignKey' ('authorId') and 'sourceKey' ('id') explicitly defined to manage the relationship where the foreign key is stored in the associated table ('posts').
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/field.md#_snippet_15

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'users',
  fields: [
    {
      type: 'hasMany',
      name: 'posts',
      foreignKey: 'authorId',
      sourceKey: 'id',
    },
  ],
});
```

----------------------------------------

TITLE: Making a Generic HTTP Request with APIClient
DESCRIPTION: Illustrates how to use the `apiClient.request()` method with standard `AxiosRequestConfig` parameters. This example shows a basic request where only the `url` is specified, similar to a direct `axios` call.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/sdk/index.md#_snippet_3

LANGUAGE: ts
CODE:
```
const res = await apiClient.request({ url: '' });
```

----------------------------------------

TITLE: Example of useRequest Hook Usage (JavaScript)
DESCRIPTION: Demonstrates how to use the `useRequest` hook to fetch data from an endpoint (`/users`) and how to use its `run` function to re-execute the request with updated parameters, such as `pageSize`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/client/api-client.md#_snippet_8

LANGUAGE: JavaScript
CODE:
```
const { data, loading, refresh, run, params } = useRequest({ url: '/users' });

// Since useRequest accepts AxiosRequestConfig, the run function also accepts AxiosRequestConfig.
run({
  params: {
    pageSize: 20,
  },
});
```

----------------------------------------

TITLE: Using Custom Snowflake ID in Orders Collection (TypeScript)
DESCRIPTION: This snippet demonstrates how to apply the custom `snowflake` field type as the primary key for the `orders` collection. Instead of `uuid`, the `id` field is now defined with `type: 'snowflake'`, leveraging the custom ID generation logic.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections-fields.md#_snippet_10

LANGUAGE: ts
CODE:
```
export default {
  name: 'orders',
  fields: [
    {
      type: 'snowflake',
      name: 'id',
      primaryKey: true
    },
    // ... . other fields
  ]
}
```

----------------------------------------

TITLE: Defining Formula Field in NocoBase Collection (TypeScript)
DESCRIPTION: This snippet shows how to define a 'formula' type field named 'total' for an 'orders' collection, a NocoBase extension. It allows mathematical calculations based on other fields in the same record using `mathjs` expressions, such as `price * quantity`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/field.md#_snippet_10

LANGUAGE: TypeScript
CODE:
```
db.collection({
  name: 'orders',
  fields: [
    {
      type: 'double',
      name: 'price',
    },
    {
      type: 'integer',
      name: 'quantity',
    },
    {
      type: 'formula',
      name: 'total',
      expression: 'price * quantity',
    },
  ],
});
```

----------------------------------------

TITLE: Conditional Resourcer Middleware Execution (TypeScript)
DESCRIPTION: Illustrates that `resourcer.use()` middlewares are only executed when a defined resource is requested. If the requested resource is undefined, these middlewares are skipped, while `app.use()` middlewares still execute, demonstrating the conditional nature of resource-level middleware.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/middleware.md#_snippet_4

LANGUAGE: TypeScript
CODE:
```
app.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(1);
  await next();
  ctx.body.push(2);
});

app.resourcer.use(async (ctx, next) => {
  ctx.body = ctx.body || [];
  ctx.body.push(3);
  await next();
  ctx.body.push(4);
});
```

----------------------------------------

TITLE: Registering NocoBase SchemaSettingsItem (TypeScript)
DESCRIPTION: This snippet demonstrates how to register the custom `tableShowIndexSettingsItem` within a NocoBase client plugin. The `addItem` method of `schemaSettingsManager` associates the new setting with the 'blockSettings:table' context, making it available for Table block configurations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-settings/add-item.md#_snippet_5

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client';
import { tableShowIndexSettingsItem } from './tableShowIndexSettingsItem'

export class PluginSchemaSettingsAddItemClient extends Plugin {
  async load() {
    this.schemaSettingsManager.addItem('blockSettings:table', tableShowIndexSettingsItem.name, tableShowIndexSettingsItem)
  }
}

export default PluginSchemaSettingsAddItemClient;
```

----------------------------------------

TITLE: Define Schema Settings for a NocoBase Custom Block
DESCRIPTION: This snippet details the process of creating a new `SchemaSettings` instance for a custom block. Schema settings are essential for configuring a block's attributes and operations within the NocoBase UI, providing a structured way to manage block-specific configurations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/ja-JP/plugin-samples/block/block-form.md#_snippet_11

LANGUAGE: typescript
CODE:
```
import { SchemaSettings } from "@nocobase/client";
import { FormV3BlockNameLowercase } from "../constants";

export const formV3Settings = new SchemaSettings({
  name: `blockSettings:${FormV3BlockNameLowercase}`,
  items: [
    // TODO: Add schema setting items here
  ]
});
```

----------------------------------------

TITLE: Deleting Schema Nodes with remove Method (TypeScript)
DESCRIPTION: Demonstrates how to use the `remove` method of a `Designable` instance to delete the current node or a specified child node. It illustrates both a simple removal of the current node and a more complex removal with filtering, skipping, breaking, recursive options, and the ability to remove parent nodes if they become empty.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/designable.md#_snippet_7

LANGUAGE: ts
CODE:
```
const current = new Schema({
  name: 'root',
  type: '
```

----------------------------------------

TITLE: Registering Page-Specific Route for Plugin Configuration Data in NocoBase (TypeScript)
DESCRIPTION: This snippet extends the NocoBase client-side plugin to register a new route for a page-specific component (`PluginSettingsFormPage`). It adds a new path (`/admin/plugin-settings-form-page`) to the application router, associating it with the `PluginSettingsFormPage` component. This allows direct navigation to a page displaying the fetched configuration data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/form.md#_snippet_11

LANGUAGE: TypeScript
CODE:
```
import { PluginSettingsFormPage } from './PluginSettingsFormPage'
// ...

export class PluginSettingFormClient extends Plugin {
  async load() {
    // ...

    this.app.router.add(`admin.${name}-page`, {
      path: '/admin/plugin-settings-form-page',
      Component: PluginSettingsFormPage,
    })
  }
}
```

----------------------------------------

TITLE: Create Editable QRCode Component in TSX
DESCRIPTION: This TSX snippet defines the 'QRCodeEditable' functional component for the editable mode. It demonstrates how to handle 'value', 'disabled', and 'onChange' props, integrating 'AntdQRCode' with 'Input.URL' for user input and display.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/field/value.md#_snippet_2

LANGUAGE: tsx
CODE:
```
import React, { FC } from 'react';
import { Input } from '@nocobase/client';
import { QRCode as AntdQRCode, Space, QRCodeProps as AntdQRCodeProps } from 'antd';

interface QRCodeProps extends AntdQRCodeProps {
  onChange: (value: string) => void;
  disabled?: boolean;
}

const QRCodeEditable: FC<QRCodeProps> = ({ value, disabled, onChange, ...otherProps }) => {
  return <Space direction="vertical" align="center">
    <AntdQRCode value={value || '-'} {...otherProps} />
    <Input.URL
      maxLength={60}
      value={value}
      disabled={disabled}
      onChange={(e) => onChange(e.target.value)}
    />
  </Space>;
}
```

----------------------------------------

TITLE: Nesting Object Schema with props.children in NocoBase (TypeScript)
DESCRIPTION: This snippet demonstrates how to nest an `object` type schema within a custom React component (`Hello`) using `props.children` in NocoBase. The `Hello` component is registered with `SchemaComponentProvider` and renders its `properties` as children, allowing the `World` component to be displayed inside it. This pattern is suitable for rendering nested schema structures where the parent component needs to wrap or contain its children.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/development/client/ui-schema/extending.md#_snippet_0

LANGUAGE: tsx
CODE:
```
/**
 * defaultShowCode: true
 */
import React from 'react';
import { SchemaComponent, SchemaComponentProvider } from '@nocobase/client';

// Hello 组件适配了 children，可以嵌套 properties 了
const Hello = (props) => <h1>Hello, {props.children}!</h1>;
const World = () => <span>world</span>;

const schema = {
  type: 'object',
  name: 'hello',
  'x-component': 'Hello',
  properties: {
    world: {
      type: 'string',
      'x-component': 'World',
    },
  },
};

export default () => {
  return (
    <SchemaComponentProvider components={{ Hello, World }}>
      <SchemaComponent schema={schema} />
    </SchemaComponentProvider>
  );
};
```

----------------------------------------

TITLE: Handling Before/After Update Events in NocoBase (TypeScript)
DESCRIPTION: This snippet shows how to set up listeners for 'beforeUpdate' and 'afterUpdate' events. These events are activated when data is modified via `repository.update()`. The listeners receive the model and update options, allowing for custom logic to be executed before or after the update operation.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/api/database/index.md#_snippet_29

LANGUAGE: TypeScript
CODE:
```
on(eventName: `${string}.beforeUpdate` | 'beforeUpdate' | `${string}.afterUpdate` | 'afterUpdate', listener: UpdateListener): this
```

LANGUAGE: TypeScript
CODE:
```
import type { UpdateOptions, HookReturn } from 'sequelize/types';
import type { Model } from '@nocobase/database';

export type UpdateListener = (
  model: Model,
  options?: UpdateOptions,
) => HookReturn;
```

LANGUAGE: TypeScript
CODE:
```
db.on('beforeUpdate', async (model, options) => {
  // do something
});

db.on('books.afterUpdate', async (model, options) => {
  // do something
});
```

----------------------------------------

TITLE: Defining Edit Form Props and Table Schema for NocoBase TSX
DESCRIPTION: This snippet defines a custom hook `useEditFormProps` to retrieve current row data and initialize a form with it, and extends the NocoBase schema to include an 'Edit' action button within a table column. The action opens a drawer containing a form pre-populated with the record's data, allowing for in-place editing.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/plugin-samples/plugin-settings/table.md#_snippet_15

LANGUAGE: tsx
CODE:
```
import { useCollectionRecordData } from '@nocobase/client';
import { useMemo } from 'react';

const useEditFormProps = () => {
  const recordData = useCollectionRecordData();
  const form = useMemo(
    () =>
      createForm({
        values: recordData,
      }),
    [],
  );

  return {
    form,
  };
}

const schema: ISchema = {
  // ...
  properties: {
    // ...
    table: {
      // ...
      properties: {
        // ...
        actions: {
          type: 'void',
          title: 'Actions',
          'x-component': 'TableV2.Column',
          properties: {
            actions: {
              type: 'void',
              'x-component': 'Space',
              'x-component-props': {
                split: '|',
              },
              properties: {
                edit: {
                  type: 'void',
                  title: 'Edit',
                  'x-component': 'Action.Link',
                  'x-component-props': {
                    openMode: 'drawer',
                    icon: 'EditOutlined',
                  },
                  properties: {
                    drawer: {
                      type: 'void',
                      title: 'Edit',
                      'x-component': 'Action.Drawer',
                      properties: {
                        form: {
                          type: 'void',
                          'x-component': 'FormV2',
                          'x-use-component-props': 'useEditFormProps',
                          properties: {
                            subject: {
                              'x-decorator': 'FormItem',
                              'x-component': 'CollectionField',
                            },
                            content: {
                              'x-decorator': 'FormItem',
                              'x-component': 'CollectionField',
                            },
                            footer: {
                              type: 'void',
                              'x-component': 'Action.Drawer.Footer',
                              properties: {
                                submit: {
                                  title: 'Submit',
                                  'x-component': 'Action',
                                  'x-use-component-props': 'useSubmitActionProps',
                                },
                              },
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
            }
          }
        }
      }
    }
  }
}
```

----------------------------------------

TITLE: Registering Plugin Settings Page (TypeScript/React)
DESCRIPTION: This TypeScript snippet demonstrates how to register a new plugin settings page in a NocoBase client-side plugin. It uses this.app.pluginSettingsManager.add to associate a React component (PluginSettingPage) with the plugin's name, title, and icon, making it accessible via the NocoBase admin panel.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/router/add-setting-page-layout-routes/index.md#_snippet_1

LANGUAGE: tsx
CODE:
```
import React from 'react';
import { Plugin } from '@nocobase/client';

// @ts-ignore
import { name } from '../../package.json';

const PluginSettingPage = () => <div>
  details
</div>

export class PluginAddSettingPageLayoutRoutesClient extends Plugin {
  async load() {
    this.app.pluginSettingsManager.add(name, {
      title: 'Different Layout',
      icon: 'ApiOutlined',
      Component: PluginSettingPage,
    });
  }
}

export default PluginAddSettingPageLayoutRoutesClient;
```

----------------------------------------

TITLE: Defining Schema Settings for NocoBase Block (TypeScript)
DESCRIPTION: This snippet defines a new `SchemaSettings` instance named `orderDetailsSettings`. This object will serve as a container for various configuration items specific to a NocoBase block, identified by `blockSettings:${FieldNameLowercase}`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/field/without-value.md#_snippet_5

LANGUAGE: TypeScript
CODE:
```
import { SchemaSettings } from "@nocobase/client";
import { FieldNameLowercase } from '../constants';
import { orderFieldSchemaSettingsItem } from "./items/orderField";

export const orderDetailsSettings = new SchemaSettings({
  name: `blockSettings:${FieldNameLowercase}`,
  items: [
    // TODO
  ]
});
```

----------------------------------------

TITLE: Registering Edit Form Props in NocoBase Component Context
DESCRIPTION: This snippet updates the `PluginSettingsTable` component to register the newly created `useEditFormProps` hook within the `SchemaComponent`'s scope. This makes the hook available for use by schema definitions within the component, enabling the edit form functionality to properly initialize with record data.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/plugin-samples/plugin-settings/table.md#_snippet_17

LANGUAGE: tsx
CODE:
```
export const PluginSettingsTable = () => {
  return (
    <ExtendCollectionsProvider collections={[emailTemplatesCollection]}>
      <SchemaComponent schema={schema} scope={{ useSubmitActionProps, useEditFormProps }} />
    </ExtendCollectionsProvider>
  );
};
```

----------------------------------------

TITLE: Migrating to NocoBase Plugin System for Providers
DESCRIPTION: This snippet illustrates the new approach for integrating providers within the NocoBase v0.11 plugin system. It demonstrates how to wrap a component provider within a `Plugin` class, registering it during the plugin's `load` phase using `this.app.addProvider()`, and exporting the plugin class instead of the component directly.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/welcome/release/v0110-changelog.md#_snippet_1

LANGUAGE: typescript
CODE:
```
import { Plugin } from '@nocobase/client'

const HelloProvider = (props) => {
  // do something logic
  return <div>
    {props.children}
  </div>;
}

export class HelloPlugin extends Plugin {
  async load() {
    this.app.addProvider(HelloProvider);
  }
}

export default HelloPlugin;
```

----------------------------------------

TITLE: Migrate Nocobase Custom Commands to Convention-Based Files
DESCRIPTION: This snippet explains a breaking change for custom command definitions. Instead of defining commands inline within the plugin's `load` method, they should now be placed in separate files within the `src/server/commands` directory. The example shows the removal of the inline command definition and the new file structure for defining commands.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/release/v0190-changelog.md#_snippet_6

LANGUAGE: diff
CODE:
```
export class MyPlugin extends Plugin {
  load() {
-   this.app
-      .command('echo')
-      .option('-v, --version');
-      .action(async ([options]) => {
-        console.log('Hello World!');
-        if (options.version) {
-          console.log('Current version:', app.getVersion());
-        }
-      });
-  }
}
```

LANGUAGE: typescript
CODE:
```
export default function(app) {
  app
    .command('echo')
    .option('-v, --version')
    .action(async ([options]) => {
      console.log('Hello World!');
      if (options.version) {
        console.log('Current version:', await app.version.get());
      }
    });
}
```

----------------------------------------

TITLE: Configuring NocoBase Docker Compose for Custom Build
DESCRIPTION: This `docker-compose.yml` snippet shows modifications required to build the NocoBase application image locally using a custom Dockerfile instead of pulling a pre-built image. It also ensures the MariaDB service is configured with the correct image and environment variables for NocoBase to connect to it. The `diff` format highlights the changes from previous configurations.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/en-US/handbook/backups/installation/mariadb.md#_snippet_1

LANGUAGE: YAML
CODE:
```
version: "3"

networks:
  nocobase:
    driver: bridge

services:
  app:
-   image: nocobase/nocobase:next  # (previously: registry.cn-shanghai.aliyuncs.com/nocobase/nocobase:next)
+   build:
+     dockerfile: Dockerfile
    networks:
      - nocobase
    restart: always
    depends_on:
      - mariadb
    environment:
      # Application secret key used for generating user tokens, etc.
      # Changing APP_KEY will invalidate existing tokens.
      # Use any random string and keep it confidential.
      - APP_KEY=your-secret-key
      # Database dialect; supports postgres, mysql, mariadb, sqlite
      - DB_DIALECT=mariadb
      # Database host; can be replaced with an existing database server's IP
      - DB_HOST=mariadb
      # Database name
      - DB_DATABASE=nocobase
      # Database user
      - DB_USER=root
      # Database password
      - DB_PASSWORD=nocobase
      # Whether to convert table and field names to snake case
      - DB_UNDERSCORED=true
      # Time zone
      - TZ=Asia/Shanghai
    volumes:
      - ./storage:/app/nocobase/storage
    ports:
      - "13000:80"
    # init: true

  # If you are using an existing database service, you can omit starting mariadb
  mariadb:
-    image: nocobase/mariadb:11  # (previously: registry.cn-shanghai.aliyuncs.com/nocobase/mariadb:11)
+    image: nocobase/mariadb:11
    environment:
      MYSQL_DATABASE: nocobase
      MYSQL_USER: nocobase
      MYSQL_PASSWORD: nocobase
      MYSQL_ROOT_PASSWORD: nocobase
    restart: always
    volumes:
      - ./storage/db/mariadb:/var/lib/mysql
    networks:
      - nocobase
```

----------------------------------------

TITLE: Creating NocoBase App (Beta, MariaDB, Bash)
DESCRIPTION: This command initializes a new NocoBase project named 'my-nocobase-app' using the beta version, configured for a MariaDB database. It sets essential environment variables for database connection (host, port, database name, user, password) and timezone, along with optional NocoBase package credentials.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/welcome/getting-started/installation/create-nocobase-app.md#_snippet_7

LANGUAGE: bash
CODE:
```
npx create-nocobase-app@beta my-nocobase-app -d mariadb \
   -e DB_HOST=localhost \
   -e DB_PORT=3306 \
   -e DB_DATABASE=nocobase \
   -e DB_USER=nocobase \
   -e DB_PASSWORD=nocobase \
   -e TZ=Asia/Shanghai \
   -e NOCOBASE_PKG_USERNAME= \
   -e NOCOBASE_PKG_PASSWORD=
```

----------------------------------------

TITLE: HasOne Association Interface and Example
DESCRIPTION: Defines the TypeScript interface for a `HasOne` association, detailing properties such as `type`, `name`, `target`, `sourceKey`, and `foreignKey`. The example shows how to configure a `hasOne` relationship for a `users` collection, linking `id` in `users` to `userId` in `profiles`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/development/server/collections/association-fields.md#_snippet_3

LANGUAGE: TypeScript
CODE:
```
interface HasOne {
  type: 'hasOne';
  name: string;
  // defaults to name's plural
  target?: string;
  // The default value is the primary key of the source model, usually 'id'
  sourceKey?: string;
  // default value is the singular form of source collection name + 'Id'
  foreignKey?: string;
foreignKey?}

// The users table's primary key id is concatenated with the profiles' foreign key userId
{
  name: 'users',
  fields: [
    {
      type: 'hasOne',
      name: 'profile',
      target: 'profiles',
      sourceKey: 'id', // users table's primary key
      foreignKey: 'userId', // foreign key in profiles table
    }
  ],
}
```

----------------------------------------

TITLE: TypeScript: Add and Manage Custom Charts in NocoBase
DESCRIPTION: This snippet demonstrates how to add a new chart group, redefine an existing group, or add a single chart to a specified group within the NocoBase data visualization plugin. It requires the '@nocobase/plugin-data-visualization' dependency. The chart name must be unique within its group.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/handbook/data-visualization/dev/index.md#_snippet_6

LANGUAGE: typescript
CODE:
```
import DataVisualization from '@nocobase/plugin-data-visualization'

class CustomChartsPlugin extends Plugin {
  async load() {
    const plugin = this.app.pm.get(DataVisualization);

    // Add a chart group
    plugin.charts.addGroup('custom', [...]);

    // Define a chart group,
    // can be used to replace an existing group
    plugin.charts.setGroup('custom', [...]);

    // Add a chart to an existing group
    // The chart name must be unique within a group
    plugin.charts.add('Built-in', new CustomChart({
      // ...
    }));
  }
}
```

----------------------------------------

TITLE: Integrating Custom SchemaInitializer Item in NocoBase (Diff)
DESCRIPTION: This `diff` snippet shows how to integrate the previously defined `customRefreshActionInitializerItem` into an existing `SchemaInitializer` instance named `configureActionsInitializer`. It demonstrates importing the custom item and adding it to the `items` array, making it available in the NocoBase UI for configuration actions. This allows the custom refresh action to be presented alongside other predefined actions.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/plugin-samples/schema-initializer/configure-actions.md#_snippet_16

LANGUAGE: TypeScript
CODE:
```
import { SchemaInitializer } from "@nocobase/client";
+ import { customRefreshActionInitializerItem } from "./items/customRefresh";

export const configureActionsInitializer = new SchemaInitializer({
  name: 'info:configureActions',
  title: 'Configure actions',
  icon: 'SettingOutlined',
  style: {
    marginLeft: 8,
  },
  items: [
    {
      name: 'customRequest',
      title: '{{t("Custom request")}}',
      Component: 'CustomRequestInitializer',
      'x-align': 'right',
    },
+   customRefreshActionInitializerItem
  ]
});
```

----------------------------------------

TITLE: Finding and Counting Associated Objects with HasManyRepository (TypeScript)
DESCRIPTION: This method finds datasets and returns the total count of results for associated objects. It accepts `FindAndCountOptions` and returns a Promise resolving to a tuple containing an array of results and the total count.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/fr-FR/api/database/relation-repository/has-many-repository.md#_snippet_3

LANGUAGE: typescript
CODE:
```
async findAndCount(options?: FindAndCountOptions): Promise<[any[], number]>
```

LANGUAGE: typescript
CODE:
```
type FindAndCountOptions = CommonFindOptions;
```

----------------------------------------

TITLE: NocoBase Filter: $and Operator for Logical AND
DESCRIPTION: Combines multiple filter conditions with a logical AND. All specified conditions must be true for a record to match. This operator is equivalent to SQL's `AND`.
SOURCE: https://github.com/nocobase/docs/blob/main/docs/zh-CN/api/database/operators.md#_snippet_10

LANGUAGE: ts
CODE:
```
repository.find({
  filter: {
    $and: [{ title: '诗经' }, { isbn: '1234567890' }],
  },
});
```
