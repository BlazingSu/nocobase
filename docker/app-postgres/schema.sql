--
-- PostgreSQL database dump
--

-- Dumped from database version 10.21 (Debian 10.21-1.pgdg90+1)
-- Dumped by pg_dump version 10.21 (Debian 10.21-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: apiKeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."apiKeys" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    name character varying(255),
    "roleName" character varying(255),
    "expiresIn" character varying(255),
    token character varying(255),
    sort bigint,
    "createdById" bigint
);


--
-- Name: apiKeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."apiKeys_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: apiKeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."apiKeys_id_seq" OWNED BY public."apiKeys".id;


--
-- Name: applicationPlugins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."applicationPlugins" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    "packageName" character varying(255),
    version character varying(255),
    enabled boolean,
    installed boolean,
    "builtIn" boolean,
    options json
);


--
-- Name: applicationPlugins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."applicationPlugins_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicationPlugins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."applicationPlugins_id_seq" OWNED BY public."applicationPlugins".id;


--
-- Name: applicationVersion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."applicationVersion" (
    id bigint NOT NULL,
    value character varying(255)
);


--
-- Name: applicationVersion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."applicationVersion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicationVersion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."applicationVersion_id_seq" OWNED BY public."applicationVersion".id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    filename character varying(255),
    extname character varying(255),
    size integer,
    mimetype character varying(255),
    path text,
    meta jsonb DEFAULT '{}'::jsonb,
    url text,
    "createdById" bigint,
    "updatedById" bigint,
    "storageId" bigint
);


--
-- Name: COLUMN attachments.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.title IS '用户文件名（不含扩展名）';


--
-- Name: COLUMN attachments.filename; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.filename IS '系统文件名（含扩展名）';


--
-- Name: COLUMN attachments.extname; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.extname IS '扩展名（含“.”）';


--
-- Name: COLUMN attachments.size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.size IS '文件体积（字节）';


--
-- Name: COLUMN attachments.path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.path IS '相对路径（含“/”前缀）';


--
-- Name: COLUMN attachments.meta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.meta IS '其他文件信息（如图片的宽高）';


--
-- Name: COLUMN attachments.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attachments.url IS '网络访问地址';


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: authenticators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authenticators (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "authType" character varying(255) NOT NULL,
    title character varying(255),
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    options json DEFAULT '{}'::json NOT NULL,
    enabled boolean DEFAULT false,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: authenticators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authenticators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authenticators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authenticators_id_seq OWNED BY public.authenticators.id;


--
-- Name: blockTemplateLinks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."blockTemplateLinks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "templateKey" character varying(255),
    "templateBlockUid" character varying(255),
    "blockUid" character varying(255)
);


--
-- Name: blockTemplateLinks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."blockTemplateLinks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blockTemplateLinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."blockTemplateLinks_id_seq" OWNED BY public."blockTemplateLinks".id;


--
-- Name: blockTemplates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."blockTemplates" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    title character varying(255),
    description character varying(255),
    type character varying(255) DEFAULT 'Desktop'::character varying,
    uid character varying(255),
    configured boolean DEFAULT false,
    collection character varying(255),
    "dataSource" character varying(255),
    "componentType" character varying(255),
    "menuName" character varying(255)
);


--
-- Name: collectionCategories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."collectionCategories" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    color character varying(255) DEFAULT 'default'::character varying,
    sort bigint
);


--
-- Name: collectionCategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."collectionCategories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collectionCategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."collectionCategories_id_seq" OWNED BY public."collectionCategories".id;


--
-- Name: collectionCategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."collectionCategory" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "collectionName" character varying(255) NOT NULL,
    "categoryId" bigint NOT NULL
);


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    key character varying(255) NOT NULL,
    name character varying(255),
    title character varying(255),
    inherit boolean DEFAULT false,
    hidden boolean DEFAULT false,
    options json DEFAULT '{}'::json,
    description character varying(255),
    sort bigint
);


--
-- Name: customRequests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."customRequests" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    options json
);


--
-- Name: customRequestsRoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."customRequestsRoles" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "customRequestKey" character varying(255) NOT NULL,
    "roleName" character varying(255) NOT NULL
);


--
-- Name: dataSources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSources" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    "displayName" character varying(255),
    type character varying(255),
    options json,
    enabled boolean DEFAULT true,
    fixed boolean DEFAULT false
);


--
-- Name: dataSourcesCollections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesCollections" (
    key character varying(255) NOT NULL,
    name character varying(255),
    options json,
    "dataSourceKey" character varying(255)
);


--
-- Name: dataSourcesFields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesFields" (
    key character varying(255) NOT NULL,
    name character varying(255),
    "collectionName" character varying(255),
    interface character varying(255),
    description character varying(255),
    "uiSchema" json,
    "collectionKey" character varying(255),
    options json DEFAULT '{}'::json,
    "dataSourceKey" character varying(255)
);


--
-- Name: dataSourcesRoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesRoles" (
    id character varying(255) NOT NULL,
    "roleName" character varying(255),
    strategy json,
    "dataSourceKey" character varying(255)
);


--
-- Name: dataSourcesRolesResources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesRolesResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "dataSourceKey" character varying(255) DEFAULT 'main'::character varying,
    "roleName" character varying(255),
    name character varying(255),
    "usingActionsConfig" boolean
);


--
-- Name: dataSourcesRolesResourcesActions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesRolesResourcesActions" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    fields jsonb DEFAULT '[]'::jsonb,
    "scopeId" bigint,
    "rolesResourceId" bigint
);


--
-- Name: dataSourcesRolesResourcesActions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."dataSourcesRolesResourcesActions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataSourcesRolesResourcesActions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."dataSourcesRolesResourcesActions_id_seq" OWNED BY public."dataSourcesRolesResourcesActions".id;


--
-- Name: dataSourcesRolesResourcesScopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."dataSourcesRolesResourcesScopes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    "dataSourceKey" character varying(255) DEFAULT 'main'::character varying,
    name character varying(255),
    "resourceName" character varying(255),
    scope json
);


--
-- Name: dataSourcesRolesResourcesScopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."dataSourcesRolesResourcesScopes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataSourcesRolesResourcesScopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."dataSourcesRolesResourcesScopes_id_seq" OWNED BY public."dataSourcesRolesResourcesScopes".id;


--
-- Name: dataSourcesRolesResources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."dataSourcesRolesResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataSourcesRolesResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."dataSourcesRolesResources_id_seq" OWNED BY public."dataSourcesRolesResources".id;


--
-- Name: desktopRoutes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."desktopRoutes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "parentId" bigint,
    title character varying(255),
    tooltip character varying(255),
    icon character varying(255),
    "schemaUid" character varying(255),
    "menuSchemaUid" character varying(255),
    "tabSchemaName" character varying(255),
    type character varying(255),
    options json,
    sort bigint,
    "hideInMenu" boolean,
    "enableTabs" boolean,
    "enableHeader" boolean,
    "displayTitle" boolean,
    hidden boolean,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: desktopRoutes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."desktopRoutes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: desktopRoutes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."desktopRoutes_id_seq" OWNED BY public."desktopRoutes".id;


--
-- Name: environmentVariables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."environmentVariables" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    value text
);


--
-- Name: executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.executions (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    "eventKey" character varying(255),
    context json,
    status integer,
    stack json,
    output json,
    "workflowId" bigint
);


--
-- Name: executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.executions_id_seq OWNED BY public.executions.id;


--
-- Name: fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fields (
    key character varying(255) NOT NULL,
    name character varying(255),
    type character varying(255),
    interface character varying(255),
    description character varying(255),
    "collectionName" character varying(255),
    "parentKey" character varying(255),
    "reverseKey" character varying(255),
    options json DEFAULT '{}'::json,
    sort bigint
);


--
-- Name: flow_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_nodes (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    title character varying(255),
    "upstreamId" bigint,
    "branchIndex" integer,
    "downstreamId" bigint,
    type character varying(255),
    config json DEFAULT '{}'::json,
    "workflowId" bigint
);


--
-- Name: flow_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_nodes_id_seq OWNED BY public.flow_nodes.id;


--
-- Name: iframeHtml; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."iframeHtml" (
    id character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    html text,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: issuedTokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."issuedTokens" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    id uuid NOT NULL,
    "signInTime" bigint NOT NULL,
    jti uuid NOT NULL,
    "issuedTime" bigint NOT NULL,
    "userId" bigint NOT NULL
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    id bigint NOT NULL,
    "executionId" bigint,
    "nodeId" bigint,
    "nodeKey" character varying(255),
    "upstreamId" bigint,
    status integer,
    result json
);


--
-- Name: listing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listing (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdById" bigint,
    "updatedById" bigint,
    id character varying(255) NOT NULL,
    catalog character varying(255),
    title character varying(255),
    bulletpoint1 character varying(255),
    bulletpoint2 character varying(255),
    bulletpoint3 character varying(255),
    bulletpoint4 character varying(255),
    bulletpoint5 character varying(255),
    description text,
    f_fg3scgfk7gp character varying(255),
    search_terms text,
    long_terms text,
    core_terms text
);


--
-- Name: llmServices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."llmServices" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    provider character varying(255),
    options jsonb
);


--
-- Name: localizationTexts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."localizationTexts" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    module character varying(255) NOT NULL,
    text text NOT NULL,
    batch character varying(255),
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: localizationTexts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."localizationTexts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: localizationTexts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."localizationTexts_id_seq" OWNED BY public."localizationTexts".id;


--
-- Name: localizationTranslations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."localizationTranslations" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    locale character varying(255) NOT NULL,
    translation text DEFAULT ''::text NOT NULL,
    "textId" bigint,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: localizationTranslations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."localizationTranslations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: localizationTranslations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."localizationTranslations_id_seq" OWNED BY public."localizationTranslations".id;


--
-- Name: main_desktopRoutes_path; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."main_desktopRoutes_path" (
    "nodePk" integer,
    path character varying(1024),
    "rootPk" integer
);


--
-- Name: main_mobileRoutes_path; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."main_mobileRoutes_path" (
    "nodePk" integer,
    path character varying(1024),
    "rootPk" integer
);


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    name character varying(255) NOT NULL
);


--
-- Name: mobileRoutes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."mobileRoutes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "parentId" bigint,
    title character varying(255),
    icon character varying(255),
    "schemaUid" character varying(255),
    type character varying(255),
    options json,
    sort bigint,
    "hideInMenu" boolean,
    "enableTabs" boolean,
    hidden boolean,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: mobileRoutes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."mobileRoutes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mobileRoutes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."mobileRoutes_id_seq" OWNED BY public."mobileRoutes".id;


--
-- Name: notificationChannels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."notificationChannels" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    options json,
    meta json,
    "notificationType" character varying(255),
    description text,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: notificationInAppMessages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."notificationInAppMessages" (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint,
    "channelName" character varying(255),
    title text,
    content text,
    status character varying(255),
    "receiveTimestamp" bigint,
    options json
);


--
-- Name: notificationSendLogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."notificationSendLogs" (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "channelName" character varying(255),
    "channelTitle" character varying(255),
    "triggerFrom" character varying(255),
    "notificationType" character varying(255),
    status character varying(255),
    message json,
    reason text
);


--
-- Name: otpRecords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."otpRecords" (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    action character varying(255),
    receiver character varying(255),
    status integer DEFAULT 0,
    "expiresAt" bigint,
    code character varying(255),
    "verifierName" character varying(255)
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdById" bigint,
    "updatedById" bigint,
    id character varying(255) NOT NULL,
    sku character varying(255),
    product_name character varying(255),
    f_zjav3kjr5jc character varying(255),
    competitor1 text,
    competitor2 text,
    competitor3 text,
    competitor4 text,
    competitor5 text,
    "analyse" text,
    length double precision,
    width double precision,
    height double precision,
    package_length double precision,
    package_width double precision,
    package_height double precision,
    package_volume_weight double precision,
    weight double precision,
    package_weight double precision,
    max_weight double precision,
    fee_standard character varying(255),
    fee double precision,
    price_us double precision,
    cost double precision,
    shipping_profit_margin double precision,
    air_freight_profit_margin double precision
);


--
-- Name: publicForms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."publicForms" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    title character varying(255),
    type character varying(255),
    collection character varying(255),
    description character varying(255),
    enabled boolean,
    password character varying(255),
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: publicForms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."publicForms_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publicForms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."publicForms_id_seq" OWNED BY public."publicForms".id;


--
-- Name: purchase_apply; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_apply (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdById" bigint,
    "updatedById" bigint,
    id character varying(255) NOT NULL,
    quantity bigint,
    purchase_reason character varying(255),
    note text,
    f_zlpp4ei8gnz character varying(255)
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    description character varying(255),
    strategy json,
    "default" boolean DEFAULT false,
    hidden boolean DEFAULT false,
    "allowConfigure" boolean,
    "allowNewMenu" boolean,
    snippets jsonb DEFAULT '["!ui.*", "!pm", "!pm.*"]'::jsonb,
    sort bigint,
    "allowNewMobileMenu" boolean
);


--
-- Name: rolesDesktopRoutes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesDesktopRoutes" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "desktopRouteId" bigint NOT NULL,
    "roleName" character varying(255) NOT NULL
);


--
-- Name: rolesMobileRoutes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesMobileRoutes" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "mobileRouteId" bigint NOT NULL,
    "roleName" character varying(255) NOT NULL
);


--
-- Name: rolesResources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "roleName" character varying(255),
    name character varying(255),
    "usingActionsConfig" boolean
);


--
-- Name: rolesResourcesActions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesResourcesActions" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "rolesResourceId" bigint,
    name character varying(255),
    fields jsonb DEFAULT '[]'::jsonb,
    "scopeId" bigint
);


--
-- Name: rolesResourcesActions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."rolesResourcesActions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolesResourcesActions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."rolesResourcesActions_id_seq" OWNED BY public."rolesResourcesActions".id;


--
-- Name: rolesResourcesScopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesResourcesScopes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    name character varying(255),
    "resourceName" character varying(255),
    scope json
);


--
-- Name: rolesResourcesScopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."rolesResourcesScopes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolesResourcesScopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."rolesResourcesScopes_id_seq" OWNED BY public."rolesResourcesScopes".id;


--
-- Name: rolesResources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."rolesResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolesResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."rolesResources_id_seq" OWNED BY public."rolesResources".id;


--
-- Name: rolesUischemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesUischemas" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "roleName" character varying(255) NOT NULL,
    "uiSchemaXUid" character varying(255) NOT NULL
);


--
-- Name: rolesUsers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."rolesUsers" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "default" boolean,
    "roleName" character varying(255) NOT NULL,
    "userId" bigint NOT NULL
);


--
-- Name: sequences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sequences (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    collection character varying(255),
    field character varying(255),
    key integer,
    current bigint,
    "lastGeneratedAt" timestamp with time zone
);


--
-- Name: sequences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sequences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sequences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sequences_id_seq OWNED BY public.sequences.id;


--
-- Name: storages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storages (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    name character varying(255),
    type character varying(255),
    options jsonb DEFAULT '{}'::jsonb,
    rules jsonb DEFAULT '{}'::jsonb,
    path text DEFAULT ''::text,
    "baseUrl" character varying(255) DEFAULT ''::character varying,
    "default" boolean DEFAULT false,
    paranoid boolean DEFAULT false
);


--
-- Name: COLUMN storages.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages.title IS '存储引擎名称';


--
-- Name: COLUMN storages.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages.type IS '类型标识，如 local/ali-oss 等';


--
-- Name: COLUMN storages.options; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages.options IS '配置项';


--
-- Name: COLUMN storages.rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages.rules IS '文件规则';


--
-- Name: COLUMN storages.path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages.path IS '存储相对路径模板';


--
-- Name: COLUMN storages."baseUrl"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages."baseUrl" IS '访问地址前缀';


--
-- Name: COLUMN storages."default"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.storages."default" IS '默认引擎';


--
-- Name: storages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.storages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: storages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.storages_id_seq OWNED BY public.storages.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdById" bigint,
    "updatedById" bigint,
    id character varying(255) NOT NULL,
    supplier_name character varying(255),
    supplier_info_link text,
    rating character varying(255),
    sn character varying(255),
    note text,
    contact character varying(255),
    tel character varying(255),
    address character varying(255)
);


--
-- Name: supplies_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplies_info (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdById" bigint,
    "updatedById" bigint,
    id character varying(255) NOT NULL,
    f_mg0tjx73t8q character varying(255),
    purchase_url text,
    alt_purchase_url text,
    alt_purchase_url_1 text,
    first_batch_quantity bigint,
    purchase_cycle_days bigint,
    packaging_type character varying(255) DEFAULT '仓库打包'::character varying,
    sample_status character varying(255) DEFAULT '否'::character varying
);


--
-- Name: systemSettings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."systemSettings" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    "showLogoOnly" boolean,
    "allowSignUp" boolean DEFAULT true,
    "smsAuthEnabled" boolean DEFAULT false,
    "logoId" bigint,
    "enabledLanguages" json DEFAULT '[]'::json,
    "appLang" character varying(255),
    options json DEFAULT '{}'::json,
    "roleMode" character varying(255) DEFAULT 'default'::character varying,
    "enableEditProfile" boolean,
    "enableChangePassword" boolean
);


--
-- Name: systemSettings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."systemSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: systemSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."systemSettings_id_seq" OWNED BY public."systemSettings".id;


--
-- Name: t_59mpcgc2x1v; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.t_59mpcgc2x1v (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    f_63r6uco4tl7 character varying(255) NOT NULL,
    f_jvb88ftto9k bigint NOT NULL
);


--
-- Name: t_apsa39qy9dl; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.t_apsa39qy9dl (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    f_5ibnre6zx1r character varying(255) NOT NULL,
    f_mj1bglaapum bigint NOT NULL
);


--
-- Name: t_wa4fz03kwue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.t_wa4fz03kwue (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    f_knskxzfhfns character varying(255) NOT NULL,
    f_bu7g08i9bh9 bigint NOT NULL
);


--
-- Name: themeConfig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."themeConfig" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    config json,
    optional boolean,
    "isBuiltIn" boolean,
    uid character varying(255),
    "default" boolean DEFAULT false
);


--
-- Name: themeConfig_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."themeConfig_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themeConfig_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."themeConfig_id_seq" OWNED BY public."themeConfig".id;


--
-- Name: tokenBlacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."tokenBlacklist" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    token character varying(255),
    expiration timestamp with time zone
);


--
-- Name: tokenBlacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."tokenBlacklist_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokenBlacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."tokenBlacklist_id_seq" OWNED BY public."tokenBlacklist".id;


--
-- Name: tokenControlConfig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."tokenControlConfig" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: uiButtonSchemasRoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."uiButtonSchemasRoles" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    uid character varying(255),
    "roleName" character varying(255)
);


--
-- Name: uiSchemaServerHooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."uiSchemaServerHooks" (
    id bigint NOT NULL,
    type character varying(255),
    collection character varying(255),
    field character varying(255),
    method character varying(255),
    params json,
    uid character varying(255)
);


--
-- Name: uiSchemaServerHooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."uiSchemaServerHooks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uiSchemaServerHooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."uiSchemaServerHooks_id_seq" OWNED BY public."uiSchemaServerHooks".id;


--
-- Name: uiSchemaTemplates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."uiSchemaTemplates" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255),
    "componentName" character varying(255),
    "associationName" character varying(255),
    "resourceName" character varying(255),
    "collectionName" character varying(255),
    "dataSourceKey" character varying(255),
    uid character varying(255)
);


--
-- Name: uiSchemaTreePath; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."uiSchemaTreePath" (
    ancestor character varying(255) NOT NULL,
    descendant character varying(255) NOT NULL,
    depth integer,
    async boolean,
    type character varying(255),
    sort integer
);


--
-- Name: COLUMN "uiSchemaTreePath".type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."uiSchemaTreePath".type IS 'type of node';


--
-- Name: COLUMN "uiSchemaTreePath".sort; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."uiSchemaTreePath".sort IS 'sort of node in adjacency';


--
-- Name: uiSchemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."uiSchemas" (
    "x-uid" character varying(255) NOT NULL,
    name character varying(255),
    schema json DEFAULT '{}'::json
);


--
-- Name: userDataSyncRecords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."userDataSyncRecords" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "sourceName" character varying(255) NOT NULL,
    "sourceUk" character varying(255) NOT NULL,
    "dataType" character varying(255) NOT NULL,
    "metaData" json,
    "lastMetaData" json
);


--
-- Name: userDataSyncRecordsResources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."userDataSyncRecordsResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "recordId" bigint,
    resource character varying(255) NOT NULL,
    "resourcePk" character varying(255)
);


--
-- Name: userDataSyncRecordsResources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userDataSyncRecordsResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userDataSyncRecordsResources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userDataSyncRecordsResources_id_seq" OWNED BY public."userDataSyncRecordsResources".id;


--
-- Name: userDataSyncRecords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userDataSyncRecords_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userDataSyncRecords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userDataSyncRecords_id_seq" OWNED BY public."userDataSyncRecords".id;


--
-- Name: userDataSyncSources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."userDataSyncSources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "sourceType" character varying(255) NOT NULL,
    "displayName" character varying(255),
    enabled boolean DEFAULT false,
    options json DEFAULT '{}'::json NOT NULL,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: userDataSyncSources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userDataSyncSources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userDataSyncSources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userDataSyncSources_id_seq" OWNED BY public."userDataSyncSources".id;


--
-- Name: userDataSyncTasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."userDataSyncTasks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    batch character varying(255) NOT NULL,
    "sourceId" bigint,
    status character varying(255) NOT NULL,
    message character varying(255),
    cost integer,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: userDataSyncTasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userDataSyncTasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userDataSyncTasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userDataSyncTasks_id_seq" OWNED BY public."userDataSyncTasks".id;


--
-- Name: userWorkflowTasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."userWorkflowTasks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint,
    type character varying(255),
    stats json DEFAULT '{}'::json
);


--
-- Name: userWorkflowTasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userWorkflowTasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userWorkflowTasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userWorkflowTasks_id_seq" OWNED BY public."userWorkflowTasks".id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    nickname character varying(255),
    username character varying(255),
    email character varying(255),
    phone character varying(255),
    password character varying(255),
    "passwordChangeTz" bigint,
    "appLang" character varying(255),
    "resetToken" character varying(255),
    "systemSettings" json DEFAULT '{}'::json,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);


--
-- Name: usersAuthenticators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."usersAuthenticators" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    uuid character varying(255) NOT NULL,
    nickname character varying(255) DEFAULT ''::character varying NOT NULL,
    avatar character varying(255) DEFAULT ''::character varying NOT NULL,
    meta json DEFAULT '{}'::json,
    "createdById" bigint,
    "updatedById" bigint,
    authenticator character varying(255) NOT NULL,
    "userId" bigint NOT NULL
);


--
-- Name: usersVerificators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."usersVerificators" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    uuid character varying(255) NOT NULL,
    meta json DEFAULT '{}'::json,
    "createdById" bigint,
    "updatedById" bigint,
    verificator character varying(255) NOT NULL,
    "userId" bigint NOT NULL
);


--
-- Name: usersVerifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."usersVerifiers" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    uuid character varying(255) NOT NULL,
    meta json DEFAULT '{}'::json,
    "createdById" bigint,
    "updatedById" bigint,
    verifier character varying(255) NOT NULL,
    "userId" bigint NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verifications (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    type character varying(255),
    receiver character varying(255),
    status integer DEFAULT 0,
    "expiresAt" timestamp with time zone,
    content character varying(255),
    "providerId" character varying(255)
);


--
-- Name: verifications_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verifications_providers (
    id character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    type character varying(255),
    options jsonb,
    "default" boolean
);


--
-- Name: verificators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verificators (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    "verificationType" character varying(255),
    description character varying(255),
    options jsonb
);


--
-- Name: verifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verifiers (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    "verificationType" character varying(255),
    description character varying(255),
    options jsonb
);


--
-- Name: workflowCategories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowCategories" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    color character varying(255) DEFAULT 'default'::character varying,
    sort bigint
);


--
-- Name: workflowCategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."workflowCategories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflowCategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."workflowCategories_id_seq" OWNED BY public."workflowCategories".id;


--
-- Name: workflowCategoryRelations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowCategoryRelations" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "workflowCategoryId" bigint,
    "workflowId" bigint NOT NULL,
    "categoryId" bigint NOT NULL
);


--
-- Name: workflowManualTasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowManualTasks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "jobId" bigint,
    "userId" bigint,
    title character varying(255),
    "executionId" bigint,
    "nodeId" bigint,
    "workflowId" bigint,
    status integer,
    result jsonb
);


--
-- Name: workflowManualTasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."workflowManualTasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflowManualTasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."workflowManualTasks_id_seq" OWNED BY public."workflowManualTasks".id;


--
-- Name: workflowStats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowStats" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    executed bigint DEFAULT 0
);


--
-- Name: workflowTasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowTasks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint,
    type character varying(255),
    key character varying(255),
    "workflowId" bigint
);


--
-- Name: workflowTasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."workflowTasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflowTasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."workflowTasks_id_seq" OWNED BY public."workflowTasks".id;


--
-- Name: workflowVersionStats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."workflowVersionStats" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    id bigint NOT NULL,
    executed bigint DEFAULT 0
);


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    title character varying(255),
    enabled boolean DEFAULT false,
    description text,
    type character varying(255),
    "triggerTitle" character varying(255),
    config jsonb DEFAULT '{}'::jsonb,
    executed integer DEFAULT 0,
    "allExecuted" integer DEFAULT 0,
    current boolean,
    sync boolean DEFAULT false,
    options jsonb DEFAULT '{}'::jsonb
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- Name: apiKeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."apiKeys" ALTER COLUMN id SET DEFAULT nextval('public."apiKeys_id_seq"'::regclass);


--
-- Name: applicationPlugins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationPlugins" ALTER COLUMN id SET DEFAULT nextval('public."applicationPlugins_id_seq"'::regclass);


--
-- Name: applicationVersion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationVersion" ALTER COLUMN id SET DEFAULT nextval('public."applicationVersion_id_seq"'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: authenticators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticators ALTER COLUMN id SET DEFAULT nextval('public.authenticators_id_seq'::regclass);


--
-- Name: blockTemplateLinks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."blockTemplateLinks" ALTER COLUMN id SET DEFAULT nextval('public."blockTemplateLinks_id_seq"'::regclass);


--
-- Name: collectionCategories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."collectionCategories" ALTER COLUMN id SET DEFAULT nextval('public."collectionCategories_id_seq"'::regclass);


--
-- Name: dataSourcesRolesResources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResources" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResources_id_seq"'::regclass);


--
-- Name: dataSourcesRolesResourcesActions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResourcesActions" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResourcesActions_id_seq"'::regclass);


--
-- Name: dataSourcesRolesResourcesScopes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResourcesScopes" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResourcesScopes_id_seq"'::regclass);


--
-- Name: desktopRoutes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."desktopRoutes" ALTER COLUMN id SET DEFAULT nextval('public."desktopRoutes_id_seq"'::regclass);


--
-- Name: executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.executions ALTER COLUMN id SET DEFAULT nextval('public.executions_id_seq'::regclass);


--
-- Name: flow_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_nodes ALTER COLUMN id SET DEFAULT nextval('public.flow_nodes_id_seq'::regclass);


--
-- Name: localizationTexts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."localizationTexts" ALTER COLUMN id SET DEFAULT nextval('public."localizationTexts_id_seq"'::regclass);


--
-- Name: localizationTranslations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."localizationTranslations" ALTER COLUMN id SET DEFAULT nextval('public."localizationTranslations_id_seq"'::regclass);


--
-- Name: mobileRoutes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."mobileRoutes" ALTER COLUMN id SET DEFAULT nextval('public."mobileRoutes_id_seq"'::regclass);


--
-- Name: publicForms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."publicForms" ALTER COLUMN id SET DEFAULT nextval('public."publicForms_id_seq"'::regclass);


--
-- Name: rolesResources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResources" ALTER COLUMN id SET DEFAULT nextval('public."rolesResources_id_seq"'::regclass);


--
-- Name: rolesResourcesActions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResourcesActions" ALTER COLUMN id SET DEFAULT nextval('public."rolesResourcesActions_id_seq"'::regclass);


--
-- Name: rolesResourcesScopes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResourcesScopes" ALTER COLUMN id SET DEFAULT nextval('public."rolesResourcesScopes_id_seq"'::regclass);


--
-- Name: sequences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sequences ALTER COLUMN id SET DEFAULT nextval('public.sequences_id_seq'::regclass);


--
-- Name: storages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storages ALTER COLUMN id SET DEFAULT nextval('public.storages_id_seq'::regclass);


--
-- Name: systemSettings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."systemSettings" ALTER COLUMN id SET DEFAULT nextval('public."systemSettings_id_seq"'::regclass);


--
-- Name: themeConfig id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."themeConfig" ALTER COLUMN id SET DEFAULT nextval('public."themeConfig_id_seq"'::regclass);


--
-- Name: tokenBlacklist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."tokenBlacklist" ALTER COLUMN id SET DEFAULT nextval('public."tokenBlacklist_id_seq"'::regclass);


--
-- Name: uiSchemaServerHooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiSchemaServerHooks" ALTER COLUMN id SET DEFAULT nextval('public."uiSchemaServerHooks_id_seq"'::regclass);


--
-- Name: userDataSyncRecords id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncRecords" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncRecords_id_seq"'::regclass);


--
-- Name: userDataSyncRecordsResources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncRecordsResources" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncRecordsResources_id_seq"'::regclass);


--
-- Name: userDataSyncSources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncSources" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncSources_id_seq"'::regclass);


--
-- Name: userDataSyncTasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncTasks" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncTasks_id_seq"'::regclass);


--
-- Name: userWorkflowTasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userWorkflowTasks" ALTER COLUMN id SET DEFAULT nextval('public."userWorkflowTasks_id_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workflowCategories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowCategories" ALTER COLUMN id SET DEFAULT nextval('public."workflowCategories_id_seq"'::regclass);


--
-- Name: workflowManualTasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowManualTasks" ALTER COLUMN id SET DEFAULT nextval('public."workflowManualTasks_id_seq"'::regclass);


--
-- Name: workflowTasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowTasks" ALTER COLUMN id SET DEFAULT nextval('public."workflowTasks_id_seq"'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Name: apiKeys apiKeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."apiKeys"
    ADD CONSTRAINT "apiKeys_pkey" PRIMARY KEY (id);


--
-- Name: applicationPlugins applicationPlugins_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_name_key" UNIQUE (name);


--
-- Name: applicationPlugins applicationPlugins_packageName_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_packageName_key" UNIQUE ("packageName");


--
-- Name: applicationPlugins applicationPlugins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_pkey" PRIMARY KEY (id);


--
-- Name: applicationVersion applicationVersion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."applicationVersion"
    ADD CONSTRAINT "applicationVersion_pkey" PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: authenticators authenticators_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticators
    ADD CONSTRAINT authenticators_name_key UNIQUE (name);


--
-- Name: authenticators authenticators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authenticators
    ADD CONSTRAINT authenticators_pkey PRIMARY KEY (id);


--
-- Name: blockTemplateLinks blockTemplateLinks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."blockTemplateLinks"
    ADD CONSTRAINT "blockTemplateLinks_pkey" PRIMARY KEY (id);


--
-- Name: blockTemplates blockTemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."blockTemplates"
    ADD CONSTRAINT "blockTemplates_pkey" PRIMARY KEY (key);


--
-- Name: collectionCategories collectionCategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."collectionCategories"
    ADD CONSTRAINT "collectionCategories_pkey" PRIMARY KEY (id);


--
-- Name: collectionCategory collectionCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."collectionCategory"
    ADD CONSTRAINT "collectionCategory_pkey" PRIMARY KEY ("collectionName", "categoryId");


--
-- Name: collections collections_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_name_key UNIQUE (name);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (key);


--
-- Name: customRequestsRoles customRequestsRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."customRequestsRoles"
    ADD CONSTRAINT "customRequestsRoles_pkey" PRIMARY KEY ("customRequestKey", "roleName");


--
-- Name: customRequests customRequests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."customRequests"
    ADD CONSTRAINT "customRequests_pkey" PRIMARY KEY (key);


--
-- Name: dataSourcesCollections dataSourcesCollections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesCollections"
    ADD CONSTRAINT "dataSourcesCollections_pkey" PRIMARY KEY (key);


--
-- Name: dataSourcesFields dataSourcesFields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesFields"
    ADD CONSTRAINT "dataSourcesFields_pkey" PRIMARY KEY (key);


--
-- Name: dataSourcesRolesResourcesActions dataSourcesRolesResourcesActions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResourcesActions"
    ADD CONSTRAINT "dataSourcesRolesResourcesActions_pkey" PRIMARY KEY (id);


--
-- Name: dataSourcesRolesResourcesScopes dataSourcesRolesResourcesScopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResourcesScopes"
    ADD CONSTRAINT "dataSourcesRolesResourcesScopes_pkey" PRIMARY KEY (id);


--
-- Name: dataSourcesRolesResources dataSourcesRolesResources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRolesResources"
    ADD CONSTRAINT "dataSourcesRolesResources_pkey" PRIMARY KEY (id);


--
-- Name: dataSourcesRoles dataSourcesRoles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSourcesRoles"
    ADD CONSTRAINT "dataSourcesRoles_pkey" PRIMARY KEY (id);


--
-- Name: dataSources dataSources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."dataSources"
    ADD CONSTRAINT "dataSources_pkey" PRIMARY KEY (key);


--
-- Name: desktopRoutes desktopRoutes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."desktopRoutes"
    ADD CONSTRAINT "desktopRoutes_pkey" PRIMARY KEY (id);


--
-- Name: environmentVariables environmentVariables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."environmentVariables"
    ADD CONSTRAINT "environmentVariables_pkey" PRIMARY KEY (name);


--
-- Name: executions executions_eventKey_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.executions
    ADD CONSTRAINT "executions_eventKey_key" UNIQUE ("eventKey");


--
-- Name: executions executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.executions
    ADD CONSTRAINT executions_pkey PRIMARY KEY (id);


--
-- Name: fields fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (key);


--
-- Name: flow_nodes flow_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_nodes
    ADD CONSTRAINT flow_nodes_pkey PRIMARY KEY (id);


--
-- Name: iframeHtml iframeHtml_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."iframeHtml"
    ADD CONSTRAINT "iframeHtml_pkey" PRIMARY KEY (id);


--
-- Name: issuedTokens issuedTokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."issuedTokens"
    ADD CONSTRAINT "issuedTokens_pkey" PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: listing listing_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listing
    ADD CONSTRAINT listing_id_pk PRIMARY KEY (id);


--
-- Name: llmServices llmServices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."llmServices"
    ADD CONSTRAINT "llmServices_pkey" PRIMARY KEY (name);


--
-- Name: localizationTexts localizationTexts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."localizationTexts"
    ADD CONSTRAINT "localizationTexts_pkey" PRIMARY KEY (id);


--
-- Name: localizationTranslations localizationTranslations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."localizationTranslations"
    ADD CONSTRAINT "localizationTranslations_pkey" PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (name);


--
-- Name: mobileRoutes mobileRoutes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."mobileRoutes"
    ADD CONSTRAINT "mobileRoutes_pkey" PRIMARY KEY (id);


--
-- Name: notificationChannels notificationChannels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."notificationChannels"
    ADD CONSTRAINT "notificationChannels_pkey" PRIMARY KEY (name);


--
-- Name: notificationInAppMessages notificationInAppMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."notificationInAppMessages"
    ADD CONSTRAINT "notificationInAppMessages_pkey" PRIMARY KEY (id);


--
-- Name: notificationSendLogs notificationSendLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."notificationSendLogs"
    ADD CONSTRAINT "notificationSendLogs_pkey" PRIMARY KEY (id);


--
-- Name: otpRecords otpRecords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."otpRecords"
    ADD CONSTRAINT "otpRecords_pkey" PRIMARY KEY (id);


--
-- Name: products products_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_id_pk PRIMARY KEY (id);


--
-- Name: publicForms publicForms_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."publicForms"
    ADD CONSTRAINT "publicForms_key_key" UNIQUE (key);


--
-- Name: publicForms publicForms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."publicForms"
    ADD CONSTRAINT "publicForms_pkey" PRIMARY KEY (id);


--
-- Name: purchase_apply purchase_apply_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_apply
    ADD CONSTRAINT purchase_apply_id_pk PRIMARY KEY (id);


--
-- Name: rolesDesktopRoutes rolesDesktopRoutes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesDesktopRoutes"
    ADD CONSTRAINT "rolesDesktopRoutes_pkey" PRIMARY KEY ("desktopRouteId", "roleName");


--
-- Name: rolesMobileRoutes rolesMobileRoutes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesMobileRoutes"
    ADD CONSTRAINT "rolesMobileRoutes_pkey" PRIMARY KEY ("mobileRouteId", "roleName");


--
-- Name: rolesResourcesActions rolesResourcesActions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResourcesActions"
    ADD CONSTRAINT "rolesResourcesActions_pkey" PRIMARY KEY (id);


--
-- Name: rolesResourcesScopes rolesResourcesScopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResourcesScopes"
    ADD CONSTRAINT "rolesResourcesScopes_pkey" PRIMARY KEY (id);


--
-- Name: rolesResources rolesResources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesResources"
    ADD CONSTRAINT "rolesResources_pkey" PRIMARY KEY (id);


--
-- Name: rolesUischemas rolesUischemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesUischemas"
    ADD CONSTRAINT "rolesUischemas_pkey" PRIMARY KEY ("roleName", "uiSchemaXUid");


--
-- Name: rolesUsers rolesUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."rolesUsers"
    ADD CONSTRAINT "rolesUsers_pkey" PRIMARY KEY ("roleName", "userId");


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);


--
-- Name: roles roles_title_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_title_key UNIQUE (title);


--
-- Name: sequences sequences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sequences
    ADD CONSTRAINT sequences_pkey PRIMARY KEY (id);


--
-- Name: storages storages_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_name_key UNIQUE (name);


--
-- Name: storages storages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_pkey PRIMARY KEY (id);


--
-- Name: supplier supplier_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_id_pk PRIMARY KEY (id);


--
-- Name: supplier supplier_sn_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_sn_key UNIQUE (sn);


--
-- Name: supplies_info supplies_info_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplies_info
    ADD CONSTRAINT supplies_info_id_pk PRIMARY KEY (id);


--
-- Name: systemSettings systemSettings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."systemSettings"
    ADD CONSTRAINT "systemSettings_pkey" PRIMARY KEY (id);


--
-- Name: t_59mpcgc2x1v t_59mpcgc2x1v_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_59mpcgc2x1v
    ADD CONSTRAINT t_59mpcgc2x1v_pkey PRIMARY KEY (f_63r6uco4tl7, f_jvb88ftto9k);


--
-- Name: t_apsa39qy9dl t_apsa39qy9dl_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_apsa39qy9dl
    ADD CONSTRAINT t_apsa39qy9dl_pkey PRIMARY KEY (f_5ibnre6zx1r, f_mj1bglaapum);


--
-- Name: t_wa4fz03kwue t_wa4fz03kwue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.t_wa4fz03kwue
    ADD CONSTRAINT t_wa4fz03kwue_pkey PRIMARY KEY (f_knskxzfhfns, f_bu7g08i9bh9);


--
-- Name: themeConfig themeConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."themeConfig"
    ADD CONSTRAINT "themeConfig_pkey" PRIMARY KEY (id);


--
-- Name: tokenBlacklist tokenBlacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."tokenBlacklist"
    ADD CONSTRAINT "tokenBlacklist_pkey" PRIMARY KEY (id);


--
-- Name: tokenControlConfig tokenControlConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."tokenControlConfig"
    ADD CONSTRAINT "tokenControlConfig_pkey" PRIMARY KEY (key);


--
-- Name: uiButtonSchemasRoles uiButtonSchemasRoles_uid_roleName_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiButtonSchemasRoles"
    ADD CONSTRAINT "uiButtonSchemasRoles_uid_roleName_key" UNIQUE (uid, "roleName");


--
-- Name: uiSchemaServerHooks uiSchemaServerHooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiSchemaServerHooks"
    ADD CONSTRAINT "uiSchemaServerHooks_pkey" PRIMARY KEY (id);


--
-- Name: uiSchemaTemplates uiSchemaTemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiSchemaTemplates"
    ADD CONSTRAINT "uiSchemaTemplates_pkey" PRIMARY KEY (key);


--
-- Name: uiSchemaTreePath uiSchemaTreePath_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiSchemaTreePath"
    ADD CONSTRAINT "uiSchemaTreePath_pkey" PRIMARY KEY (ancestor, descendant);


--
-- Name: uiSchemas uiSchemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."uiSchemas"
    ADD CONSTRAINT "uiSchemas_pkey" PRIMARY KEY ("x-uid");


--
-- Name: userDataSyncRecordsResources userDataSyncRecordsResources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncRecordsResources"
    ADD CONSTRAINT "userDataSyncRecordsResources_pkey" PRIMARY KEY (id);


--
-- Name: userDataSyncRecords userDataSyncRecords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncRecords"
    ADD CONSTRAINT "userDataSyncRecords_pkey" PRIMARY KEY (id);


--
-- Name: userDataSyncSources userDataSyncSources_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncSources"
    ADD CONSTRAINT "userDataSyncSources_name_key" UNIQUE (name);


--
-- Name: userDataSyncSources userDataSyncSources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncSources"
    ADD CONSTRAINT "userDataSyncSources_pkey" PRIMARY KEY (id);


--
-- Name: userDataSyncTasks userDataSyncTasks_batch_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncTasks"
    ADD CONSTRAINT "userDataSyncTasks_batch_key" UNIQUE (batch);


--
-- Name: userDataSyncTasks userDataSyncTasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userDataSyncTasks"
    ADD CONSTRAINT "userDataSyncTasks_pkey" PRIMARY KEY (id);


--
-- Name: userWorkflowTasks userWorkflowTasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."userWorkflowTasks"
    ADD CONSTRAINT "userWorkflowTasks_pkey" PRIMARY KEY (id);


--
-- Name: usersAuthenticators usersAuthenticators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."usersAuthenticators"
    ADD CONSTRAINT "usersAuthenticators_pkey" PRIMARY KEY (authenticator, "userId");


--
-- Name: usersVerificators usersVerificators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."usersVerificators"
    ADD CONSTRAINT "usersVerificators_pkey" PRIMARY KEY (verificator, "userId");


--
-- Name: usersVerifiers usersVerifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."usersVerifiers"
    ADD CONSTRAINT "usersVerifiers_pkey" PRIMARY KEY (verifier, "userId");


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_resetToken_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_resetToken_key" UNIQUE ("resetToken");


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: verifications verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);


--
-- Name: verifications_providers verifications_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifications_providers
    ADD CONSTRAINT verifications_providers_pkey PRIMARY KEY (id);


--
-- Name: verificators verificators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verificators
    ADD CONSTRAINT verificators_pkey PRIMARY KEY (name);


--
-- Name: verifiers verifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifiers
    ADD CONSTRAINT verifiers_pkey PRIMARY KEY (name);


--
-- Name: workflowCategories workflowCategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowCategories"
    ADD CONSTRAINT "workflowCategories_pkey" PRIMARY KEY (id);


--
-- Name: workflowCategoryRelations workflowCategoryRelations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowCategoryRelations"
    ADD CONSTRAINT "workflowCategoryRelations_pkey" PRIMARY KEY ("workflowId", "categoryId");


--
-- Name: workflowManualTasks workflowManualTasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowManualTasks"
    ADD CONSTRAINT "workflowManualTasks_pkey" PRIMARY KEY (id);


--
-- Name: workflowStats workflowStats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowStats"
    ADD CONSTRAINT "workflowStats_pkey" PRIMARY KEY (key);


--
-- Name: workflowTasks workflowTasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowTasks"
    ADD CONSTRAINT "workflowTasks_pkey" PRIMARY KEY (id);


--
-- Name: workflowVersionStats workflowVersionStats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."workflowVersionStats"
    ADD CONSTRAINT "workflowVersionStats_pkey" PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: api_keys_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX api_keys_role_name ON public."apiKeys" USING btree ("roleName");


--
-- Name: attachments_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attachments_created_by_id ON public.attachments USING btree ("createdById");


--
-- Name: attachments_storage_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attachments_storage_id ON public.attachments USING btree ("storageId");


--
-- Name: attachments_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attachments_updated_by_id ON public.attachments USING btree ("updatedById");


--
-- Name: authenticators_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authenticators_created_by_id ON public.authenticators USING btree ("createdById");


--
-- Name: block_template_links_block_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_template_links_block_uid ON public."blockTemplateLinks" USING btree ("blockUid");


--
-- Name: block_template_links_template_block_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_template_links_template_block_uid ON public."blockTemplateLinks" USING btree ("templateBlockUid");


--
-- Name: block_template_links_template_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_template_links_template_key ON public."blockTemplateLinks" USING btree ("templateKey");


--
-- Name: block_templates_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_templates_uid ON public."blockTemplates" USING btree (uid);


--
-- Name: collection_category_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_category_category_id ON public."collectionCategory" USING btree ("categoryId");


--
-- Name: custom_requests_roles_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX custom_requests_roles_role_name ON public."customRequestsRoles" USING btree ("roleName");


--
-- Name: data_sources_collections_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_collections_data_source_key ON public."dataSourcesCollections" USING btree ("dataSourceKey");


--
-- Name: data_sources_collections_name_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX data_sources_collections_name_data_source_key ON public."dataSourcesCollections" USING btree (name, "dataSourceKey");


--
-- Name: data_sources_fields_collection_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_fields_collection_key ON public."dataSourcesFields" USING btree ("collectionKey");


--
-- Name: data_sources_fields_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_fields_data_source_key ON public."dataSourcesFields" USING btree ("dataSourceKey");


--
-- Name: data_sources_fields_name_collection_name_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX data_sources_fields_name_collection_name_data_source_key ON public."dataSourcesFields" USING btree (name, "collectionName", "dataSourceKey");


--
-- Name: data_sources_roles_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_data_source_key ON public."dataSourcesRoles" USING btree ("dataSourceKey");


--
-- Name: data_sources_roles_resources_actions_roles_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_resources_actions_roles_resource_id ON public."dataSourcesRolesResourcesActions" USING btree ("rolesResourceId");


--
-- Name: data_sources_roles_resources_actions_scope_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_resources_actions_scope_id ON public."dataSourcesRolesResourcesActions" USING btree ("scopeId");


--
-- Name: data_sources_roles_resources_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_resources_data_source_key ON public."dataSourcesRolesResources" USING btree ("dataSourceKey");


--
-- Name: data_sources_roles_resources_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_resources_role_name ON public."dataSourcesRolesResources" USING btree ("roleName");


--
-- Name: data_sources_roles_resources_scopes_data_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_resources_scopes_data_source_key ON public."dataSourcesRolesResourcesScopes" USING btree ("dataSourceKey");


--
-- Name: data_sources_roles_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX data_sources_roles_role_name ON public."dataSourcesRoles" USING btree ("roleName");


--
-- Name: desktop_routes_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX desktop_routes_parent_id ON public."desktopRoutes" USING btree ("parentId");


--
-- Name: executions_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX executions_workflow_id ON public.executions USING btree ("workflowId");


--
-- Name: fields_collection_name_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX fields_collection_name_name ON public.fields USING btree ("collectionName", name);


--
-- Name: fields_parent_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fields_parent_key ON public.fields USING btree ("parentKey");


--
-- Name: fields_reverse_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fields_reverse_key ON public.fields USING btree ("reverseKey");


--
-- Name: flow_nodes_downstream_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flow_nodes_downstream_id ON public.flow_nodes USING btree ("downstreamId");


--
-- Name: flow_nodes_upstream_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flow_nodes_upstream_id ON public.flow_nodes USING btree ("upstreamId");


--
-- Name: flow_nodes_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flow_nodes_workflow_id ON public.flow_nodes USING btree ("workflowId");


--
-- Name: iframe_html_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX iframe_html_created_by_id ON public."iframeHtml" USING btree ("createdById");


--
-- Name: issued_tokens_jti; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX issued_tokens_jti ON public."issuedTokens" USING btree (jti);


--
-- Name: jobs_execution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_execution_id ON public.jobs USING btree ("executionId");


--
-- Name: jobs_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_node_id ON public.jobs USING btree ("nodeId");


--
-- Name: jobs_upstream_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_upstream_id ON public.jobs USING btree ("upstreamId");


--
-- Name: listing_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX listing_created_by_id ON public.listing USING btree ("createdById");


--
-- Name: listing_f_fg3scgfk7gp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX listing_f_fg3scgfk7gp ON public.listing USING btree (f_fg3scgfk7gp);


--
-- Name: listing_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX listing_updated_by_id ON public.listing USING btree ("updatedById");


--
-- Name: localization_texts_batch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX localization_texts_batch ON public."localizationTexts" USING btree (batch);


--
-- Name: localization_texts_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX localization_texts_created_by_id ON public."localizationTexts" USING btree ("createdById");


--
-- Name: localization_translations_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX localization_translations_created_by_id ON public."localizationTranslations" USING btree ("createdById");


--
-- Name: localization_translations_locale_text_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX localization_translations_locale_text_id ON public."localizationTranslations" USING btree (locale, "textId");


--
-- Name: localization_translations_text_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX localization_translations_text_id ON public."localizationTranslations" USING btree ("textId");


--
-- Name: main_desktop_routes_path_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX main_desktop_routes_path_path ON public."main_desktopRoutes_path" USING btree (path);


--
-- Name: main_mobile_routes_path_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX main_mobile_routes_path_path ON public."main_mobileRoutes_path" USING btree (path);


--
-- Name: mobile_routes_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mobile_routes_parent_id ON public."mobileRoutes" USING btree ("parentId");


--
-- Name: notification_channels_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_channels_created_by_id ON public."notificationChannels" USING btree ("createdById");


--
-- Name: notification_in_app_messages_channel_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_in_app_messages_channel_name ON public."notificationInAppMessages" USING btree ("channelName");


--
-- Name: otp_records_verifier_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX otp_records_verifier_name ON public."otpRecords" USING btree ("verifierName");


--
-- Name: products_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_created_by_id ON public.products USING btree ("createdById");


--
-- Name: products_f_zjav3kjr5jc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_f_zjav3kjr5jc ON public.products USING btree (f_zjav3kjr5jc);


--
-- Name: products_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_updated_by_id ON public.products USING btree ("updatedById");


--
-- Name: public_forms_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX public_forms_created_by_id ON public."publicForms" USING btree ("createdById");


--
-- Name: purchase_apply_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_apply_created_by_id ON public.purchase_apply USING btree ("createdById");


--
-- Name: purchase_apply_f_zlpp4ei8gnz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_apply_f_zlpp4ei8gnz ON public.purchase_apply USING btree (f_zlpp4ei8gnz);


--
-- Name: purchase_apply_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_apply_updated_by_id ON public.purchase_apply USING btree ("updatedById");


--
-- Name: roles_desktop_routes_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_desktop_routes_role_name ON public."rolesDesktopRoutes" USING btree ("roleName");


--
-- Name: roles_mobile_routes_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_mobile_routes_role_name ON public."rolesMobileRoutes" USING btree ("roleName");


--
-- Name: roles_resources_actions_roles_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_resources_actions_roles_resource_id ON public."rolesResourcesActions" USING btree ("rolesResourceId");


--
-- Name: roles_resources_actions_scope_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_resources_actions_scope_id ON public."rolesResourcesActions" USING btree ("scopeId");


--
-- Name: roles_resources_role_name_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX roles_resources_role_name_name ON public."rolesResources" USING btree ("roleName", name);


--
-- Name: roles_uischemas_ui_schema_x_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_uischemas_ui_schema_x_uid ON public."rolesUischemas" USING btree ("uiSchemaXUid");


--
-- Name: roles_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX roles_users_user_id ON public."rolesUsers" USING btree ("userId");


--
-- Name: supplies_info_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplies_info_created_by_id ON public.supplies_info USING btree ("createdById");


--
-- Name: supplies_info_f_mg0tjx73t8q; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplies_info_f_mg0tjx73t8q ON public.supplies_info USING btree (f_mg0tjx73t8q);


--
-- Name: supplies_info_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplies_info_updated_by_id ON public.supplies_info USING btree ("updatedById");


--
-- Name: system_settings_logo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX system_settings_logo_id ON public."systemSettings" USING btree ("logoId");


--
-- Name: t_59mpcgc2x1v_f_jvb88ftto9k; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX t_59mpcgc2x1v_f_jvb88ftto9k ON public.t_59mpcgc2x1v USING btree (f_jvb88ftto9k);


--
-- Name: t_apsa39qy9dl_f_mj1bglaapum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX t_apsa39qy9dl_f_mj1bglaapum ON public.t_apsa39qy9dl USING btree (f_mj1bglaapum);


--
-- Name: t_wa4fz03kwue_f_bu7g08i9bh9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX t_wa4fz03kwue_f_bu7g08i9bh9 ON public.t_wa4fz03kwue USING btree (f_bu7g08i9bh9);


--
-- Name: token_blacklist_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX token_blacklist_token ON public."tokenBlacklist" USING btree (token);


--
-- Name: token_control_config_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX token_control_config_created_by_id ON public."tokenControlConfig" USING btree ("createdById");


--
-- Name: ui_button_schemas_roles_role_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ui_button_schemas_roles_role_name ON public."uiButtonSchemasRoles" USING btree ("roleName");


--
-- Name: ui_button_schemas_roles_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ui_button_schemas_roles_uid ON public."uiButtonSchemasRoles" USING btree (uid);


--
-- Name: ui_schema_server_hooks_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ui_schema_server_hooks_uid ON public."uiSchemaServerHooks" USING btree (uid);


--
-- Name: ui_schema_templates_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ui_schema_templates_uid ON public."uiSchemaTemplates" USING btree (uid);


--
-- Name: ui_schema_tree_path_descendant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ui_schema_tree_path_descendant ON public."uiSchemaTreePath" USING btree (descendant);


--
-- Name: user_data_sync_records_resources_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_data_sync_records_resources_record_id ON public."userDataSyncRecordsResources" USING btree ("recordId");


--
-- Name: user_data_sync_sources_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_data_sync_sources_created_by_id ON public."userDataSyncSources" USING btree ("createdById");


--
-- Name: user_data_sync_tasks_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_data_sync_tasks_created_by_id ON public."userDataSyncTasks" USING btree ("createdById");


--
-- Name: user_data_sync_tasks_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_data_sync_tasks_source_id ON public."userDataSyncTasks" USING btree ("sourceId");


--
-- Name: user_workflow_tasks_user_id_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_workflow_tasks_user_id_type ON public."userWorkflowTasks" USING btree ("userId", type);


--
-- Name: users_authenticators_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_authenticators_created_by_id ON public."usersAuthenticators" USING btree ("createdById");


--
-- Name: users_authenticators_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_authenticators_updated_by_id ON public."usersAuthenticators" USING btree ("updatedById");


--
-- Name: users_authenticators_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_authenticators_user_id ON public."usersAuthenticators" USING btree ("userId");


--
-- Name: users_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_created_by_id ON public.users USING btree ("createdById");


--
-- Name: users_verificators_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verificators_created_by_id ON public."usersVerificators" USING btree ("createdById");


--
-- Name: users_verificators_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verificators_updated_by_id ON public."usersVerificators" USING btree ("updatedById");


--
-- Name: users_verificators_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verificators_user_id ON public."usersVerificators" USING btree ("userId");


--
-- Name: users_verifiers_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verifiers_created_by_id ON public."usersVerifiers" USING btree ("createdById");


--
-- Name: users_verifiers_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verifiers_updated_by_id ON public."usersVerifiers" USING btree ("updatedById");


--
-- Name: users_verifiers_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_verifiers_user_id ON public."usersVerifiers" USING btree ("userId");


--
-- Name: verifications_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX verifications_provider_id ON public.verifications USING btree ("providerId");


--
-- Name: workflow_category_relations_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_category_relations_category_id ON public."workflowCategoryRelations" USING btree ("categoryId");


--
-- Name: workflow_category_relations_workflow_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_category_relations_workflow_category_id ON public."workflowCategoryRelations" USING btree ("workflowCategoryId");


--
-- Name: workflow_manual_tasks_execution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_manual_tasks_execution_id ON public."workflowManualTasks" USING btree ("executionId");


--
-- Name: workflow_manual_tasks_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_manual_tasks_job_id ON public."workflowManualTasks" USING btree ("jobId");


--
-- Name: workflow_manual_tasks_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_manual_tasks_node_id ON public."workflowManualTasks" USING btree ("nodeId");


--
-- Name: workflow_manual_tasks_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_manual_tasks_user_id ON public."workflowManualTasks" USING btree ("userId");


--
-- Name: workflow_manual_tasks_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_manual_tasks_workflow_id ON public."workflowManualTasks" USING btree ("workflowId");


--
-- Name: workflow_tasks_type_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflow_tasks_type_key ON public."workflowTasks" USING btree (type, key);


--
-- Name: workflow_tasks_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_tasks_user_id ON public."workflowTasks" USING btree ("userId");


--
-- Name: workflow_tasks_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workflow_tasks_workflow_id ON public."workflowTasks" USING btree ("workflowId");


--
-- Name: workflows_key_current; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_key_current ON public.workflows USING btree (key, current);


--
-- PostgreSQL database dump complete
--

