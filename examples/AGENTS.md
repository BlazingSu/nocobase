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
