--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Debian 12.5-1.pgdg100+1)
-- Dumped by pg_dump version 12.5 (Debian 12.5-1.pgdg100+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_default_roles; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_default_roles (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_default_roles OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_default_roles; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_roles (
    realm_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_roles OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
f36e671a-9914-4a4b-8c0a-cf727e1d88a9	\N	auth-cookie	master	5278d875-8e3c-447c-a800-92c69a39861c	2	10	f	\N	\N
f84d7010-f71b-4a04-afa0-80945fc68c34	\N	auth-spnego	master	5278d875-8e3c-447c-a800-92c69a39861c	3	20	f	\N	\N
841dda9c-3d79-41a6-bf20-f9fde13145a2	\N	identity-provider-redirector	master	5278d875-8e3c-447c-a800-92c69a39861c	2	25	f	\N	\N
44096c60-c938-4b5a-baee-63b7e66db504	\N	\N	master	5278d875-8e3c-447c-a800-92c69a39861c	2	30	t	13a27486-4de0-4f96-8394-01e714f356ca	\N
787d6786-9af8-4e26-948b-9829410c9669	\N	auth-username-password-form	master	13a27486-4de0-4f96-8394-01e714f356ca	0	10	f	\N	\N
5713102a-b0d0-4397-b7e1-d6c941ea297f	\N	\N	master	13a27486-4de0-4f96-8394-01e714f356ca	1	20	t	9dd14374-92f1-405f-98b8-93d7a6e7eab2	\N
6031a2bd-102b-4930-913d-263ecc9cf763	\N	conditional-user-configured	master	9dd14374-92f1-405f-98b8-93d7a6e7eab2	0	10	f	\N	\N
2757e866-2f08-4dfd-ad5d-93a9b8bbe383	\N	auth-otp-form	master	9dd14374-92f1-405f-98b8-93d7a6e7eab2	0	20	f	\N	\N
20051199-442d-4ef1-8859-ee3484be3cf4	\N	direct-grant-validate-username	master	6df06a3e-5f9a-4d10-b448-bafc931f51bb	0	10	f	\N	\N
cb8cbe0b-7241-4e9a-8be0-f2aadad8d538	\N	direct-grant-validate-password	master	6df06a3e-5f9a-4d10-b448-bafc931f51bb	0	20	f	\N	\N
1a3e79e4-14e1-4286-b24a-d3703394ebbd	\N	\N	master	6df06a3e-5f9a-4d10-b448-bafc931f51bb	1	30	t	f7c722b0-a645-4ed9-a279-4f150a8a431f	\N
cad69e1c-a5fa-49e0-b4ce-004d401aa80c	\N	conditional-user-configured	master	f7c722b0-a645-4ed9-a279-4f150a8a431f	0	10	f	\N	\N
515c9918-99e5-408b-8bad-2011b40fd489	\N	direct-grant-validate-otp	master	f7c722b0-a645-4ed9-a279-4f150a8a431f	0	20	f	\N	\N
556cd39a-622b-47fc-967b-b0cbc7953f29	\N	registration-page-form	master	3e1d180f-9048-4739-beaa-568d671150ae	0	10	t	01d5c92e-968b-46ff-a344-5bdc1bd94c33	\N
44d505df-9339-40da-8b8b-daaaa73a2d39	\N	registration-user-creation	master	01d5c92e-968b-46ff-a344-5bdc1bd94c33	0	20	f	\N	\N
27d19459-342f-4066-a4e4-b7221bc22319	\N	registration-profile-action	master	01d5c92e-968b-46ff-a344-5bdc1bd94c33	0	40	f	\N	\N
b90dd078-28f9-4571-a52a-6d29492c8171	\N	registration-password-action	master	01d5c92e-968b-46ff-a344-5bdc1bd94c33	0	50	f	\N	\N
e7e34129-2dac-4473-b2a4-681bbcaa4514	\N	registration-recaptcha-action	master	01d5c92e-968b-46ff-a344-5bdc1bd94c33	3	60	f	\N	\N
0bc3f84e-5d90-42a4-b49f-ae85bb0f6111	\N	reset-credentials-choose-user	master	fa44e055-256b-49e4-806d-71d73ae7cb70	0	10	f	\N	\N
dcb81771-1314-4bd1-9170-7173db94f301	\N	reset-credential-email	master	fa44e055-256b-49e4-806d-71d73ae7cb70	0	20	f	\N	\N
a3f41b58-6843-4a94-b280-3c565d18de1d	\N	reset-password	master	fa44e055-256b-49e4-806d-71d73ae7cb70	0	30	f	\N	\N
28167dce-fb3b-4ef0-a751-8064daa24950	\N	\N	master	fa44e055-256b-49e4-806d-71d73ae7cb70	1	40	t	08aa7692-ed5d-4835-b26d-30d972a7beb7	\N
d3d582a6-b686-4f33-816a-8951a89f4da6	\N	conditional-user-configured	master	08aa7692-ed5d-4835-b26d-30d972a7beb7	0	10	f	\N	\N
e2fd3f6d-ac07-4c11-9584-f34f43b4a70e	\N	reset-otp	master	08aa7692-ed5d-4835-b26d-30d972a7beb7	0	20	f	\N	\N
2761d7e5-3677-4be1-bf05-ed59dd187f0c	\N	client-secret	master	a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	2	10	f	\N	\N
e22e9758-4997-465a-a525-d2c6bace810a	\N	client-jwt	master	a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	2	20	f	\N	\N
61c4e7ae-fb01-4ed1-9fa1-8f2d02121c06	\N	client-secret-jwt	master	a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	2	30	f	\N	\N
415977fd-ec03-4fa7-9fb4-1b56a41ff974	\N	client-x509	master	a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	2	40	f	\N	\N
94f64c3c-99d3-4c75-b4ff-90950b7de4c7	\N	idp-review-profile	master	3ef86c7f-ba2f-4258-bdf9-a9b95c9a7300	0	10	f	\N	665e67d1-f2fe-4f99-9906-4a0c4986db30
d5b405ae-4b7a-4542-9fcc-f935e9c1521a	\N	\N	master	3ef86c7f-ba2f-4258-bdf9-a9b95c9a7300	0	20	t	343d6738-a4e5-4579-814c-e365b97e1b88	\N
e648c74c-259f-47e3-b830-d0454cc4ca7c	\N	idp-create-user-if-unique	master	343d6738-a4e5-4579-814c-e365b97e1b88	2	10	f	\N	53439137-a06a-452d-a272-fac38acfabf2
3421cc51-51e7-441c-ba2a-b6429822ff8f	\N	\N	master	343d6738-a4e5-4579-814c-e365b97e1b88	2	20	t	3e4e78d9-1d54-4fb9-b9d2-2cfbda0eb578	\N
fc472061-f27e-4295-85bc-93aaf3a8ca1a	\N	idp-confirm-link	master	3e4e78d9-1d54-4fb9-b9d2-2cfbda0eb578	0	10	f	\N	\N
1e6eebe9-994b-4633-a249-4d5702c5f1a7	\N	\N	master	3e4e78d9-1d54-4fb9-b9d2-2cfbda0eb578	0	20	t	0167bb6c-7301-4e74-b961-56ce7d0215b5	\N
ecb7375d-41fc-4c7e-a405-7b36bb3215b3	\N	idp-email-verification	master	0167bb6c-7301-4e74-b961-56ce7d0215b5	2	10	f	\N	\N
faacfd81-e0e8-494f-8943-973de35a0f02	\N	\N	master	0167bb6c-7301-4e74-b961-56ce7d0215b5	2	20	t	4bf5b6f7-0265-4594-95a6-9f080c44e5a0	\N
541080c9-7254-45b6-be55-95b70e2ed0d5	\N	idp-username-password-form	master	4bf5b6f7-0265-4594-95a6-9f080c44e5a0	0	10	f	\N	\N
dbc7778f-67bd-43cd-8f3b-0652f5c3d074	\N	\N	master	4bf5b6f7-0265-4594-95a6-9f080c44e5a0	1	20	t	e20717b8-3858-4e48-ac64-4bb46d4e56c0	\N
b60e36c6-89f8-4d5f-b510-0735b2991a35	\N	conditional-user-configured	master	e20717b8-3858-4e48-ac64-4bb46d4e56c0	0	10	f	\N	\N
1aaa1955-720c-44a1-acaa-3a16ca7865f2	\N	auth-otp-form	master	e20717b8-3858-4e48-ac64-4bb46d4e56c0	0	20	f	\N	\N
8796d5a5-8b05-4c44-a826-a91cbb353272	\N	http-basic-authenticator	master	4d67282d-54b3-40b2-8fa7-45f5e6d5888b	0	10	f	\N	\N
39e793de-ff71-4884-a95c-37150feb9fb4	\N	docker-http-basic-authenticator	master	9a68e0de-1e15-4357-a9e0-927b14b815d5	0	10	f	\N	\N
b9a1d741-5f58-46cd-83f5-6a6ab730415e	\N	no-cookie-redirect	master	bf576d0c-1317-4314-a75f-18e372147b95	0	10	f	\N	\N
f27255d7-1c68-42ea-8c17-6d482ff07241	\N	\N	master	bf576d0c-1317-4314-a75f-18e372147b95	0	20	t	00b99cd3-e917-4058-a213-4eb12c5fee4e	\N
c8fb97d0-8254-4cb6-8f81-3ce4bee7c11f	\N	basic-auth	master	00b99cd3-e917-4058-a213-4eb12c5fee4e	0	10	f	\N	\N
cccc51e9-885b-4c13-aae1-6e08257fabfe	\N	basic-auth-otp	master	00b99cd3-e917-4058-a213-4eb12c5fee4e	3	20	f	\N	\N
be66c0e5-f7b9-4329-90db-3a77cb8a94b8	\N	auth-spnego	master	00b99cd3-e917-4058-a213-4eb12c5fee4e	3	30	f	\N	\N
f7cfce70-71e6-40e0-9e99-402b23c684f1	\N	auth-cookie	myrealm	98396637-b99d-4601-bf27-3b706452acca	2	10	f	\N	\N
b0fabcfa-e8ff-4f3a-866d-4f7c5ad4bd30	\N	auth-spnego	myrealm	98396637-b99d-4601-bf27-3b706452acca	3	20	f	\N	\N
d366daac-cb29-4278-b735-733d82ceff09	\N	identity-provider-redirector	myrealm	98396637-b99d-4601-bf27-3b706452acca	2	25	f	\N	\N
a3091862-5afc-4201-a787-dc17d72577cf	\N	\N	myrealm	98396637-b99d-4601-bf27-3b706452acca	2	30	t	ea6c5376-feb8-465b-b639-8da9b7462e2d	\N
48c0536d-a419-407d-8878-e187f07c782d	\N	auth-username-password-form	myrealm	ea6c5376-feb8-465b-b639-8da9b7462e2d	0	10	f	\N	\N
f4deb6df-4c9e-47bc-9f4d-2155d67f4169	\N	\N	myrealm	ea6c5376-feb8-465b-b639-8da9b7462e2d	1	20	t	401b1c68-9d0a-40a1-a9af-4d9160c12a31	\N
4261f8a7-a2c1-47aa-a73e-35351050f29d	\N	conditional-user-configured	myrealm	401b1c68-9d0a-40a1-a9af-4d9160c12a31	0	10	f	\N	\N
3d2bf480-0559-4fc3-9902-6b0fa61ea621	\N	auth-otp-form	myrealm	401b1c68-9d0a-40a1-a9af-4d9160c12a31	0	20	f	\N	\N
d80d659f-693d-4694-9d5d-21c12295e6c5	\N	direct-grant-validate-username	myrealm	95d4f575-5779-48b1-a606-87cb07f8bede	0	10	f	\N	\N
b470849c-b4f7-4033-ae59-032655209067	\N	direct-grant-validate-password	myrealm	95d4f575-5779-48b1-a606-87cb07f8bede	0	20	f	\N	\N
bfea74c5-14f2-45a9-835e-8c370d012e6a	\N	\N	myrealm	95d4f575-5779-48b1-a606-87cb07f8bede	1	30	t	a34f885d-5cc2-406a-82b8-ceab95140ead	\N
7f2990c4-9343-4a02-99b5-1103526e0c55	\N	conditional-user-configured	myrealm	a34f885d-5cc2-406a-82b8-ceab95140ead	0	10	f	\N	\N
74b32a75-f63d-48bd-a54e-2804ff61235a	\N	direct-grant-validate-otp	myrealm	a34f885d-5cc2-406a-82b8-ceab95140ead	0	20	f	\N	\N
1117f354-1d40-48cf-b440-dda1f2a4c6dd	\N	registration-page-form	myrealm	7e7e1f2d-46f6-4ebb-b426-1fc3fcb62b5e	0	10	t	43a3bcf1-5a17-47fa-8223-4f32660a1515	\N
8810c95a-0c80-47b5-b8bf-7e4964378d7a	\N	registration-user-creation	myrealm	43a3bcf1-5a17-47fa-8223-4f32660a1515	0	20	f	\N	\N
977b5c7f-48c1-4158-af2f-b44f7a722728	\N	registration-profile-action	myrealm	43a3bcf1-5a17-47fa-8223-4f32660a1515	0	40	f	\N	\N
d3b42666-b67f-406d-9c95-2d6dbdb99e6c	\N	registration-password-action	myrealm	43a3bcf1-5a17-47fa-8223-4f32660a1515	0	50	f	\N	\N
c73b8e3a-12f0-4c9e-8556-0d3864e8b002	\N	registration-recaptcha-action	myrealm	43a3bcf1-5a17-47fa-8223-4f32660a1515	3	60	f	\N	\N
2a0b93b2-1b49-4e17-928b-f7f275ce498c	\N	reset-credentials-choose-user	myrealm	680de399-b46b-47f0-9a0f-2237c3d3a8c0	0	10	f	\N	\N
7edd1719-a209-4839-88f1-b5c0fda81764	\N	reset-credential-email	myrealm	680de399-b46b-47f0-9a0f-2237c3d3a8c0	0	20	f	\N	\N
fb4aa92f-a05b-40e2-8d4f-f1cf7f801808	\N	reset-password	myrealm	680de399-b46b-47f0-9a0f-2237c3d3a8c0	0	30	f	\N	\N
1645ad3f-d0c1-4c12-ada9-0e1a87bd685a	\N	\N	myrealm	680de399-b46b-47f0-9a0f-2237c3d3a8c0	1	40	t	69a8cd71-71e5-4540-9bce-9eb860071479	\N
bec2428d-7063-4f6f-90dd-e74257094e6f	\N	conditional-user-configured	myrealm	69a8cd71-71e5-4540-9bce-9eb860071479	0	10	f	\N	\N
18e6faca-bb28-4467-80d4-b3e8edf927a5	\N	reset-otp	myrealm	69a8cd71-71e5-4540-9bce-9eb860071479	0	20	f	\N	\N
77de1865-0511-4f79-88a3-cc959302b616	\N	client-secret	myrealm	d96d0ad2-d2c8-4798-a41e-2940437e2193	2	10	f	\N	\N
b9a25f6b-6f00-4e6f-acc2-4da6fa56baae	\N	client-jwt	myrealm	d96d0ad2-d2c8-4798-a41e-2940437e2193	2	20	f	\N	\N
b066c441-d897-434e-8e39-ff9fe5744de6	\N	client-secret-jwt	myrealm	d96d0ad2-d2c8-4798-a41e-2940437e2193	2	30	f	\N	\N
327cf47d-f014-46fa-bf19-e908c2ec29fc	\N	client-x509	myrealm	d96d0ad2-d2c8-4798-a41e-2940437e2193	2	40	f	\N	\N
220c2eb8-0ae8-429f-ad59-513a6554c509	\N	idp-review-profile	myrealm	7d90b471-7346-42e2-8b76-ba3f190d15ab	0	10	f	\N	5fbe272a-8122-4f85-b428-615eebb85c4c
b2bdaa59-08a7-47fd-9419-e3df11ee8bdb	\N	\N	myrealm	7d90b471-7346-42e2-8b76-ba3f190d15ab	0	20	t	7bcb6a41-78ca-4e80-84c7-adb104971822	\N
92a1b568-2002-4464-8411-b84d944edc78	\N	idp-create-user-if-unique	myrealm	7bcb6a41-78ca-4e80-84c7-adb104971822	2	10	f	\N	58db76f2-5da9-411e-b0ab-a7bdd3b5c2e0
6f523553-d7e9-4858-aa44-4714dbfaabe6	\N	\N	myrealm	7bcb6a41-78ca-4e80-84c7-adb104971822	2	20	t	9c337aaa-6359-4c1f-9165-c6038bc3df10	\N
c0c3cc36-f8d4-4b07-a646-50450289ac4b	\N	idp-confirm-link	myrealm	9c337aaa-6359-4c1f-9165-c6038bc3df10	0	10	f	\N	\N
d9b4d70e-9ba8-4908-af5a-aa594c3c5a4a	\N	\N	myrealm	9c337aaa-6359-4c1f-9165-c6038bc3df10	0	20	t	2e7f13a9-f3fc-4cd6-8843-43821e964075	\N
e6a2ca5c-1ebe-47c4-95e9-0a7512af7b6d	\N	idp-email-verification	myrealm	2e7f13a9-f3fc-4cd6-8843-43821e964075	2	10	f	\N	\N
8f50a511-c7b1-47e3-ae81-a189527d9ac3	\N	\N	myrealm	2e7f13a9-f3fc-4cd6-8843-43821e964075	2	20	t	44dad11d-0404-46bb-9d96-83dcb614b1cf	\N
2f62a0ec-65a7-49ae-87eb-087ffef153b4	\N	idp-username-password-form	myrealm	44dad11d-0404-46bb-9d96-83dcb614b1cf	0	10	f	\N	\N
00172815-a340-4845-b8d6-ec4e9861e93a	\N	\N	myrealm	44dad11d-0404-46bb-9d96-83dcb614b1cf	1	20	t	091f8bdb-8eba-4e9b-99ca-fe473d6bd30a	\N
177c9771-c64a-4076-b4e2-55e651ae7ce4	\N	conditional-user-configured	myrealm	091f8bdb-8eba-4e9b-99ca-fe473d6bd30a	0	10	f	\N	\N
7a8add39-325f-4a5f-9b4c-541267bc0826	\N	auth-otp-form	myrealm	091f8bdb-8eba-4e9b-99ca-fe473d6bd30a	0	20	f	\N	\N
c3fe68d6-4c9a-438e-80d0-c25147402bf9	\N	http-basic-authenticator	myrealm	b56e44c6-32ef-4505-86f1-72a092a14881	0	10	f	\N	\N
8c4893ea-89ec-4107-816f-d7bcd384dbbe	\N	docker-http-basic-authenticator	myrealm	62e63545-8eea-4ae7-af31-22eb8ba911a9	0	10	f	\N	\N
bb861aa9-d1db-47c1-ae8a-8dfdc7c93737	\N	no-cookie-redirect	myrealm	fb15a66e-93b0-4126-8ba0-6c2c0b3853fc	0	10	f	\N	\N
c8be7cb2-c3f5-4130-9c55-92a4fd12d8b0	\N	\N	myrealm	fb15a66e-93b0-4126-8ba0-6c2c0b3853fc	0	20	t	bf8c9720-1129-4fe4-8113-0fcc23864134	\N
91a9f524-eb76-47af-816a-2d2031e65cec	\N	basic-auth	myrealm	bf8c9720-1129-4fe4-8113-0fcc23864134	0	10	f	\N	\N
6ad238e3-68c2-4384-9a15-89030066574f	\N	basic-auth-otp	myrealm	bf8c9720-1129-4fe4-8113-0fcc23864134	3	20	f	\N	\N
15856e4e-4a78-48bf-b9c3-6ff4b20d8be6	\N	auth-spnego	myrealm	bf8c9720-1129-4fe4-8113-0fcc23864134	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
5278d875-8e3c-447c-a800-92c69a39861c	browser	browser based authentication	master	basic-flow	t	t
13a27486-4de0-4f96-8394-01e714f356ca	forms	Username, password, otp and other auth forms.	master	basic-flow	f	t
9dd14374-92f1-405f-98b8-93d7a6e7eab2	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
6df06a3e-5f9a-4d10-b448-bafc931f51bb	direct grant	OpenID Connect Resource Owner Grant	master	basic-flow	t	t
f7c722b0-a645-4ed9-a279-4f150a8a431f	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
3e1d180f-9048-4739-beaa-568d671150ae	registration	registration flow	master	basic-flow	t	t
01d5c92e-968b-46ff-a344-5bdc1bd94c33	registration form	registration form	master	form-flow	f	t
fa44e055-256b-49e4-806d-71d73ae7cb70	reset credentials	Reset credentials for a user if they forgot their password or something	master	basic-flow	t	t
08aa7692-ed5d-4835-b26d-30d972a7beb7	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	master	basic-flow	f	t
a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	clients	Base authentication for clients	master	client-flow	t	t
3ef86c7f-ba2f-4258-bdf9-a9b95c9a7300	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	master	basic-flow	t	t
343d6738-a4e5-4579-814c-e365b97e1b88	User creation or linking	Flow for the existing/non-existing user alternatives	master	basic-flow	f	t
3e4e78d9-1d54-4fb9-b9d2-2cfbda0eb578	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	master	basic-flow	f	t
0167bb6c-7301-4e74-b961-56ce7d0215b5	Account verification options	Method with which to verity the existing account	master	basic-flow	f	t
4bf5b6f7-0265-4594-95a6-9f080c44e5a0	Verify Existing Account by Re-authentication	Reauthentication of existing account	master	basic-flow	f	t
e20717b8-3858-4e48-ac64-4bb46d4e56c0	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
4d67282d-54b3-40b2-8fa7-45f5e6d5888b	saml ecp	SAML ECP Profile Authentication Flow	master	basic-flow	t	t
9a68e0de-1e15-4357-a9e0-927b14b815d5	docker auth	Used by Docker clients to authenticate against the IDP	master	basic-flow	t	t
bf576d0c-1317-4314-a75f-18e372147b95	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	master	basic-flow	t	t
00b99cd3-e917-4058-a213-4eb12c5fee4e	Authentication Options	Authentication options.	master	basic-flow	f	t
98396637-b99d-4601-bf27-3b706452acca	browser	browser based authentication	myrealm	basic-flow	t	t
ea6c5376-feb8-465b-b639-8da9b7462e2d	forms	Username, password, otp and other auth forms.	myrealm	basic-flow	f	t
401b1c68-9d0a-40a1-a9af-4d9160c12a31	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	myrealm	basic-flow	f	t
95d4f575-5779-48b1-a606-87cb07f8bede	direct grant	OpenID Connect Resource Owner Grant	myrealm	basic-flow	t	t
a34f885d-5cc2-406a-82b8-ceab95140ead	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	myrealm	basic-flow	f	t
7e7e1f2d-46f6-4ebb-b426-1fc3fcb62b5e	registration	registration flow	myrealm	basic-flow	t	t
43a3bcf1-5a17-47fa-8223-4f32660a1515	registration form	registration form	myrealm	form-flow	f	t
680de399-b46b-47f0-9a0f-2237c3d3a8c0	reset credentials	Reset credentials for a user if they forgot their password or something	myrealm	basic-flow	t	t
69a8cd71-71e5-4540-9bce-9eb860071479	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	myrealm	basic-flow	f	t
d96d0ad2-d2c8-4798-a41e-2940437e2193	clients	Base authentication for clients	myrealm	client-flow	t	t
7d90b471-7346-42e2-8b76-ba3f190d15ab	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	myrealm	basic-flow	t	t
7bcb6a41-78ca-4e80-84c7-adb104971822	User creation or linking	Flow for the existing/non-existing user alternatives	myrealm	basic-flow	f	t
9c337aaa-6359-4c1f-9165-c6038bc3df10	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	myrealm	basic-flow	f	t
2e7f13a9-f3fc-4cd6-8843-43821e964075	Account verification options	Method with which to verity the existing account	myrealm	basic-flow	f	t
44dad11d-0404-46bb-9d96-83dcb614b1cf	Verify Existing Account by Re-authentication	Reauthentication of existing account	myrealm	basic-flow	f	t
091f8bdb-8eba-4e9b-99ca-fe473d6bd30a	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	myrealm	basic-flow	f	t
b56e44c6-32ef-4505-86f1-72a092a14881	saml ecp	SAML ECP Profile Authentication Flow	myrealm	basic-flow	t	t
62e63545-8eea-4ae7-af31-22eb8ba911a9	docker auth	Used by Docker clients to authenticate against the IDP	myrealm	basic-flow	t	t
fb15a66e-93b0-4126-8ba0-6c2c0b3853fc	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	myrealm	basic-flow	t	t
bf8c9720-1129-4fe4-8113-0fcc23864134	Authentication Options	Authentication options.	myrealm	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
665e67d1-f2fe-4f99-9906-4a0c4986db30	review profile config	master
53439137-a06a-452d-a272-fac38acfabf2	create unique user config	master
5fbe272a-8122-4f85-b428-615eebb85c4c	review profile config	myrealm
58db76f2-5da9-411e-b0ab-a7bdd3b5c2e0	create unique user config	myrealm
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
665e67d1-f2fe-4f99-9906-4a0c4986db30	missing	update.profile.on.first.login
53439137-a06a-452d-a272-fac38acfabf2	false	require.password.update.after.registration
5fbe272a-8122-4f85-b428-615eebb85c4c	missing	update.profile.on.first.login
58db76f2-5da9-411e-b0ab-a7bdd3b5c2e0	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
2f201371-1f6c-4771-bbad-6f14baebcd30	t	t	master-realm	0	f	2ecf58f8-6335-4f30-a8bf-84eb05b124a9	\N	t	\N	f	master	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	f	account	0	f	1b34fbb4-3fab-4dfc-ab25-3509014da4f0	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
039edccc-f22b-4c35-afa7-06aa26f6d1b6	t	f	account-console	0	t	4f0e8e0d-a6fe-46c3-b035-56af3470233b	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	t	f	broker	0	f	d4b328d6-2241-4c14-8c3d-4331583bc9f3	\N	f	\N	f	master	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
1d762543-1e89-4e78-af2e-02c1e56b0ba0	t	f	security-admin-console	0	t	54086cca-c1b0-4003-8d81-fe866a535a93	/admin/master/console/	f	\N	f	master	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
333fcd28-a18c-4386-b79f-216adeb9cf95	t	f	admin-cli	0	t	c0e79f4f-0a5e-44dc-8a60-f8226fad75f3	\N	f	\N	f	master	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	t	myrealm-realm	0	f	d26b457b-b783-42e9-9c62-24e635bfa932	\N	t	\N	f	master	\N	0	f	f	myrealm Realm	f	client-secret	\N	\N	\N	t	f	f	f
a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	f	realm-management	0	f	27e10619-bfdb-49f4-9862-ff8c03bcc61b	\N	t	\N	f	myrealm	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
723b4775-6ec2-44ff-9adf-01102831b159	t	f	account	0	f	d24e5666-9b4c-40f9-b93b-17ea5eca1a41	/realms/myrealm/account/	f	\N	f	myrealm	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	t	f	account-console	0	t	d1ab16ba-1dc8-4963-9606-ab128211bdcd	/realms/myrealm/account/	f	\N	f	myrealm	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
3e44a660-3d19-4571-8887-c5df27db78ba	t	f	broker	0	f	6fb43406-b8d3-4034-ac72-61bc9e15e5e5	\N	f	\N	f	myrealm	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
324dcc7d-4bef-4361-abbd-eb0dda84aed6	t	f	security-admin-console	0	t	a40b63ae-e2d7-4681-a99e-86d1f42eb374	/admin/myrealm/console/	f	\N	f	myrealm	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
d84211f7-5b12-4df5-929f-ed9944e2091b	t	f	admin-cli	0	t	600b0b23-d221-4520-9616-9c2bd3ce4c02	\N	f	\N	f	myrealm	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
76f65bf9-3b38-4021-bd64-8119d10e1b8e	t	t	webapp	0	t	73609754-1fb8-4d07-9662-1f04fafc49f5	\N	f	http://localhost:3000/	f	myrealm	openid-connect	-1	f	f	\N	f	client-secret	http://localhost:3000/	\N	\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
039edccc-f22b-4c35-afa7-06aa26f6d1b6	S256	pkce.code.challenge.method
1d762543-1e89-4e78-af2e-02c1e56b0ba0	S256	pkce.code.challenge.method
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	S256	pkce.code.challenge.method
324dcc7d-4bef-4361-abbd-eb0dda84aed6	S256	pkce.code.challenge.method
76f65bf9-3b38-4021-bd64-8119d10e1b8e	true	backchannel.logout.session.required
76f65bf9-3b38-4021-bd64-8119d10e1b8e	false	backchannel.logout.revoke.offline.tokens
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_default_roles; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_default_roles (client_id, role_id) FROM stdin;
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	09be7933-8986-4f12-a6e9-9a53ae4e8d6c
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	553c721f-6964-47fd-ae7e-fbb44b655c19
723b4775-6ec2-44ff-9adf-01102831b159	147c0888-de85-44f6-9612-76432590202f
723b4775-6ec2-44ff-9adf-01102831b159	a854fd93-763d-440f-8bc5-cda240a787d9
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
f1718f41-d77f-4fea-a7de-2894d410fc4b	offline_access	master	OpenID Connect built-in scope: offline_access	openid-connect
7b31029f-ebf4-411f-b95a-2d7cd623af10	role_list	master	SAML role list	saml
8f3b7070-77de-435f-b22f-c63336a78288	profile	master	OpenID Connect built-in scope: profile	openid-connect
783af926-7768-4e30-9318-944d7d91b3c1	email	master	OpenID Connect built-in scope: email	openid-connect
8367c2a1-34de-4136-9494-44766510b6e2	address	master	OpenID Connect built-in scope: address	openid-connect
3a5a922c-30bb-4307-af28-4c3b946a9aa3	phone	master	OpenID Connect built-in scope: phone	openid-connect
cb76699f-3016-49a6-98a3-965bcfb2ab4c	roles	master	OpenID Connect scope for add user roles to the access token	openid-connect
e457070d-299a-426b-b12b-e6c59ca987c4	web-origins	master	OpenID Connect scope for add allowed web origins to the access token	openid-connect
bc587d26-8368-4e0c-995d-d55570b1db85	microprofile-jwt	master	Microprofile - JWT built-in scope	openid-connect
b895192c-855c-4f46-9a58-ff414aec081d	offline_access	myrealm	OpenID Connect built-in scope: offline_access	openid-connect
4f8788a5-161c-43b7-b874-f93066cd7b06	role_list	myrealm	SAML role list	saml
2a84a550-2741-4334-b5f6-e207ce547e19	profile	myrealm	OpenID Connect built-in scope: profile	openid-connect
a9a31276-2278-4642-a35c-768c9e8c4658	email	myrealm	OpenID Connect built-in scope: email	openid-connect
0a96c09f-a5bf-4951-88b0-1398a64b014d	address	myrealm	OpenID Connect built-in scope: address	openid-connect
e8e55942-e9cc-4649-8a26-ecd1baddfb92	phone	myrealm	OpenID Connect built-in scope: phone	openid-connect
62dab34d-f7c3-4609-81e8-468cb22cb7ed	roles	myrealm	OpenID Connect scope for add user roles to the access token	openid-connect
c75c2eba-8a83-4868-89b8-b75cf8f3442d	web-origins	myrealm	OpenID Connect scope for add allowed web origins to the access token	openid-connect
829e508d-b8ed-4e41-8f27-2b4cfb8fa631	microprofile-jwt	myrealm	Microprofile - JWT built-in scope	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
f1718f41-d77f-4fea-a7de-2894d410fc4b	true	display.on.consent.screen
f1718f41-d77f-4fea-a7de-2894d410fc4b	${offlineAccessScopeConsentText}	consent.screen.text
7b31029f-ebf4-411f-b95a-2d7cd623af10	true	display.on.consent.screen
7b31029f-ebf4-411f-b95a-2d7cd623af10	${samlRoleListScopeConsentText}	consent.screen.text
8f3b7070-77de-435f-b22f-c63336a78288	true	display.on.consent.screen
8f3b7070-77de-435f-b22f-c63336a78288	${profileScopeConsentText}	consent.screen.text
8f3b7070-77de-435f-b22f-c63336a78288	true	include.in.token.scope
783af926-7768-4e30-9318-944d7d91b3c1	true	display.on.consent.screen
783af926-7768-4e30-9318-944d7d91b3c1	${emailScopeConsentText}	consent.screen.text
783af926-7768-4e30-9318-944d7d91b3c1	true	include.in.token.scope
8367c2a1-34de-4136-9494-44766510b6e2	true	display.on.consent.screen
8367c2a1-34de-4136-9494-44766510b6e2	${addressScopeConsentText}	consent.screen.text
8367c2a1-34de-4136-9494-44766510b6e2	true	include.in.token.scope
3a5a922c-30bb-4307-af28-4c3b946a9aa3	true	display.on.consent.screen
3a5a922c-30bb-4307-af28-4c3b946a9aa3	${phoneScopeConsentText}	consent.screen.text
3a5a922c-30bb-4307-af28-4c3b946a9aa3	true	include.in.token.scope
cb76699f-3016-49a6-98a3-965bcfb2ab4c	true	display.on.consent.screen
cb76699f-3016-49a6-98a3-965bcfb2ab4c	${rolesScopeConsentText}	consent.screen.text
cb76699f-3016-49a6-98a3-965bcfb2ab4c	false	include.in.token.scope
e457070d-299a-426b-b12b-e6c59ca987c4	false	display.on.consent.screen
e457070d-299a-426b-b12b-e6c59ca987c4		consent.screen.text
e457070d-299a-426b-b12b-e6c59ca987c4	false	include.in.token.scope
bc587d26-8368-4e0c-995d-d55570b1db85	false	display.on.consent.screen
bc587d26-8368-4e0c-995d-d55570b1db85	true	include.in.token.scope
b895192c-855c-4f46-9a58-ff414aec081d	true	display.on.consent.screen
b895192c-855c-4f46-9a58-ff414aec081d	${offlineAccessScopeConsentText}	consent.screen.text
4f8788a5-161c-43b7-b874-f93066cd7b06	true	display.on.consent.screen
4f8788a5-161c-43b7-b874-f93066cd7b06	${samlRoleListScopeConsentText}	consent.screen.text
2a84a550-2741-4334-b5f6-e207ce547e19	true	display.on.consent.screen
2a84a550-2741-4334-b5f6-e207ce547e19	${profileScopeConsentText}	consent.screen.text
2a84a550-2741-4334-b5f6-e207ce547e19	true	include.in.token.scope
a9a31276-2278-4642-a35c-768c9e8c4658	true	display.on.consent.screen
a9a31276-2278-4642-a35c-768c9e8c4658	${emailScopeConsentText}	consent.screen.text
a9a31276-2278-4642-a35c-768c9e8c4658	true	include.in.token.scope
0a96c09f-a5bf-4951-88b0-1398a64b014d	true	display.on.consent.screen
0a96c09f-a5bf-4951-88b0-1398a64b014d	${addressScopeConsentText}	consent.screen.text
0a96c09f-a5bf-4951-88b0-1398a64b014d	true	include.in.token.scope
e8e55942-e9cc-4649-8a26-ecd1baddfb92	true	display.on.consent.screen
e8e55942-e9cc-4649-8a26-ecd1baddfb92	${phoneScopeConsentText}	consent.screen.text
e8e55942-e9cc-4649-8a26-ecd1baddfb92	true	include.in.token.scope
62dab34d-f7c3-4609-81e8-468cb22cb7ed	true	display.on.consent.screen
62dab34d-f7c3-4609-81e8-468cb22cb7ed	${rolesScopeConsentText}	consent.screen.text
62dab34d-f7c3-4609-81e8-468cb22cb7ed	false	include.in.token.scope
c75c2eba-8a83-4868-89b8-b75cf8f3442d	false	display.on.consent.screen
c75c2eba-8a83-4868-89b8-b75cf8f3442d		consent.screen.text
c75c2eba-8a83-4868-89b8-b75cf8f3442d	false	include.in.token.scope
829e508d-b8ed-4e41-8f27-2b4cfb8fa631	false	display.on.consent.screen
829e508d-b8ed-4e41-8f27-2b4cfb8fa631	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
039edccc-f22b-4c35-afa7-06aa26f6d1b6	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
333fcd28-a18c-4386-b79f-216adeb9cf95	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
2f201371-1f6c-4771-bbad-6f14baebcd30	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
1d762543-1e89-4e78-af2e-02c1e56b0ba0	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	e457070d-299a-426b-b12b-e6c59ca987c4	t
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	8f3b7070-77de-435f-b22f-c63336a78288	t
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	783af926-7768-4e30-9318-944d7d91b3c1	t
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	8367c2a1-34de-4136-9494-44766510b6e2	f
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	bc587d26-8368-4e0c-995d-d55570b1db85	f
039edccc-f22b-4c35-afa7-06aa26f6d1b6	e457070d-299a-426b-b12b-e6c59ca987c4	t
039edccc-f22b-4c35-afa7-06aa26f6d1b6	8f3b7070-77de-435f-b22f-c63336a78288	t
039edccc-f22b-4c35-afa7-06aa26f6d1b6	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
039edccc-f22b-4c35-afa7-06aa26f6d1b6	783af926-7768-4e30-9318-944d7d91b3c1	t
039edccc-f22b-4c35-afa7-06aa26f6d1b6	8367c2a1-34de-4136-9494-44766510b6e2	f
039edccc-f22b-4c35-afa7-06aa26f6d1b6	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
039edccc-f22b-4c35-afa7-06aa26f6d1b6	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
039edccc-f22b-4c35-afa7-06aa26f6d1b6	bc587d26-8368-4e0c-995d-d55570b1db85	f
333fcd28-a18c-4386-b79f-216adeb9cf95	e457070d-299a-426b-b12b-e6c59ca987c4	t
333fcd28-a18c-4386-b79f-216adeb9cf95	8f3b7070-77de-435f-b22f-c63336a78288	t
333fcd28-a18c-4386-b79f-216adeb9cf95	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
333fcd28-a18c-4386-b79f-216adeb9cf95	783af926-7768-4e30-9318-944d7d91b3c1	t
333fcd28-a18c-4386-b79f-216adeb9cf95	8367c2a1-34de-4136-9494-44766510b6e2	f
333fcd28-a18c-4386-b79f-216adeb9cf95	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
333fcd28-a18c-4386-b79f-216adeb9cf95	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
333fcd28-a18c-4386-b79f-216adeb9cf95	bc587d26-8368-4e0c-995d-d55570b1db85	f
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	e457070d-299a-426b-b12b-e6c59ca987c4	t
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	8f3b7070-77de-435f-b22f-c63336a78288	t
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	783af926-7768-4e30-9318-944d7d91b3c1	t
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	8367c2a1-34de-4136-9494-44766510b6e2	f
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
fd4a20e2-32a0-4e6f-a037-9d515fdf737b	bc587d26-8368-4e0c-995d-d55570b1db85	f
2f201371-1f6c-4771-bbad-6f14baebcd30	e457070d-299a-426b-b12b-e6c59ca987c4	t
2f201371-1f6c-4771-bbad-6f14baebcd30	8f3b7070-77de-435f-b22f-c63336a78288	t
2f201371-1f6c-4771-bbad-6f14baebcd30	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
2f201371-1f6c-4771-bbad-6f14baebcd30	783af926-7768-4e30-9318-944d7d91b3c1	t
2f201371-1f6c-4771-bbad-6f14baebcd30	8367c2a1-34de-4136-9494-44766510b6e2	f
2f201371-1f6c-4771-bbad-6f14baebcd30	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
2f201371-1f6c-4771-bbad-6f14baebcd30	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
2f201371-1f6c-4771-bbad-6f14baebcd30	bc587d26-8368-4e0c-995d-d55570b1db85	f
1d762543-1e89-4e78-af2e-02c1e56b0ba0	e457070d-299a-426b-b12b-e6c59ca987c4	t
1d762543-1e89-4e78-af2e-02c1e56b0ba0	8f3b7070-77de-435f-b22f-c63336a78288	t
1d762543-1e89-4e78-af2e-02c1e56b0ba0	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
1d762543-1e89-4e78-af2e-02c1e56b0ba0	783af926-7768-4e30-9318-944d7d91b3c1	t
1d762543-1e89-4e78-af2e-02c1e56b0ba0	8367c2a1-34de-4136-9494-44766510b6e2	f
1d762543-1e89-4e78-af2e-02c1e56b0ba0	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
1d762543-1e89-4e78-af2e-02c1e56b0ba0	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
1d762543-1e89-4e78-af2e-02c1e56b0ba0	bc587d26-8368-4e0c-995d-d55570b1db85	f
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	e457070d-299a-426b-b12b-e6c59ca987c4	t
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	8f3b7070-77de-435f-b22f-c63336a78288	t
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	783af926-7768-4e30-9318-944d7d91b3c1	t
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	8367c2a1-34de-4136-9494-44766510b6e2	f
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
cf41fabc-a33a-47f6-8a8f-2b5e301d456a	bc587d26-8368-4e0c-995d-d55570b1db85	f
723b4775-6ec2-44ff-9adf-01102831b159	4f8788a5-161c-43b7-b874-f93066cd7b06	t
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	4f8788a5-161c-43b7-b874-f93066cd7b06	t
d84211f7-5b12-4df5-929f-ed9944e2091b	4f8788a5-161c-43b7-b874-f93066cd7b06	t
3e44a660-3d19-4571-8887-c5df27db78ba	4f8788a5-161c-43b7-b874-f93066cd7b06	t
a9b587ea-5048-46f6-8ccd-64c77758ce6f	4f8788a5-161c-43b7-b874-f93066cd7b06	t
324dcc7d-4bef-4361-abbd-eb0dda84aed6	4f8788a5-161c-43b7-b874-f93066cd7b06	t
723b4775-6ec2-44ff-9adf-01102831b159	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
723b4775-6ec2-44ff-9adf-01102831b159	a9a31276-2278-4642-a35c-768c9e8c4658	t
723b4775-6ec2-44ff-9adf-01102831b159	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
723b4775-6ec2-44ff-9adf-01102831b159	2a84a550-2741-4334-b5f6-e207ce547e19	t
723b4775-6ec2-44ff-9adf-01102831b159	b895192c-855c-4f46-9a58-ff414aec081d	f
723b4775-6ec2-44ff-9adf-01102831b159	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
723b4775-6ec2-44ff-9adf-01102831b159	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
723b4775-6ec2-44ff-9adf-01102831b159	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	a9a31276-2278-4642-a35c-768c9e8c4658	t
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	2a84a550-2741-4334-b5f6-e207ce547e19	t
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	b895192c-855c-4f46-9a58-ff414aec081d	f
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
d84211f7-5b12-4df5-929f-ed9944e2091b	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
d84211f7-5b12-4df5-929f-ed9944e2091b	a9a31276-2278-4642-a35c-768c9e8c4658	t
d84211f7-5b12-4df5-929f-ed9944e2091b	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
d84211f7-5b12-4df5-929f-ed9944e2091b	2a84a550-2741-4334-b5f6-e207ce547e19	t
d84211f7-5b12-4df5-929f-ed9944e2091b	b895192c-855c-4f46-9a58-ff414aec081d	f
d84211f7-5b12-4df5-929f-ed9944e2091b	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
d84211f7-5b12-4df5-929f-ed9944e2091b	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
d84211f7-5b12-4df5-929f-ed9944e2091b	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
3e44a660-3d19-4571-8887-c5df27db78ba	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
3e44a660-3d19-4571-8887-c5df27db78ba	a9a31276-2278-4642-a35c-768c9e8c4658	t
3e44a660-3d19-4571-8887-c5df27db78ba	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
3e44a660-3d19-4571-8887-c5df27db78ba	2a84a550-2741-4334-b5f6-e207ce547e19	t
3e44a660-3d19-4571-8887-c5df27db78ba	b895192c-855c-4f46-9a58-ff414aec081d	f
3e44a660-3d19-4571-8887-c5df27db78ba	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
3e44a660-3d19-4571-8887-c5df27db78ba	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
3e44a660-3d19-4571-8887-c5df27db78ba	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
a9b587ea-5048-46f6-8ccd-64c77758ce6f	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
a9b587ea-5048-46f6-8ccd-64c77758ce6f	a9a31276-2278-4642-a35c-768c9e8c4658	t
a9b587ea-5048-46f6-8ccd-64c77758ce6f	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
a9b587ea-5048-46f6-8ccd-64c77758ce6f	2a84a550-2741-4334-b5f6-e207ce547e19	t
a9b587ea-5048-46f6-8ccd-64c77758ce6f	b895192c-855c-4f46-9a58-ff414aec081d	f
a9b587ea-5048-46f6-8ccd-64c77758ce6f	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
a9b587ea-5048-46f6-8ccd-64c77758ce6f	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
a9b587ea-5048-46f6-8ccd-64c77758ce6f	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
324dcc7d-4bef-4361-abbd-eb0dda84aed6	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
324dcc7d-4bef-4361-abbd-eb0dda84aed6	a9a31276-2278-4642-a35c-768c9e8c4658	t
324dcc7d-4bef-4361-abbd-eb0dda84aed6	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
324dcc7d-4bef-4361-abbd-eb0dda84aed6	2a84a550-2741-4334-b5f6-e207ce547e19	t
324dcc7d-4bef-4361-abbd-eb0dda84aed6	b895192c-855c-4f46-9a58-ff414aec081d	f
324dcc7d-4bef-4361-abbd-eb0dda84aed6	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
324dcc7d-4bef-4361-abbd-eb0dda84aed6	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
324dcc7d-4bef-4361-abbd-eb0dda84aed6	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
76f65bf9-3b38-4021-bd64-8119d10e1b8e	4f8788a5-161c-43b7-b874-f93066cd7b06	t
76f65bf9-3b38-4021-bd64-8119d10e1b8e	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
76f65bf9-3b38-4021-bd64-8119d10e1b8e	a9a31276-2278-4642-a35c-768c9e8c4658	t
76f65bf9-3b38-4021-bd64-8119d10e1b8e	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
76f65bf9-3b38-4021-bd64-8119d10e1b8e	2a84a550-2741-4334-b5f6-e207ce547e19	t
76f65bf9-3b38-4021-bd64-8119d10e1b8e	b895192c-855c-4f46-9a58-ff414aec081d	f
76f65bf9-3b38-4021-bd64-8119d10e1b8e	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
76f65bf9-3b38-4021-bd64-8119d10e1b8e	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
76f65bf9-3b38-4021-bd64-8119d10e1b8e	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
f1718f41-d77f-4fea-a7de-2894d410fc4b	79a285b0-74a5-4d1c-b72a-d564e4c263b0
b895192c-855c-4f46-9a58-ff414aec081d	f307ed86-64d1-4a2e-9102-fa7b08fcabd1
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
44f33529-93fe-473f-ad16-9e322c21de16	Trusted Hosts	master	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
45a9de80-0b99-4b1a-a717-8c144e84ac44	Consent Required	master	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
88860151-43d9-4b2f-9147-2ad7048cb331	Full Scope Disabled	master	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
6bc42072-f748-43a3-869b-0f0c03c59ae5	Max Clients Limit	master	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
7f5999d2-8c4e-410d-b4af-139de8f15bd5	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
6e3cb996-0742-4d05-84b5-88789cc814ed	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
5d77dd34-7788-4b2c-a884-85e2bc8e22c0	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
9867e6db-495c-4b85-88f3-d3a14a637cc0	fallback-HS256	master	hmac-generated	org.keycloak.keys.KeyProvider	master	\N
2f304249-cb39-430b-9733-23260a67367e	fallback-RS256	master	rsa-generated	org.keycloak.keys.KeyProvider	master	\N
8ec6495c-7f15-4f40-9697-17f47b099393	rsa-generated	myrealm	rsa-generated	org.keycloak.keys.KeyProvider	myrealm	\N
2e52535e-6fe6-4dca-9aa6-8eb71263e043	hmac-generated	myrealm	hmac-generated	org.keycloak.keys.KeyProvider	myrealm	\N
1da644e6-4405-42dd-a597-1f75c5786635	aes-generated	myrealm	aes-generated	org.keycloak.keys.KeyProvider	myrealm	\N
75e3bbcb-bfcd-4cc2-9b2d-1bce8615c697	Trusted Hosts	myrealm	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
413630e0-cfa3-4dc1-96ef-494b95d6e2a3	Consent Required	myrealm	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
9f3bc1db-1194-4352-a86f-b49bdff1b2b9	Full Scope Disabled	myrealm	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
560ac6ff-fd5a-4fa1-a7a2-7ab6ce8b3f40	Max Clients Limit	myrealm	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
7b206ae0-31f8-48d5-99d3-447b92e317f7	Allowed Protocol Mapper Types	myrealm	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
ceb447b1-2aa1-400a-99e7-e10e13f677c1	Allowed Client Scopes	myrealm	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	anonymous
50c12406-5ad0-4830-bcba-ae31c487fbe3	Allowed Protocol Mapper Types	myrealm	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	authenticated
91116433-3186-4c68-a0f5-d86861e9438a	Allowed Client Scopes	myrealm	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	myrealm	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
8c81a1a2-9101-48fa-8f4d-a5ce96b0da22	6bc42072-f748-43a3-869b-0f0c03c59ae5	max-clients	200
fb1d1f07-df16-4073-9edf-c9131e366870	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
25bd60a2-541e-4f07-8020-e3deb986fc22	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	saml-user-property-mapper
a8e09727-10f6-4a99-8e22-35030bb97af6	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	saml-user-attribute-mapper
40c6b83e-9de0-4dd1-9bb1-aba389196959	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	oidc-full-name-mapper
85c6352d-a74c-45ab-b255-ccc364571db2	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	saml-role-list-mapper
a47d1155-330f-4a49-8b29-d6c51579910b	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	oidc-address-mapper
c1484725-23ac-4c22-9c45-c5fd5bfd7c65	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
73367215-2d93-4fdd-a346-e4a8f7a8f194	7f5999d2-8c4e-410d-b4af-139de8f15bd5	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
99c5e766-d434-459c-afc5-88473b8a7444	5d77dd34-7788-4b2c-a884-85e2bc8e22c0	allow-default-scopes	true
62a275e4-381e-4688-a5f9-cc5a475894ba	6e3cb996-0742-4d05-84b5-88789cc814ed	allow-default-scopes	true
3a3f14b0-ec90-44fa-b417-9b13bf023aac	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	oidc-full-name-mapper
1b29f123-3b27-4f78-8683-c2607f266a0b	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	oidc-address-mapper
828f0221-a1f2-497e-abc9-d34ce1d5c899	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	saml-role-list-mapper
a0f0c0e6-c865-4de1-8c30-68e8b433c2d0	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	saml-user-attribute-mapper
21982599-5d97-432c-889b-a20ef75da136	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8974da2c-850d-40d7-8749-cc01ceecb64b	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	saml-user-property-mapper
b035f6ca-03b5-474b-bee7-d08eb929ca05	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
9e7a3718-bfad-4166-bece-1c757289b281	ec40213f-2bbf-4da9-bbbb-5d0c820f4ae7	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
895da542-927e-49d3-a08e-2e71300a4085	44f33529-93fe-473f-ad16-9e322c21de16	host-sending-registration-request-must-match	true
0a4a60a6-2d44-4857-b523-84ea3d7e373a	44f33529-93fe-473f-ad16-9e322c21de16	client-uris-must-match	true
f159d5f6-9d2c-4fa4-af80-042a3d73dab6	9867e6db-495c-4b85-88f3-d3a14a637cc0	algorithm	HS256
c47cfe07-a51d-4c39-8584-cf0733c9fd6b	9867e6db-495c-4b85-88f3-d3a14a637cc0	kid	e411731d-c0f8-41b6-84cc-bb01060851c8
1aecb9e7-c6d5-44ed-964b-cb0d69c837d5	9867e6db-495c-4b85-88f3-d3a14a637cc0	secret	W7Jecyld5MNxJzR313Rpd_3peXmkJjVs6cF2AS9BhFSDzVfn2h8XQxP72ydw7gi4pbHSnlJybB2zb0X-wIN0QA
d61f0f43-b7ae-4267-a64a-6e3027f2ed33	9867e6db-495c-4b85-88f3-d3a14a637cc0	priority	-100
c2ca9b4b-3b25-4326-8b8f-c5b7480b46e8	2f304249-cb39-430b-9733-23260a67367e	privateKey	MIIEowIBAAKCAQEAs7IV4canXvaxMPmksMlY5F2NvAMW8QzuI/Gsw7oUQR5B55WyFBEd/hMJ+s/Ac00X7mlvzQ0AqUN+JsL5zHYcw8sGUzSW0j3+Y24LThJuGJmp9UmpCtWkjAzFN/MBQLTSH/aar3YO3EsT839lcXR7aW5IBXpjTpAt14VOyNLKlB9lJ7mkuPzjBDDfxnpb9zdln7gbkqZG1bE83ubPdYCufK8NI9DlV/HDZhRs96Pc/+C6nh3hO43BjakmSqOR6ouWBXsckOyW82mIUba3A5wgX0MJ0XFRRHNhTe0N0u7y6rkgKENgRgVyjk4ACG22qiKau1+LjU8sXy35Gr8wMRMWTwIDAQABAoIBAQCbSvMILEKmmfEljwkZ0tfke0kqy0y/Qtpm68vPVnd8kyaHeeHs36IY2eFNBM+flWdyHWKGRY9luDNEUknIveY7+q/bpl4VEYhP62EPtnO5BMtRdLgG6f0LH1os8PALOHlDMD4cFp3fGW8DhvxnITAqPCk3ur4pvgYv9D/S5AA4IrpOQcBY2mn6imR2hxJYfs90ADXwDVgYUcYH+f5dRi0BHwg0QtXvptDiwULxNx0xIQYKbXO+ekBrPvtK5ZdUebzQKf9glSagOIysAQCbPStLZTir0geSGQMzuNlECPgCjJPGccAmROxuKsOfV0kpUf7RsKU6m2u6mXEkgSZqTHIZAoGBAOOSfpZno60Nj19DKmJUesyRF81oojKHu5N1y0WJDG17d1B/Zzc/WNIpw6Qr8dNmDfeA1fwrwFjkh3gIUPt3IbDAYEEtBEGYE5U+R7lGR6ObyauDIoz5v6LteIsL9XG7iNTsnj3S0u4qBEjZGjMBYcqM411AA+pVazahomuQkmKLAoGBAMokjQ9PN1M0HWw0cwYeDjdLbAEo9Px/x6DcHoQS05tbxYFxOl5Bwyb9UvEYDmprIEVFSQYk3sQia3etCmgVkHarkMADslmXIVUgRZlBCiq5B9D5UuDSUWZ+z7FxQGMkWNUZCr8OB7Im5pjeYLJoLfdk5RhjRHC1CXC19/B6ZSfNAoGACAAecysxlePkJnU2CD7wEkEHlTEYgq5C6ew6OTeYOEEe8LWJ62dOuBS/zAW/eq8bzpe47iSbnoRqPs4MCsslZBFfUOtEOwodpiGKY/kUi6vuaxkxHcOp+RBgLIM/HcB6DwJCjenbgIP5opX/Vcu2pGhPlfeqK5LVMhZ8n0t12gECgYB1k90Y0pLzqpSSo89j94d9Ujl4U0JsvEZ5oo99cxXyf+bZ6+pveQDyZNchtURtUfJrWGmpUTjiDMNF0TkEYcatwA1qIrxSsD2LLkJNai9nukh5nQxACRWf8JMOOzmgcTvad75wctC3JzlqIa9NFpvmEqHPFa5xgFwFW1LkZc0A4QKBgCrKs1rls2R1FVvV8bkBeiIJLUVD8MEwzj8/y/G3KOXmsRq4FOY/POC46ChRBAvSBZ3Fv6YxqAAr2HYayUc1VqpB+On72ObuCyVBcHvlniwNtgvR7z5NzlhjqfyTD29YiLkmCK2kYI7rLyLBEFXNlgGFL16w1YYrj+0zuhiDbp3v
80cb886d-33bf-41a4-9b76-2f47c12077c0	2f304249-cb39-430b-9733-23260a67367e	algorithm	RS256
9db4b7d8-a4ea-49b3-a984-8d6f51e57ba9	2f304249-cb39-430b-9733-23260a67367e	certificate	MIICmzCCAYMCBgF3AaZy0DANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjEwMTE0MTYwNTIxWhcNMzEwMTE0MTYwNzAxWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCzshXhxqde9rEw+aSwyVjkXY28AxbxDO4j8azDuhRBHkHnlbIUER3+Ewn6z8BzTRfuaW/NDQCpQ34mwvnMdhzDywZTNJbSPf5jbgtOEm4Yman1SakK1aSMDMU38wFAtNIf9pqvdg7cSxPzf2VxdHtpbkgFemNOkC3XhU7I0sqUH2UnuaS4/OMEMN/Gelv3N2WfuBuSpkbVsTze5s91gK58rw0j0OVX8cNmFGz3o9z/4LqeHeE7jcGNqSZKo5Hqi5YFexyQ7JbzaYhRtrcDnCBfQwnRcVFEc2FN7Q3S7vLquSAoQ2BGBXKOTgAIbbaqIpq7X4uNTyxfLfkavzAxExZPAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAK+uEUAiyIuItfi3qidkRRiit5scDA8FyG8Oe9kvFYDrII3Np5W8YAwnG6/Gw/F/hGcrVFzRQLDPpFq2UE7yibZpgPKQWGxLdamsuDJTc5HZi+egLj67nBFE7z+g1BOkE/GJZZuHd98IyU2mlSwU56KmBJC8eLt0hTcXmqEmxVr05o5rRpqihK6dcOiTX5laNxjs6Yn7CVyrhSlTsME1tNR67EDKAJtvOpyH2jeyx8O/kLK+ydtBXmr5qlfqtDFxSh1SI2BlGPd/Kfl3IxQQoHm6y5O4DeJINqYE/newEErovH4+1M0PUEWcXdt1HShFv/pwhHBVpuL0Kk5zpsAE2ik=
26cdf10c-fd3a-4fa7-b90f-a35a3f00a65e	2f304249-cb39-430b-9733-23260a67367e	priority	-100
ea0148ee-bc28-43b9-aea7-a284c5e03aee	2e52535e-6fe6-4dca-9aa6-8eb71263e043	priority	100
cf8bfe0c-b3bd-4a8a-8bc9-94d90f4fe52f	2e52535e-6fe6-4dca-9aa6-8eb71263e043	secret	uDkeESwVkJzx5d4jw7LgASA6dKK53rAxtAehTLVdcY2_f4DG4lN00ED5IOVuEmo7Fc0oLIBl5zl06rcFPu5EUw
c6aaad57-d3e3-4d31-b63e-ff42fd42f2ee	2e52535e-6fe6-4dca-9aa6-8eb71263e043	algorithm	HS256
d644a790-0482-45fd-872a-40b5497f34c9	2e52535e-6fe6-4dca-9aa6-8eb71263e043	kid	bc2bcea6-0f89-4ff2-a086-8a3ebd0bdf78
4a4e77ce-7cec-42db-82ea-68b92fbba501	1da644e6-4405-42dd-a597-1f75c5786635	kid	281a420a-dfbc-4f8b-839e-ee386717dd59
8c92fe0f-fae9-4680-bc62-b2dc4bc27082	1da644e6-4405-42dd-a597-1f75c5786635	secret	3d7l2wBuhIRQDIfZJYjGrw
948213fd-0d1c-4356-b54a-799ef90b6eae	1da644e6-4405-42dd-a597-1f75c5786635	priority	100
2449dc25-e736-46a6-a7c9-fb4e28f22d78	8ec6495c-7f15-4f40-9697-17f47b099393	certificate	MIICnTCCAYUCBgF3AaaUmzANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdteXJlYWxtMB4XDTIxMDExNDE2MDUzMFoXDTMxMDExNDE2MDcxMFowEjEQMA4GA1UEAwwHbXlyZWFsbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKnwIXijueHyTWQnhaXobK6VeD/NtBPDjMhU1q6UepI1x4SPJi4n0HkcG+xLAVnGjbzSEyfJUu9GcDwRKSEpe5Li0Nymv2VjhSxQcU1nVwX0eM9e5RRViJOEZCT2QJInPhZgkJ8ukMFoXymRuE3TwcSx5szhDOQA4UQCPKPbBC//ZxWduLkff0ZwP10Gc0LcPPX3lz54LgTBlTF+L1n1+L66A8ouJdMrKAAE+MrXLlNYOugKn7Ivm0QIyT9t6JPJunf1Jx8YrKvnL5DRCp97VCN4aUI6ceigKXEEcOzEDIXgQcogUPnphiWhrrl2MXKyLpH97JUaXZ7JsI3A7zn87gcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAPuho9v9CpAiTGww+zRFFJl2gVhxkrR5JaSAvlJVeaZPoygaXpRstOrn2yV8JzkcIwGPytQDfzwb24Pl1sE2LzvwzRQOMdQ5/qCE6oxY7nAVxDU4IHg/wwfcVCBfJMxibRV/CYpKtxDV3rxJyWNC1rvpTAo+1IViNH6ZIFUhjLje6ynlEb4MIrfb8XMFXi6PpRtU7Y1eDMgd4JfM8xM2SZPmWpunEUxXlgmNvetevuyPXBo5dWKieec+4+vIfAzsyK5mjzvAQXLVqkWUpGU3GPGkxbhv2jaZGYB25/F1wrjpXXOA9Q408765Ymk/EfnAuhdIlBTi5vM0Nwjic0ZyOSA==
a54e4341-5e85-4d2b-8c36-25d408e361d3	8ec6495c-7f15-4f40-9697-17f47b099393	priority	100
87d37bc3-a68f-43ef-9223-fa25c5987cb8	8ec6495c-7f15-4f40-9697-17f47b099393	privateKey	MIIEpAIBAAKCAQEAqfAheKO54fJNZCeFpehsrpV4P820E8OMyFTWrpR6kjXHhI8mLifQeRwb7EsBWcaNvNITJ8lS70ZwPBEpISl7kuLQ3Ka/ZWOFLFBxTWdXBfR4z17lFFWIk4RkJPZAkic+FmCQny6QwWhfKZG4TdPBxLHmzOEM5ADhRAI8o9sEL/9nFZ24uR9/RnA/XQZzQtw89feXPnguBMGVMX4vWfX4vroDyi4l0ysoAAT4ytcuU1g66Aqfsi+bRAjJP23ok8m6d/UnHxisq+cvkNEKn3tUI3hpQjpx6KApcQRw7MQMheBByiBQ+emGJaGuuXYxcrIukf3slRpdnsmwjcDvOfzuBwIDAQABAoIBAFRy+K8y7dTSzJLQ8SGZdyjrLm7Gko6fxv5m6qinMKIoB5ZgbODS+E63IUkznOA4Q4dp/grviT9PCcdP39iS/M3p2VFNrB9+bVewQh3tFNnou4CR79VDDDQCvqF/nmcDCV+lbTktstHqRCAsQiKq8MgGgGOgEv/bUBaz5d6noFUZDfEd4hmi7kQIWooO49FZTclMXsfM8hHqtur4HLFbPl9SZ1p4OhOkPf+vRKQk6fQ54K6tg5aBmdx8JnwS1SiuRR/jTbLVe1Gfmq9JxDEeQYuLWljAKblw+XNEsMdfi8ku1nwDpJOY+QD2cnz8kr34kCQIGKyiPCQ5g2uOFJFZOQECgYEA7L8vfBNrlB/GrRxL5WY2brda5DZ/LQ4ymD23KenTkwNLHNQhEGv/p9UZE0Of4wxy8EHH+7CmWHsol8G9HM2yllbtQFmsux9ABqs4C6GKbQmKUrXJJWfBRqP1jI18cauoTYfcjFejc8JloW8OLIfJJKXW4u9yJ6NsZE0Z5BCpEFcCgYEAt8IOwQV/iYAoKupw3vrq296yhPeoDr5dniREuogoDx744TNNoSnO/FUTOlTlj18DT70Z7+AKjA8yC3HLkyaXEGXioVyx8qAfvK66XCnAdhW9vzvOSNfxiioT9C/c3cFLw+D3fEK1p4hnOdko8umwhWPho80P9otS7MFNDk9jwdECgYEAtVYDcxAU+JIWRYZFA+L0kn1S2zZ61vHnAwFSiIIXkqWVJPG+mat/WPg6iqzjjK9+YlSgb0JxR5ieEQ9OYP+VaN4QP5fwXCuliPYgqZgERVxnXM7s0P/V5Nu1OwEsbozDDw+feMev5Pzjh3Fe8/DVuoJkQ9KQJ5hfb7w2tp+kP2UCgYB6qsO4nJf/zRqDU49Xer7vWaFoW/7HINNT7zgmISBEv9M6WkoXLNas4Yn9ZZD8/VszjrPSyoef6cDpnORd7ePoIWuBdmSf575n8WgcgA6nhWnuT9ksDWODbQV2+8CAFDokn3f2bn3fQZJPLqVESzX4Ra3p78kZNvZ7b6qlw99/EQKBgQCPNg8mhXhY30TCLtoi9idkdMknW2H6FtczOq7lWxPKhbhI51D9wTrlsPPmAoRwmfcN8/ebnL2aptmqneWC9jQzG+ken3Hr85KIkrwdhttVfDNMOl9xNAMW//Ts5+JLcUTTHQeKiea2Ek01SCPPWQpdu6qfrDcr8l5cd7B0wMBiUg==
fbda7592-f2d0-451b-a39c-0ba40bfd4f1a	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	saml-user-attribute-mapper
0aee9c61-8312-4762-932e-8e56fac09d01	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	saml-user-property-mapper
149b01b9-0bba-4c37-bf26-83d10e275df3	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	oidc-address-mapper
383fea48-bb0e-48ec-9723-b6bd951fd8d2	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	saml-role-list-mapper
99b3048b-41ea-42d6-8f8d-3cd1e060481d	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
294ed5ab-2987-4516-bccd-b457351a249f	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	oidc-full-name-mapper
351f0577-588e-4613-b523-e37a31dde9b5	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
efbb1ca7-16af-4efd-9a65-9b089fd348a7	50c12406-5ad0-4830-bcba-ae31c487fbe3	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
4a7eb54e-8987-4def-95c4-67661b723481	560ac6ff-fd5a-4fa1-a7a2-7ab6ce8b3f40	max-clients	200
214b6439-af6e-486b-a1f1-c00eeb020408	91116433-3186-4c68-a0f5-d86861e9438a	allow-default-scopes	true
a5bf18ad-b193-4df6-b73a-d7b4322f9cc8	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	oidc-address-mapper
e64f2f39-124a-48b1-8303-8f5b877dc127	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
370ad756-2378-41c3-bbd9-c4da2dc5fd05	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	oidc-full-name-mapper
5e822397-1c45-46fa-993f-8029134094ef	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
a3a3419a-ccd8-4a7f-9c8a-942bdbbb9dd9	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
f3570211-a7bf-4b57-b409-d603affae6a1	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	saml-user-attribute-mapper
f7dd5477-afa3-409e-8964-d31ca0f5b0eb	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	saml-user-property-mapper
174fef0d-a170-4277-a63e-5f2baac75b2a	7b206ae0-31f8-48d5-99d3-447b92e317f7	allowed-protocol-mapper-types	saml-role-list-mapper
525ebb1a-1e3c-49bc-9390-a86a4a1c6be7	75e3bbcb-bfcd-4cc2-9b2d-1bce8615c697	client-uris-must-match	true
9dee5ec8-cdd1-4bd8-85c8-4b5a1e5dcff5	75e3bbcb-bfcd-4cc2-9b2d-1bce8615c697	host-sending-registration-request-must-match	true
f1b2f6d0-5540-4076-9ec1-81b85ff83841	ceb447b1-2aa1-400a-99e7-e10e13f677c1	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
657756a2-0e23-407e-8b97-d443caa9a2c4	4f48c6c9-422b-4b84-b2f9-5a75b338c062
657756a2-0e23-407e-8b97-d443caa9a2c4	f6e11fee-30f9-4518-9b4d-da080b90521e
657756a2-0e23-407e-8b97-d443caa9a2c4	4842011e-4bb6-4e92-b121-ac5a8a7335d6
657756a2-0e23-407e-8b97-d443caa9a2c4	bf939a01-cf8c-4cc3-b812-aabef18c57e9
657756a2-0e23-407e-8b97-d443caa9a2c4	264bc5b9-ab66-4bed-8034-9ef3ac84b6b0
657756a2-0e23-407e-8b97-d443caa9a2c4	828eb57a-e7a0-4b1c-ab9e-bc5d4b48d2a6
657756a2-0e23-407e-8b97-d443caa9a2c4	12bdfa43-2d71-48dd-91b5-ac7993f33e7a
657756a2-0e23-407e-8b97-d443caa9a2c4	2162592f-da33-494f-8da2-132e397b16d9
657756a2-0e23-407e-8b97-d443caa9a2c4	437f76bb-114d-4ca1-9e3b-031628013d1b
657756a2-0e23-407e-8b97-d443caa9a2c4	f2895f5f-34d5-4a0f-9be3-a3c2976c60a4
657756a2-0e23-407e-8b97-d443caa9a2c4	40e509af-f484-4f62-affe-ce3635a02e5b
657756a2-0e23-407e-8b97-d443caa9a2c4	3bfb6313-0daf-4daf-9cac-e952e5ddde5f
657756a2-0e23-407e-8b97-d443caa9a2c4	5b8e2074-037d-49da-9e8f-8eee7061ebab
657756a2-0e23-407e-8b97-d443caa9a2c4	80e388a0-9e53-4379-b0e5-b2d5117dd451
657756a2-0e23-407e-8b97-d443caa9a2c4	3f63352a-1d06-44d5-929a-98aec4435082
657756a2-0e23-407e-8b97-d443caa9a2c4	31cf7fc3-ea27-4f0f-b145-1f748d69fb89
657756a2-0e23-407e-8b97-d443caa9a2c4	8ffbd3b0-62e9-4d43-9103-6fbd66a0abbe
657756a2-0e23-407e-8b97-d443caa9a2c4	a7cfe7c9-e3bf-4b33-84e7-98cd8e3f6d44
264bc5b9-ab66-4bed-8034-9ef3ac84b6b0	31cf7fc3-ea27-4f0f-b145-1f748d69fb89
bf939a01-cf8c-4cc3-b812-aabef18c57e9	3f63352a-1d06-44d5-929a-98aec4435082
bf939a01-cf8c-4cc3-b812-aabef18c57e9	a7cfe7c9-e3bf-4b33-84e7-98cd8e3f6d44
553c721f-6964-47fd-ae7e-fbb44b655c19	266ebcaa-6337-4de6-ab01-7b7d990e16f6
f3fc44a7-1b58-4312-8cab-077fa472f015	69a91843-a18b-40b9-b38c-74a95914ee01
657756a2-0e23-407e-8b97-d443caa9a2c4	eda21b5c-cc8b-4c4b-9f68-889dafefe5a6
657756a2-0e23-407e-8b97-d443caa9a2c4	d62690b1-9a0b-4f7e-bac7-63edea982903
657756a2-0e23-407e-8b97-d443caa9a2c4	9cf28495-c31f-4755-b9e6-20912db99c44
657756a2-0e23-407e-8b97-d443caa9a2c4	fb4c8218-eabe-4ac0-a2a8-e2a57bc6968d
657756a2-0e23-407e-8b97-d443caa9a2c4	8f39f82b-4547-4be8-aa58-4182cd125094
657756a2-0e23-407e-8b97-d443caa9a2c4	8bc7efc5-383a-4610-bba6-2071a069f0aa
657756a2-0e23-407e-8b97-d443caa9a2c4	3e29a50d-cf59-4d78-9761-887de4430bda
657756a2-0e23-407e-8b97-d443caa9a2c4	ec28b78a-3ec3-451e-91b4-dbeb39f69a61
657756a2-0e23-407e-8b97-d443caa9a2c4	7a24db2c-be2b-43ae-9a50-28d93ad82d63
657756a2-0e23-407e-8b97-d443caa9a2c4	43e16715-3458-4aa9-aeec-f31295bad8e9
657756a2-0e23-407e-8b97-d443caa9a2c4	9985913d-ea35-40ca-b1ed-a211c83df9fc
657756a2-0e23-407e-8b97-d443caa9a2c4	476368be-f7bd-40ea-8003-504a9cb59c8f
657756a2-0e23-407e-8b97-d443caa9a2c4	2dff7b8e-0aa1-402f-8aa3-633c96ccebad
657756a2-0e23-407e-8b97-d443caa9a2c4	7a99b859-d1ef-434e-bb05-c567b9b10252
657756a2-0e23-407e-8b97-d443caa9a2c4	14bcc1bc-4f29-4af4-9e01-5ad77a67898e
657756a2-0e23-407e-8b97-d443caa9a2c4	f699ba19-aee2-4f60-bd4e-1d132d07e713
657756a2-0e23-407e-8b97-d443caa9a2c4	4377c414-f6bf-4e6a-a39b-1c120a9609ad
657756a2-0e23-407e-8b97-d443caa9a2c4	5285fded-b624-45a9-aee8-4ce94bee214f
8f39f82b-4547-4be8-aa58-4182cd125094	f699ba19-aee2-4f60-bd4e-1d132d07e713
fb4c8218-eabe-4ac0-a2a8-e2a57bc6968d	14bcc1bc-4f29-4af4-9e01-5ad77a67898e
fb4c8218-eabe-4ac0-a2a8-e2a57bc6968d	5285fded-b624-45a9-aee8-4ce94bee214f
14d5bd56-1536-4353-9829-6f3ed21c4ed3	af7a0c8e-7457-4f4c-852e-88f03a0ea5b1
14d5bd56-1536-4353-9829-6f3ed21c4ed3	0c146087-c942-4778-84f7-30ab179fb67c
14d5bd56-1536-4353-9829-6f3ed21c4ed3	c21b44c4-b451-43d2-9bd6-a8a9b50ed0aa
14d5bd56-1536-4353-9829-6f3ed21c4ed3	b8b22f24-6fc2-4bac-9b8f-06eefdbc63f6
14d5bd56-1536-4353-9829-6f3ed21c4ed3	e9b3c52a-e888-4126-86a5-a78f4a125d74
14d5bd56-1536-4353-9829-6f3ed21c4ed3	d7d8dcf5-447f-40e4-ac64-554d25698321
14d5bd56-1536-4353-9829-6f3ed21c4ed3	d9e6c2f6-56ca-430b-9775-b25d45929193
14d5bd56-1536-4353-9829-6f3ed21c4ed3	e426d9ff-b9de-4f06-a2c0-d67acbbc794c
14d5bd56-1536-4353-9829-6f3ed21c4ed3	d366d009-09b1-4cdb-8731-18ec3ef6907d
14d5bd56-1536-4353-9829-6f3ed21c4ed3	a0a2fd59-a75e-4cf8-8988-d1d4eab43327
14d5bd56-1536-4353-9829-6f3ed21c4ed3	5485881d-d3e6-4621-97d3-df9b6d99b475
14d5bd56-1536-4353-9829-6f3ed21c4ed3	b433bc7d-7333-4ef9-bc11-2e8848dca465
14d5bd56-1536-4353-9829-6f3ed21c4ed3	5f576acc-b6ef-4805-ab78-7f36e93e2c52
14d5bd56-1536-4353-9829-6f3ed21c4ed3	fb373570-aed8-49af-a5e2-3610382c7c31
14d5bd56-1536-4353-9829-6f3ed21c4ed3	f9b7e731-38b9-4dfa-8ded-23a47a6d41b7
14d5bd56-1536-4353-9829-6f3ed21c4ed3	96d5bdb1-cb7d-47e5-a625-388b25f189f5
14d5bd56-1536-4353-9829-6f3ed21c4ed3	fc2ff585-7417-40ab-b32e-b2dadbf8e70b
b8b22f24-6fc2-4bac-9b8f-06eefdbc63f6	f9b7e731-38b9-4dfa-8ded-23a47a6d41b7
c21b44c4-b451-43d2-9bd6-a8a9b50ed0aa	fc2ff585-7417-40ab-b32e-b2dadbf8e70b
c21b44c4-b451-43d2-9bd6-a8a9b50ed0aa	fb373570-aed8-49af-a5e2-3610382c7c31
a854fd93-763d-440f-8bc5-cda240a787d9	bed5d6ff-cfbc-49ca-b3ac-c1a8e30501eb
71d2e144-0ff8-4515-b953-707645e01ea6	d4fc803f-4d38-4c64-9ac5-db60b259090a
657756a2-0e23-407e-8b97-d443caa9a2c4	386ea9d5-a32c-4352-85fe-e19972fb5bfc
14d5bd56-1536-4353-9829-6f3ed21c4ed3	9f47afdc-b74f-4b7f-ad0c-f071524417ff
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
22cbebe8-20f4-403b-8615-369b80725134	\N	password	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7	1610640229795	\N	{"value":"aGFpvQWa+pSiypCFoyxzRX6MFD26PBjs5y9Mg7gcvgOvolIhulZlw49VvSh2IZnBYZRKMMauEyArRCxomOhZbg==","salt":"b3a7nf1BG/tzwT5tiNRJyA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
1f2930d9-da72-417c-98c8-d03dbc58762f	\N	password	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b	1610640873725	\N	{"value":"jL12XYdFlepr7YIEarsIJLuxdwVNTBM6T056KTFTHWbXxVFw7VYd9r0Q6Rfz5i0mT08PurhrK1EPAIkyxtHBIw==","salt":"GfxkYF9Cc2q6Rj1xq7ncTQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2021-01-14 16:03:44.719885	1	EXECUTED	7:4e70412f24a3f382c82183742ec79317	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	0640224227
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2021-01-14 16:03:44.772382	2	MARK_RAN	7:cb16724583e9675711801c6875114f28	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	0640224227
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2021-01-14 16:03:44.819924	3	EXECUTED	7:0310eb8ba07cec616460794d42ade0fa	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	3.5.4	\N	\N	0640224227
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2021-01-14 16:03:44.824366	4	EXECUTED	7:5d25857e708c3233ef4439df1f93f012	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	0640224227
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2021-01-14 16:03:44.985476	5	EXECUTED	7:c7a54a1041d58eb3817a4a883b4d4e84	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	0640224227
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2021-01-14 16:03:44.998794	6	MARK_RAN	7:2e01012df20974c1c2a605ef8afe25b7	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	0640224227
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2021-01-14 16:03:45.169984	7	EXECUTED	7:0f08df48468428e0f30ee59a8ec01a41	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	0640224227
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2021-01-14 16:03:45.174572	8	MARK_RAN	7:a77ea2ad226b345e7d689d366f185c8c	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	0640224227
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2021-01-14 16:03:45.17926	9	EXECUTED	7:a3377a2059aefbf3b90ebb4c4cc8e2ab	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	3.5.4	\N	\N	0640224227
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2021-01-14 16:03:45.355249	10	EXECUTED	7:04c1dbedc2aa3e9756d1a1668e003451	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	3.5.4	\N	\N	0640224227
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2021-01-14 16:03:45.40973	11	EXECUTED	7:36ef39ed560ad07062d956db861042ba	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	0640224227
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2021-01-14 16:03:45.412378	12	MARK_RAN	7:d909180b2530479a716d3f9c9eaea3d7	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	0640224227
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2021-01-14 16:03:45.422156	13	EXECUTED	7:cf12b04b79bea5152f165eb41f3955f6	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	0640224227
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-01-14 16:03:45.448332	14	EXECUTED	7:7e32c8f05c755e8675764e7d5f514509	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	3.5.4	\N	\N	0640224227
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-01-14 16:03:45.450486	15	MARK_RAN	7:980ba23cc0ec39cab731ce903dd01291	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	0640224227
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-01-14 16:03:45.452559	16	MARK_RAN	7:2fa220758991285312eb84f3b4ff5336	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	3.5.4	\N	\N	0640224227
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-01-14 16:03:45.454462	17	EXECUTED	7:d41d8cd98f00b204e9800998ecf8427e	empty		\N	3.5.4	\N	\N	0640224227
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2021-01-14 16:03:45.500072	18	EXECUTED	7:91ace540896df890cc00a0490ee52bbc	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	3.5.4	\N	\N	0640224227
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2021-01-14 16:03:45.550466	19	EXECUTED	7:c31d1646dfa2618a9335c00e07f89f24	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	0640224227
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2021-01-14 16:03:45.555825	20	EXECUTED	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	0640224227
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-01-14 16:03:46.447761	45	EXECUTED	7:6a48ce645a3525488a90fbf76adf3bb3	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	0640224227
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2021-01-14 16:03:45.558589	21	MARK_RAN	7:f987971fe6b37d963bc95fee2b27f8df	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	0640224227
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2021-01-14 16:03:45.562141	22	MARK_RAN	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	0640224227
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2021-01-14 16:03:45.577916	23	EXECUTED	7:ed2dc7f799d19ac452cbcda56c929e47	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	3.5.4	\N	\N	0640224227
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2021-01-14 16:03:45.582711	24	EXECUTED	7:80b5db88a5dda36ece5f235be8757615	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	0640224227
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2021-01-14 16:03:45.584813	25	MARK_RAN	7:1437310ed1305a9b93f8848f301726ce	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	0640224227
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2021-01-14 16:03:45.650423	26	EXECUTED	7:b82ffb34850fa0836be16deefc6a87c4	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	3.5.4	\N	\N	0640224227
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2021-01-14 16:03:45.7817	27	EXECUTED	7:9cc98082921330d8d9266decdd4bd658	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	3.5.4	\N	\N	0640224227
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2021-01-14 16:03:45.784698	28	EXECUTED	7:03d64aeed9cb52b969bd30a7ac0db57e	update tableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	0640224227
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2021-01-14 16:03:45.897727	29	EXECUTED	7:f1f9fd8710399d725b780f463c6b21cd	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	3.5.4	\N	\N	0640224227
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2021-01-14 16:03:45.930821	30	EXECUTED	7:53188c3eb1107546e6f765835705b6c1	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	3.5.4	\N	\N	0640224227
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2021-01-14 16:03:45.972948	31	EXECUTED	7:d6e6f3bc57a0c5586737d1351725d4d4	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	3.5.4	\N	\N	0640224227
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2021-01-14 16:03:45.980973	32	EXECUTED	7:454d604fbd755d9df3fd9c6329043aa5	customChange		\N	3.5.4	\N	\N	0640224227
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-01-14 16:03:45.988401	33	EXECUTED	7:57e98a3077e29caf562f7dbf80c72600	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	0640224227
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-01-14 16:03:45.991099	34	MARK_RAN	7:e4c7e8f2256210aee71ddc42f538b57a	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	0640224227
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-01-14 16:03:46.022341	35	EXECUTED	7:09a43c97e49bc626460480aa1379b522	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	0640224227
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2021-01-14 16:03:46.027387	36	EXECUTED	7:26bfc7c74fefa9126f2ce702fb775553	addColumn tableName=REALM		\N	3.5.4	\N	\N	0640224227
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-01-14 16:03:46.036165	37	EXECUTED	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	0640224227
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2021-01-14 16:03:46.043923	38	EXECUTED	7:37fc1781855ac5388c494f1442b3f717	addColumn tableName=FED_USER_CONSENT		\N	3.5.4	\N	\N	0640224227
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2021-01-14 16:03:46.052288	39	EXECUTED	7:13a27db0dae6049541136adad7261d27	addColumn tableName=IDENTITY_PROVIDER		\N	3.5.4	\N	\N	0640224227
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-01-14 16:03:46.056964	40	MARK_RAN	7:550300617e3b59e8af3a6294df8248a3	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	0640224227
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-01-14 16:03:46.066877	41	MARK_RAN	7:e3a9482b8931481dc2772a5c07c44f17	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	0640224227
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2021-01-14 16:03:46.078502	42	EXECUTED	7:72b07d85a2677cb257edb02b408f332d	customChange		\N	3.5.4	\N	\N	0640224227
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-01-14 16:03:46.427759	43	EXECUTED	7:a72a7858967bd414835d19e04d880312	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	3.5.4	\N	\N	0640224227
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2021-01-14 16:03:46.438165	44	EXECUTED	7:94edff7cf9ce179e7e85f0cd78a3cf2c	addColumn tableName=USER_ENTITY		\N	3.5.4	\N	\N	0640224227
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-01-14 16:03:46.458216	46	EXECUTED	7:e64b5dcea7db06077c6e57d3b9e5ca14	customChange		\N	3.5.4	\N	\N	0640224227
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-01-14 16:03:46.462747	47	MARK_RAN	7:fd8cf02498f8b1e72496a20afc75178c	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	0640224227
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-01-14 16:03:46.55218	48	EXECUTED	7:542794f25aa2b1fbabb7e577d6646319	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	3.5.4	\N	\N	0640224227
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-01-14 16:03:46.563049	49	EXECUTED	7:edad604c882df12f74941dac3cc6d650	addColumn tableName=REALM		\N	3.5.4	\N	\N	0640224227
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2021-01-14 16:03:46.641449	50	EXECUTED	7:0f88b78b7b46480eb92690cbf5e44900	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	3.5.4	\N	\N	0640224227
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2021-01-14 16:03:46.719989	51	EXECUTED	7:d560e43982611d936457c327f872dd59	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	3.5.4	\N	\N	0640224227
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2021-01-14 16:03:46.724275	52	EXECUTED	7:c155566c42b4d14ef07059ec3b3bbd8e	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	0640224227
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2021-01-14 16:03:46.726759	53	EXECUTED	7:b40376581f12d70f3c89ba8ddf5b7dea	update tableName=REALM		\N	3.5.4	\N	\N	0640224227
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2021-01-14 16:03:46.729545	54	EXECUTED	7:a1132cc395f7b95b3646146c2e38f168	update tableName=CLIENT		\N	3.5.4	\N	\N	0640224227
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-01-14 16:03:46.739129	55	EXECUTED	7:d8dc5d89c789105cfa7ca0e82cba60af	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	3.5.4	\N	\N	0640224227
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-01-14 16:03:46.744031	56	EXECUTED	7:7822e0165097182e8f653c35517656a3	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	3.5.4	\N	\N	0640224227
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-01-14 16:03:46.776983	57	EXECUTED	7:c6538c29b9c9a08f9e9ea2de5c2b6375	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	3.5.4	\N	\N	0640224227
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-01-14 16:03:46.931439	58	EXECUTED	7:6d4893e36de22369cf73bcb051ded875	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	3.5.4	\N	\N	0640224227
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2021-01-14 16:03:46.999086	59	EXECUTED	7:57960fc0b0f0dd0563ea6f8b2e4a1707	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	3.5.4	\N	\N	0640224227
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2021-01-14 16:03:47.012075	60	EXECUTED	7:2b4b8bff39944c7097977cc18dbceb3b	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	0640224227
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-01-14 16:03:47.030596	61	EXECUTED	7:2aa42a964c59cd5b8ca9822340ba33a8	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	3.5.4	\N	\N	0640224227
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-01-14 16:03:47.043984	62	EXECUTED	7:9ac9e58545479929ba23f4a3087a0346	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	3.5.4	\N	\N	0640224227
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2021-01-14 16:03:47.065369	63	EXECUTED	7:14d407c35bc4fe1976867756bcea0c36	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	0640224227
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2021-01-14 16:03:47.076164	64	EXECUTED	7:241a8030c748c8548e346adee548fa93	update tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	0640224227
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2021-01-14 16:03:47.090572	65	EXECUTED	7:7d3182f65a34fcc61e8d23def037dc3f	update tableName=RESOURCE_SERVER_RESOURCE		\N	3.5.4	\N	\N	0640224227
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2021-01-14 16:03:47.121464	66	EXECUTED	7:b30039e00a0b9715d430d1b0636728fa	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	3.5.4	\N	\N	0640224227
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2021-01-14 16:03:47.134838	67	EXECUTED	7:3797315ca61d531780f8e6f82f258159	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	3.5.4	\N	\N	0640224227
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2021-01-14 16:03:47.144214	68	EXECUTED	7:c7aa4c8d9573500c2d347c1941ff0301	addColumn tableName=REALM		\N	3.5.4	\N	\N	0640224227
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2021-01-14 16:03:47.168092	69	EXECUTED	7:b207faee394fc074a442ecd42185a5dd	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	3.5.4	\N	\N	0640224227
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2021-01-14 16:03:47.179617	70	EXECUTED	7:ab9a9762faaba4ddfa35514b212c4922	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	3.5.4	\N	\N	0640224227
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2021-01-14 16:03:47.188278	71	EXECUTED	7:b9710f74515a6ccb51b72dc0d19df8c4	addColumn tableName=RESOURCE_SERVER		\N	3.5.4	\N	\N	0640224227
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-01-14 16:03:47.199739	72	EXECUTED	7:ec9707ae4d4f0b7452fee20128083879	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	0640224227
8.0.0-updating-credential-data-not-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-01-14 16:03:47.206694	73	EXECUTED	7:03b3f4b264c3c68ba082250a80b74216	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	0640224227
8.0.0-updating-credential-data-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-01-14 16:03:47.209142	74	MARK_RAN	7:64c5728f5ca1f5aa4392217701c4fe23	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	0640224227
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-01-14 16:03:47.232589	75	EXECUTED	7:b48da8c11a3d83ddd6b7d0c8c2219345	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	3.5.4	\N	\N	0640224227
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-01-14 16:03:47.241785	76	EXECUTED	7:a73379915c23bfad3e8f5c6d5c0aa4bd	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	3.5.4	\N	\N	0640224227
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-01-14 16:03:47.245614	77	EXECUTED	7:39e0073779aba192646291aa2332493d	addColumn tableName=CLIENT		\N	3.5.4	\N	\N	0640224227
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-01-14 16:03:47.24744	78	MARK_RAN	7:81f87368f00450799b4bf42ea0b3ec34	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	3.5.4	\N	\N	0640224227
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-01-14 16:03:47.267859	79	EXECUTED	7:20b37422abb9fb6571c618148f013a15	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	3.5.4	\N	\N	0640224227
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-01-14 16:03:47.270561	80	MARK_RAN	7:1970bb6cfb5ee800736b95ad3fb3c78a	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	3.5.4	\N	\N	0640224227
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-01-14 16:03:47.279302	81	EXECUTED	7:45d9b25fc3b455d522d8dcc10a0f4c80	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	3.5.4	\N	\N	0640224227
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-01-14 16:03:47.28138	82	MARK_RAN	7:890ae73712bc187a66c2813a724d037f	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	0640224227
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-01-14 16:03:47.285184	83	EXECUTED	7:0a211980d27fafe3ff50d19a3a29b538	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	0640224227
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-01-14 16:03:47.287087	84	MARK_RAN	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	0640224227
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-01-14 16:03:47.296089	85	EXECUTED	7:01c49302201bdf815b0a18d1f98a55dc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	0640224227
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2021-01-14 16:03:47.301424	86	EXECUTED	7:3dace6b144c11f53f1ad2c0361279b86	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	3.5.4	\N	\N	0640224227
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-01-14 16:03:47.307474	87	EXECUTED	7:578d0b92077eaf2ab95ad0ec087aa903	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	3.5.4	\N	\N	0640224227
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-01-14 16:03:47.32168	88	EXECUTED	7:c95abe90d962c57a09ecaee57972835d	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	3.5.4	\N	\N	0640224227
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
master	f1718f41-d77f-4fea-a7de-2894d410fc4b	f
master	7b31029f-ebf4-411f-b95a-2d7cd623af10	t
master	8f3b7070-77de-435f-b22f-c63336a78288	t
master	783af926-7768-4e30-9318-944d7d91b3c1	t
master	8367c2a1-34de-4136-9494-44766510b6e2	f
master	3a5a922c-30bb-4307-af28-4c3b946a9aa3	f
master	cb76699f-3016-49a6-98a3-965bcfb2ab4c	t
master	e457070d-299a-426b-b12b-e6c59ca987c4	t
master	bc587d26-8368-4e0c-995d-d55570b1db85	f
myrealm	b895192c-855c-4f46-9a58-ff414aec081d	f
myrealm	4f8788a5-161c-43b7-b874-f93066cd7b06	t
myrealm	2a84a550-2741-4334-b5f6-e207ce547e19	t
myrealm	a9a31276-2278-4642-a35c-768c9e8c4658	t
myrealm	0a96c09f-a5bf-4951-88b0-1398a64b014d	f
myrealm	e8e55942-e9cc-4649-8a26-ecd1baddfb92	f
myrealm	62dab34d-f7c3-4609-81e8-468cb22cb7ed	t
myrealm	c75c2eba-8a83-4868-89b8-b75cf8f3442d	t
myrealm	829e508d-b8ed-4e41-8f27-2b4cfb8fa631	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
1a52bda7-af1f-4bca-87fb-ba9d75020c99	x-hasura-default-role	user	4247cecd-8db8-4c19-ad1d-4bc7fb949812
dd9dbf96-daca-4b06-aa53-f0eb03444d4d	x-hasura-allowed-roles	["user"]	4247cecd-8db8-4c19-ad1d-4bc7fb949812
1ff863ef-4ace-43aa-819c-35f48f4c0c97	x-hasura-role	user	4247cecd-8db8-4c19-ad1d-4bc7fb949812
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
4247cecd-8db8-4c19-ad1d-4bc7fb949812	webapp-user	 	myrealm
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
657756a2-0e23-407e-8b97-d443caa9a2c4	master	f	${role_admin}	admin	master	\N	master
4f48c6c9-422b-4b84-b2f9-5a75b338c062	master	f	${role_create-realm}	create-realm	master	\N	master
f6e11fee-30f9-4518-9b4d-da080b90521e	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_create-client}	create-client	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
4842011e-4bb6-4e92-b121-ac5a8a7335d6	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-realm}	view-realm	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
bf939a01-cf8c-4cc3-b812-aabef18c57e9	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-users}	view-users	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
264bc5b9-ab66-4bed-8034-9ef3ac84b6b0	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-clients}	view-clients	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
828eb57a-e7a0-4b1c-ab9e-bc5d4b48d2a6	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-events}	view-events	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
12bdfa43-2d71-48dd-91b5-ac7993f33e7a	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-identity-providers}	view-identity-providers	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
2162592f-da33-494f-8da2-132e397b16d9	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_view-authorization}	view-authorization	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
437f76bb-114d-4ca1-9e3b-031628013d1b	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-realm}	manage-realm	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
f2895f5f-34d5-4a0f-9be3-a3c2976c60a4	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-users}	manage-users	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
40e509af-f484-4f62-affe-ce3635a02e5b	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-clients}	manage-clients	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
3bfb6313-0daf-4daf-9cac-e952e5ddde5f	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-events}	manage-events	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
5b8e2074-037d-49da-9e8f-8eee7061ebab	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-identity-providers}	manage-identity-providers	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
80e388a0-9e53-4379-b0e5-b2d5117dd451	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_manage-authorization}	manage-authorization	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
3f63352a-1d06-44d5-929a-98aec4435082	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_query-users}	query-users	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
31cf7fc3-ea27-4f0f-b145-1f748d69fb89	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_query-clients}	query-clients	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
8ffbd3b0-62e9-4d43-9103-6fbd66a0abbe	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_query-realms}	query-realms	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
a7cfe7c9-e3bf-4b33-84e7-98cd8e3f6d44	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_query-groups}	query-groups	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
09be7933-8986-4f12-a6e9-9a53ae4e8d6c	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_view-profile}	view-profile	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
553c721f-6964-47fd-ae7e-fbb44b655c19	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_manage-account}	manage-account	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
266ebcaa-6337-4de6-ab01-7b7d990e16f6	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_manage-account-links}	manage-account-links	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
92ff4ddf-01b4-42ca-b617-388f52130fb9	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_view-applications}	view-applications	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
69a91843-a18b-40b9-b38c-74a95914ee01	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_view-consent}	view-consent	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
f3fc44a7-1b58-4312-8cab-077fa472f015	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_manage-consent}	manage-consent	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
15898590-c56c-4b58-b13d-5e1a4a3682da	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	t	${role_delete-account}	delete-account	master	ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	\N
60a48235-e28e-43c4-a2c0-613d7a49f7f9	fd4a20e2-32a0-4e6f-a037-9d515fdf737b	t	${role_read-token}	read-token	master	fd4a20e2-32a0-4e6f-a037-9d515fdf737b	\N
eda21b5c-cc8b-4c4b-9f68-889dafefe5a6	2f201371-1f6c-4771-bbad-6f14baebcd30	t	${role_impersonation}	impersonation	master	2f201371-1f6c-4771-bbad-6f14baebcd30	\N
79a285b0-74a5-4d1c-b72a-d564e4c263b0	master	f	${role_offline-access}	offline_access	master	\N	master
b4c4bc58-9237-431b-bc1a-df8b9b85b8b8	master	f	${role_uma_authorization}	uma_authorization	master	\N	master
d62690b1-9a0b-4f7e-bac7-63edea982903	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_create-client}	create-client	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
9cf28495-c31f-4755-b9e6-20912db99c44	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-realm}	view-realm	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
fb4c8218-eabe-4ac0-a2a8-e2a57bc6968d	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-users}	view-users	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
8f39f82b-4547-4be8-aa58-4182cd125094	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-clients}	view-clients	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
8bc7efc5-383a-4610-bba6-2071a069f0aa	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-events}	view-events	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
3e29a50d-cf59-4d78-9761-887de4430bda	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-identity-providers}	view-identity-providers	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
ec28b78a-3ec3-451e-91b4-dbeb39f69a61	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_view-authorization}	view-authorization	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
7a24db2c-be2b-43ae-9a50-28d93ad82d63	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-realm}	manage-realm	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
43e16715-3458-4aa9-aeec-f31295bad8e9	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-users}	manage-users	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
9985913d-ea35-40ca-b1ed-a211c83df9fc	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-clients}	manage-clients	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
476368be-f7bd-40ea-8003-504a9cb59c8f	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-events}	manage-events	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
2dff7b8e-0aa1-402f-8aa3-633c96ccebad	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-identity-providers}	manage-identity-providers	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
7a99b859-d1ef-434e-bb05-c567b9b10252	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_manage-authorization}	manage-authorization	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
14bcc1bc-4f29-4af4-9e01-5ad77a67898e	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_query-users}	query-users	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
f699ba19-aee2-4f60-bd4e-1d132d07e713	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_query-clients}	query-clients	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
4377c414-f6bf-4e6a-a39b-1c120a9609ad	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_query-realms}	query-realms	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
5285fded-b624-45a9-aee8-4ce94bee214f	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_query-groups}	query-groups	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
14d5bd56-1536-4353-9829-6f3ed21c4ed3	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_realm-admin}	realm-admin	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
af7a0c8e-7457-4f4c-852e-88f03a0ea5b1	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_create-client}	create-client	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
0c146087-c942-4778-84f7-30ab179fb67c	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-realm}	view-realm	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
c21b44c4-b451-43d2-9bd6-a8a9b50ed0aa	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-users}	view-users	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
b8b22f24-6fc2-4bac-9b8f-06eefdbc63f6	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-clients}	view-clients	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
e9b3c52a-e888-4126-86a5-a78f4a125d74	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-events}	view-events	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
d7d8dcf5-447f-40e4-ac64-554d25698321	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-identity-providers}	view-identity-providers	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
d9e6c2f6-56ca-430b-9775-b25d45929193	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_view-authorization}	view-authorization	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
e426d9ff-b9de-4f06-a2c0-d67acbbc794c	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-realm}	manage-realm	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
d366d009-09b1-4cdb-8731-18ec3ef6907d	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-users}	manage-users	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
a0a2fd59-a75e-4cf8-8988-d1d4eab43327	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-clients}	manage-clients	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
5485881d-d3e6-4621-97d3-df9b6d99b475	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-events}	manage-events	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
b433bc7d-7333-4ef9-bc11-2e8848dca465	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-identity-providers}	manage-identity-providers	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
5f576acc-b6ef-4805-ab78-7f36e93e2c52	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_manage-authorization}	manage-authorization	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
fb373570-aed8-49af-a5e2-3610382c7c31	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_query-users}	query-users	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
f9b7e731-38b9-4dfa-8ded-23a47a6d41b7	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_query-clients}	query-clients	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
96d5bdb1-cb7d-47e5-a625-388b25f189f5	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_query-realms}	query-realms	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
fc2ff585-7417-40ab-b32e-b2dadbf8e70b	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_query-groups}	query-groups	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
147c0888-de85-44f6-9612-76432590202f	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_view-profile}	view-profile	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
a854fd93-763d-440f-8bc5-cda240a787d9	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_manage-account}	manage-account	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
bed5d6ff-cfbc-49ca-b3ac-c1a8e30501eb	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_manage-account-links}	manage-account-links	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
5840495f-553d-4ed1-af1e-2aab77ed27a0	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_view-applications}	view-applications	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
d4fc803f-4d38-4c64-9ac5-db60b259090a	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_view-consent}	view-consent	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
71d2e144-0ff8-4515-b953-707645e01ea6	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_manage-consent}	manage-consent	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
d02ddd15-231a-405a-9f14-fcc3c51e82a4	723b4775-6ec2-44ff-9adf-01102831b159	t	${role_delete-account}	delete-account	myrealm	723b4775-6ec2-44ff-9adf-01102831b159	\N
386ea9d5-a32c-4352-85fe-e19972fb5bfc	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	t	${role_impersonation}	impersonation	master	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	\N
9f47afdc-b74f-4b7f-ad0c-f071524417ff	a9b587ea-5048-46f6-8ccd-64c77758ce6f	t	${role_impersonation}	impersonation	myrealm	a9b587ea-5048-46f6-8ccd-64c77758ce6f	\N
a59a9880-e077-4cc4-84f4-13bb3aa50f46	3e44a660-3d19-4571-8887-c5df27db78ba	t	${role_read-token}	read-token	myrealm	3e44a660-3d19-4571-8887-c5df27db78ba	\N
f307ed86-64d1-4a2e-9102-fa7b08fcabd1	myrealm	f	${role_offline-access}	offline_access	myrealm	\N	myrealm
bb2e247c-de9d-4973-9ed7-d3008c8abdbd	myrealm	f	${role_uma_authorization}	uma_authorization	myrealm	\N	myrealm
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
cdh72	12.0.1	1610640228
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
67ff428c-3fb2-4371-91a3-38e64061d1e6	audience resolve	openid-connect	oidc-audience-resolve-mapper	039edccc-f22b-4c35-afa7-06aa26f6d1b6	\N
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	locale	openid-connect	oidc-usermodel-attribute-mapper	1d762543-1e89-4e78-af2e-02c1e56b0ba0	\N
bffd531c-9d4b-47d3-97da-fa22de9812a9	role list	saml	saml-role-list-mapper	\N	7b31029f-ebf4-411f-b95a-2d7cd623af10
c9c89e9b-dd44-48d9-b5dd-6f380deaaa72	full name	openid-connect	oidc-full-name-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
55e45643-dc1e-40c6-94f1-9f858fc52617	family name	openid-connect	oidc-usermodel-property-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	given name	openid-connect	oidc-usermodel-property-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
7586e379-093f-4a25-85fc-3aae18d19f89	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
70ddcf77-0198-4721-95f9-bd3936aaf92a	username	openid-connect	oidc-usermodel-property-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
1e403ada-e105-4c9a-9dfd-97bbe02fa240	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
8f84600e-b732-4fff-a4c3-b55ac1894d88	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
dbd5ec09-89eb-44ac-b93b-bb0135224f68	website	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
849b8936-833b-4ea2-ab2f-778a78608892	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
36612daa-55a2-4e2f-9a1c-1bf095065f89	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
d7bbcabb-a29e-4a11-9820-6ce642358237	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
e104ab7c-5977-4e19-af0e-807f56f1aaed	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	8f3b7070-77de-435f-b22f-c63336a78288
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	email	openid-connect	oidc-usermodel-property-mapper	\N	783af926-7768-4e30-9318-944d7d91b3c1
db7a7bcd-313f-4743-9162-41c3a96014ec	email verified	openid-connect	oidc-usermodel-property-mapper	\N	783af926-7768-4e30-9318-944d7d91b3c1
6f2d70df-7bdc-416a-a060-46ffb7fe5093	address	openid-connect	oidc-address-mapper	\N	8367c2a1-34de-4136-9494-44766510b6e2
131578a9-3847-4131-8b52-3d03aa539cb1	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	3a5a922c-30bb-4307-af28-4c3b946a9aa3
a2be6384-752b-4a0d-8a95-052ebca0983e	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	3a5a922c-30bb-4307-af28-4c3b946a9aa3
13b364d4-976c-4b74-9c5a-a55a74e3555e	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	cb76699f-3016-49a6-98a3-965bcfb2ab4c
c9916a4a-b652-414b-8d83-3beea3b5dc38	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	cb76699f-3016-49a6-98a3-965bcfb2ab4c
f3403792-541f-4e50-a5ef-48d2d6c3028b	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	cb76699f-3016-49a6-98a3-965bcfb2ab4c
f1db9c6e-f0e1-4cdc-a86d-396c4b2a4729	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	e457070d-299a-426b-b12b-e6c59ca987c4
2bbe985f-e47e-4780-b922-9cfd1dce60ab	upn	openid-connect	oidc-usermodel-property-mapper	\N	bc587d26-8368-4e0c-995d-d55570b1db85
ace4d5f1-b513-4d95-b04d-70472e580e8b	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	bc587d26-8368-4e0c-995d-d55570b1db85
d7e4a6a9-51c4-4c24-bf62-0911958838d2	audience resolve	openid-connect	oidc-audience-resolve-mapper	a05b5e3d-05d3-4ee4-8581-ffb84a67a275	\N
ee31f264-76fe-4538-8bab-77e01a0afa31	role list	saml	saml-role-list-mapper	\N	4f8788a5-161c-43b7-b874-f93066cd7b06
ec4636a4-cea0-459d-9ecf-b4f508cc087a	full name	openid-connect	oidc-full-name-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	family name	openid-connect	oidc-usermodel-property-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
7a7f79a2-f919-48e6-a773-45bbddf28ad3	given name	openid-connect	oidc-usermodel-property-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
6c72c724-e334-439e-82b4-980b350a9706	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
e6764c4d-4266-47d1-b0ce-e1c857e4891d	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
9d29d81d-df64-426f-89b8-31167ea132b6	username	openid-connect	oidc-usermodel-property-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	website	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
651f739d-e776-4cc8-9bfa-72c85d867012	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
d369c45a-f656-4690-95ae-1a7001e4a5d3	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
7a7fa822-640f-4e5f-b188-8ace8220f8cc	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	2a84a550-2741-4334-b5f6-e207ce547e19
c481f5d2-9164-47a4-a8ab-c47ab2a84628	email	openid-connect	oidc-usermodel-property-mapper	\N	a9a31276-2278-4642-a35c-768c9e8c4658
c6b4e69f-35b0-488d-9604-befc0b1656d6	email verified	openid-connect	oidc-usermodel-property-mapper	\N	a9a31276-2278-4642-a35c-768c9e8c4658
cd33de06-3c1a-413d-927f-b8979156040f	address	openid-connect	oidc-address-mapper	\N	0a96c09f-a5bf-4951-88b0-1398a64b014d
f4776660-8fbb-4304-b96b-8311a4298581	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	e8e55942-e9cc-4649-8a26-ecd1baddfb92
81e051db-d967-4276-b7c8-7db0ee7c778f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	e8e55942-e9cc-4649-8a26-ecd1baddfb92
fe6f4e6e-57c9-48cb-9344-e98b1632931d	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	62dab34d-f7c3-4609-81e8-468cb22cb7ed
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	62dab34d-f7c3-4609-81e8-468cb22cb7ed
ffc2cfc3-730a-46d8-9038-0bbf3c6f47c2	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	62dab34d-f7c3-4609-81e8-468cb22cb7ed
b8b29df3-3290-4a7d-abba-116851691a8e	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	c75c2eba-8a83-4868-89b8-b75cf8f3442d
dfb6f530-6a6f-444c-b345-6a41b35c905f	upn	openid-connect	oidc-usermodel-property-mapper	\N	829e508d-b8ed-4e41-8f27-2b4cfb8fa631
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	829e508d-b8ed-4e41-8f27-2b4cfb8fa631
59f9f3c2-6405-4180-b33a-9d72363f2941	locale	openid-connect	oidc-usermodel-attribute-mapper	324dcc7d-4bef-4361-abbd-eb0dda84aed6	\N
480c1928-1d09-465a-943a-6081dc09e367	x-hasura-default-role	openid-connect	oidc-usermodel-attribute-mapper	76f65bf9-3b38-4021-bd64-8119d10e1b8e	\N
34d72e70-2e99-48dc-ad33-39f5689f03e4	x-hasura-allowed-roles	openid-connect	oidc-usermodel-attribute-mapper	76f65bf9-3b38-4021-bd64-8119d10e1b8e	\N
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	x-hasura-role	openid-connect	oidc-usermodel-attribute-mapper	76f65bf9-3b38-4021-bd64-8119d10e1b8e	\N
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	x-hasura-user-id	openid-connect	oidc-usermodel-property-mapper	76f65bf9-3b38-4021-bd64-8119d10e1b8e	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	true	userinfo.token.claim
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	locale	user.attribute
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	true	id.token.claim
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	true	access.token.claim
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	locale	claim.name
c675489d-a4b5-44d1-ace0-9bd7dfcf5192	String	jsonType.label
bffd531c-9d4b-47d3-97da-fa22de9812a9	false	single
bffd531c-9d4b-47d3-97da-fa22de9812a9	Basic	attribute.nameformat
bffd531c-9d4b-47d3-97da-fa22de9812a9	Role	attribute.name
c9c89e9b-dd44-48d9-b5dd-6f380deaaa72	true	userinfo.token.claim
c9c89e9b-dd44-48d9-b5dd-6f380deaaa72	true	id.token.claim
c9c89e9b-dd44-48d9-b5dd-6f380deaaa72	true	access.token.claim
55e45643-dc1e-40c6-94f1-9f858fc52617	true	userinfo.token.claim
55e45643-dc1e-40c6-94f1-9f858fc52617	lastName	user.attribute
55e45643-dc1e-40c6-94f1-9f858fc52617	true	id.token.claim
55e45643-dc1e-40c6-94f1-9f858fc52617	true	access.token.claim
55e45643-dc1e-40c6-94f1-9f858fc52617	family_name	claim.name
55e45643-dc1e-40c6-94f1-9f858fc52617	String	jsonType.label
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	true	userinfo.token.claim
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	firstName	user.attribute
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	true	id.token.claim
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	true	access.token.claim
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	given_name	claim.name
b02e4fd2-f62a-412d-8075-5c2b51eee9bb	String	jsonType.label
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	true	userinfo.token.claim
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	middleName	user.attribute
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	true	id.token.claim
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	true	access.token.claim
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	middle_name	claim.name
3dba5ae2-2178-4ff6-a506-b2dd3de6eaa2	String	jsonType.label
7586e379-093f-4a25-85fc-3aae18d19f89	true	userinfo.token.claim
7586e379-093f-4a25-85fc-3aae18d19f89	nickname	user.attribute
7586e379-093f-4a25-85fc-3aae18d19f89	true	id.token.claim
7586e379-093f-4a25-85fc-3aae18d19f89	true	access.token.claim
7586e379-093f-4a25-85fc-3aae18d19f89	nickname	claim.name
7586e379-093f-4a25-85fc-3aae18d19f89	String	jsonType.label
70ddcf77-0198-4721-95f9-bd3936aaf92a	true	userinfo.token.claim
70ddcf77-0198-4721-95f9-bd3936aaf92a	username	user.attribute
70ddcf77-0198-4721-95f9-bd3936aaf92a	true	id.token.claim
70ddcf77-0198-4721-95f9-bd3936aaf92a	true	access.token.claim
70ddcf77-0198-4721-95f9-bd3936aaf92a	preferred_username	claim.name
70ddcf77-0198-4721-95f9-bd3936aaf92a	String	jsonType.label
1e403ada-e105-4c9a-9dfd-97bbe02fa240	true	userinfo.token.claim
1e403ada-e105-4c9a-9dfd-97bbe02fa240	profile	user.attribute
1e403ada-e105-4c9a-9dfd-97bbe02fa240	true	id.token.claim
1e403ada-e105-4c9a-9dfd-97bbe02fa240	true	access.token.claim
1e403ada-e105-4c9a-9dfd-97bbe02fa240	profile	claim.name
1e403ada-e105-4c9a-9dfd-97bbe02fa240	String	jsonType.label
8f84600e-b732-4fff-a4c3-b55ac1894d88	true	userinfo.token.claim
8f84600e-b732-4fff-a4c3-b55ac1894d88	picture	user.attribute
8f84600e-b732-4fff-a4c3-b55ac1894d88	true	id.token.claim
8f84600e-b732-4fff-a4c3-b55ac1894d88	true	access.token.claim
8f84600e-b732-4fff-a4c3-b55ac1894d88	picture	claim.name
8f84600e-b732-4fff-a4c3-b55ac1894d88	String	jsonType.label
dbd5ec09-89eb-44ac-b93b-bb0135224f68	true	userinfo.token.claim
dbd5ec09-89eb-44ac-b93b-bb0135224f68	website	user.attribute
dbd5ec09-89eb-44ac-b93b-bb0135224f68	true	id.token.claim
dbd5ec09-89eb-44ac-b93b-bb0135224f68	true	access.token.claim
dbd5ec09-89eb-44ac-b93b-bb0135224f68	website	claim.name
dbd5ec09-89eb-44ac-b93b-bb0135224f68	String	jsonType.label
849b8936-833b-4ea2-ab2f-778a78608892	true	userinfo.token.claim
849b8936-833b-4ea2-ab2f-778a78608892	gender	user.attribute
849b8936-833b-4ea2-ab2f-778a78608892	true	id.token.claim
849b8936-833b-4ea2-ab2f-778a78608892	true	access.token.claim
849b8936-833b-4ea2-ab2f-778a78608892	gender	claim.name
849b8936-833b-4ea2-ab2f-778a78608892	String	jsonType.label
36612daa-55a2-4e2f-9a1c-1bf095065f89	true	userinfo.token.claim
36612daa-55a2-4e2f-9a1c-1bf095065f89	birthdate	user.attribute
36612daa-55a2-4e2f-9a1c-1bf095065f89	true	id.token.claim
36612daa-55a2-4e2f-9a1c-1bf095065f89	true	access.token.claim
36612daa-55a2-4e2f-9a1c-1bf095065f89	birthdate	claim.name
36612daa-55a2-4e2f-9a1c-1bf095065f89	String	jsonType.label
d7bbcabb-a29e-4a11-9820-6ce642358237	true	userinfo.token.claim
d7bbcabb-a29e-4a11-9820-6ce642358237	zoneinfo	user.attribute
d7bbcabb-a29e-4a11-9820-6ce642358237	true	id.token.claim
d7bbcabb-a29e-4a11-9820-6ce642358237	true	access.token.claim
d7bbcabb-a29e-4a11-9820-6ce642358237	zoneinfo	claim.name
d7bbcabb-a29e-4a11-9820-6ce642358237	String	jsonType.label
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	true	userinfo.token.claim
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	locale	user.attribute
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	true	id.token.claim
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	true	access.token.claim
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	locale	claim.name
8a067d30-70fd-4822-9f9d-4f0d5db7edd4	String	jsonType.label
e104ab7c-5977-4e19-af0e-807f56f1aaed	true	userinfo.token.claim
e104ab7c-5977-4e19-af0e-807f56f1aaed	updatedAt	user.attribute
e104ab7c-5977-4e19-af0e-807f56f1aaed	true	id.token.claim
e104ab7c-5977-4e19-af0e-807f56f1aaed	true	access.token.claim
e104ab7c-5977-4e19-af0e-807f56f1aaed	updated_at	claim.name
e104ab7c-5977-4e19-af0e-807f56f1aaed	String	jsonType.label
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	true	userinfo.token.claim
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	email	user.attribute
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	true	id.token.claim
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	true	access.token.claim
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	email	claim.name
79f2a568-df8f-420f-9bb4-a7d3dbf9f89f	String	jsonType.label
db7a7bcd-313f-4743-9162-41c3a96014ec	true	userinfo.token.claim
db7a7bcd-313f-4743-9162-41c3a96014ec	emailVerified	user.attribute
db7a7bcd-313f-4743-9162-41c3a96014ec	true	id.token.claim
db7a7bcd-313f-4743-9162-41c3a96014ec	true	access.token.claim
db7a7bcd-313f-4743-9162-41c3a96014ec	email_verified	claim.name
db7a7bcd-313f-4743-9162-41c3a96014ec	boolean	jsonType.label
6f2d70df-7bdc-416a-a060-46ffb7fe5093	formatted	user.attribute.formatted
6f2d70df-7bdc-416a-a060-46ffb7fe5093	country	user.attribute.country
6f2d70df-7bdc-416a-a060-46ffb7fe5093	postal_code	user.attribute.postal_code
6f2d70df-7bdc-416a-a060-46ffb7fe5093	true	userinfo.token.claim
6f2d70df-7bdc-416a-a060-46ffb7fe5093	street	user.attribute.street
6f2d70df-7bdc-416a-a060-46ffb7fe5093	true	id.token.claim
6f2d70df-7bdc-416a-a060-46ffb7fe5093	region	user.attribute.region
6f2d70df-7bdc-416a-a060-46ffb7fe5093	true	access.token.claim
6f2d70df-7bdc-416a-a060-46ffb7fe5093	locality	user.attribute.locality
131578a9-3847-4131-8b52-3d03aa539cb1	true	userinfo.token.claim
131578a9-3847-4131-8b52-3d03aa539cb1	phoneNumber	user.attribute
131578a9-3847-4131-8b52-3d03aa539cb1	true	id.token.claim
131578a9-3847-4131-8b52-3d03aa539cb1	true	access.token.claim
131578a9-3847-4131-8b52-3d03aa539cb1	phone_number	claim.name
131578a9-3847-4131-8b52-3d03aa539cb1	String	jsonType.label
a2be6384-752b-4a0d-8a95-052ebca0983e	true	userinfo.token.claim
a2be6384-752b-4a0d-8a95-052ebca0983e	phoneNumberVerified	user.attribute
a2be6384-752b-4a0d-8a95-052ebca0983e	true	id.token.claim
a2be6384-752b-4a0d-8a95-052ebca0983e	true	access.token.claim
a2be6384-752b-4a0d-8a95-052ebca0983e	phone_number_verified	claim.name
a2be6384-752b-4a0d-8a95-052ebca0983e	boolean	jsonType.label
13b364d4-976c-4b74-9c5a-a55a74e3555e	true	multivalued
13b364d4-976c-4b74-9c5a-a55a74e3555e	foo	user.attribute
13b364d4-976c-4b74-9c5a-a55a74e3555e	true	access.token.claim
13b364d4-976c-4b74-9c5a-a55a74e3555e	realm_access.roles	claim.name
13b364d4-976c-4b74-9c5a-a55a74e3555e	String	jsonType.label
c9916a4a-b652-414b-8d83-3beea3b5dc38	true	multivalued
c9916a4a-b652-414b-8d83-3beea3b5dc38	foo	user.attribute
c9916a4a-b652-414b-8d83-3beea3b5dc38	true	access.token.claim
c9916a4a-b652-414b-8d83-3beea3b5dc38	resource_access.${client_id}.roles	claim.name
c9916a4a-b652-414b-8d83-3beea3b5dc38	String	jsonType.label
2bbe985f-e47e-4780-b922-9cfd1dce60ab	true	userinfo.token.claim
2bbe985f-e47e-4780-b922-9cfd1dce60ab	username	user.attribute
2bbe985f-e47e-4780-b922-9cfd1dce60ab	true	id.token.claim
2bbe985f-e47e-4780-b922-9cfd1dce60ab	true	access.token.claim
2bbe985f-e47e-4780-b922-9cfd1dce60ab	upn	claim.name
2bbe985f-e47e-4780-b922-9cfd1dce60ab	String	jsonType.label
ace4d5f1-b513-4d95-b04d-70472e580e8b	true	multivalued
ace4d5f1-b513-4d95-b04d-70472e580e8b	foo	user.attribute
ace4d5f1-b513-4d95-b04d-70472e580e8b	true	id.token.claim
ace4d5f1-b513-4d95-b04d-70472e580e8b	true	access.token.claim
ace4d5f1-b513-4d95-b04d-70472e580e8b	groups	claim.name
ace4d5f1-b513-4d95-b04d-70472e580e8b	String	jsonType.label
ee31f264-76fe-4538-8bab-77e01a0afa31	false	single
ee31f264-76fe-4538-8bab-77e01a0afa31	Basic	attribute.nameformat
ee31f264-76fe-4538-8bab-77e01a0afa31	Role	attribute.name
ec4636a4-cea0-459d-9ecf-b4f508cc087a	true	userinfo.token.claim
ec4636a4-cea0-459d-9ecf-b4f508cc087a	true	id.token.claim
ec4636a4-cea0-459d-9ecf-b4f508cc087a	true	access.token.claim
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	true	userinfo.token.claim
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	lastName	user.attribute
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	true	id.token.claim
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	true	access.token.claim
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	family_name	claim.name
d94e1e34-fdd6-4028-96a8-4a53c0d1218c	String	jsonType.label
7a7f79a2-f919-48e6-a773-45bbddf28ad3	true	userinfo.token.claim
7a7f79a2-f919-48e6-a773-45bbddf28ad3	firstName	user.attribute
7a7f79a2-f919-48e6-a773-45bbddf28ad3	true	id.token.claim
7a7f79a2-f919-48e6-a773-45bbddf28ad3	true	access.token.claim
7a7f79a2-f919-48e6-a773-45bbddf28ad3	given_name	claim.name
7a7f79a2-f919-48e6-a773-45bbddf28ad3	String	jsonType.label
6c72c724-e334-439e-82b4-980b350a9706	true	userinfo.token.claim
6c72c724-e334-439e-82b4-980b350a9706	middleName	user.attribute
6c72c724-e334-439e-82b4-980b350a9706	true	id.token.claim
6c72c724-e334-439e-82b4-980b350a9706	true	access.token.claim
6c72c724-e334-439e-82b4-980b350a9706	middle_name	claim.name
6c72c724-e334-439e-82b4-980b350a9706	String	jsonType.label
e6764c4d-4266-47d1-b0ce-e1c857e4891d	true	userinfo.token.claim
e6764c4d-4266-47d1-b0ce-e1c857e4891d	nickname	user.attribute
e6764c4d-4266-47d1-b0ce-e1c857e4891d	true	id.token.claim
e6764c4d-4266-47d1-b0ce-e1c857e4891d	true	access.token.claim
e6764c4d-4266-47d1-b0ce-e1c857e4891d	nickname	claim.name
e6764c4d-4266-47d1-b0ce-e1c857e4891d	String	jsonType.label
9d29d81d-df64-426f-89b8-31167ea132b6	true	userinfo.token.claim
9d29d81d-df64-426f-89b8-31167ea132b6	username	user.attribute
9d29d81d-df64-426f-89b8-31167ea132b6	true	id.token.claim
9d29d81d-df64-426f-89b8-31167ea132b6	true	access.token.claim
9d29d81d-df64-426f-89b8-31167ea132b6	preferred_username	claim.name
9d29d81d-df64-426f-89b8-31167ea132b6	String	jsonType.label
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	true	userinfo.token.claim
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	profile	user.attribute
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	true	id.token.claim
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	true	access.token.claim
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	profile	claim.name
ec7c8a9f-ae01-4e01-aaaa-e25aef883be0	String	jsonType.label
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	true	userinfo.token.claim
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	picture	user.attribute
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	true	id.token.claim
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	true	access.token.claim
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	picture	claim.name
c2db26fc-1f90-4b11-b6f5-03a6005ee3ac	String	jsonType.label
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	true	userinfo.token.claim
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	website	user.attribute
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	true	id.token.claim
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	true	access.token.claim
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	website	claim.name
1c0489a4-1605-4a3c-9817-e8c8eb0ac95f	String	jsonType.label
651f739d-e776-4cc8-9bfa-72c85d867012	true	userinfo.token.claim
651f739d-e776-4cc8-9bfa-72c85d867012	gender	user.attribute
651f739d-e776-4cc8-9bfa-72c85d867012	true	id.token.claim
651f739d-e776-4cc8-9bfa-72c85d867012	true	access.token.claim
651f739d-e776-4cc8-9bfa-72c85d867012	gender	claim.name
651f739d-e776-4cc8-9bfa-72c85d867012	String	jsonType.label
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	true	userinfo.token.claim
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	birthdate	user.attribute
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	true	id.token.claim
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	true	access.token.claim
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	birthdate	claim.name
1cd5b0eb-e64c-41b7-b20b-9f5e06abda3f	String	jsonType.label
d369c45a-f656-4690-95ae-1a7001e4a5d3	true	userinfo.token.claim
d369c45a-f656-4690-95ae-1a7001e4a5d3	zoneinfo	user.attribute
d369c45a-f656-4690-95ae-1a7001e4a5d3	true	id.token.claim
d369c45a-f656-4690-95ae-1a7001e4a5d3	true	access.token.claim
d369c45a-f656-4690-95ae-1a7001e4a5d3	zoneinfo	claim.name
d369c45a-f656-4690-95ae-1a7001e4a5d3	String	jsonType.label
7a7fa822-640f-4e5f-b188-8ace8220f8cc	true	userinfo.token.claim
7a7fa822-640f-4e5f-b188-8ace8220f8cc	locale	user.attribute
7a7fa822-640f-4e5f-b188-8ace8220f8cc	true	id.token.claim
7a7fa822-640f-4e5f-b188-8ace8220f8cc	true	access.token.claim
7a7fa822-640f-4e5f-b188-8ace8220f8cc	locale	claim.name
7a7fa822-640f-4e5f-b188-8ace8220f8cc	String	jsonType.label
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	true	userinfo.token.claim
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	updatedAt	user.attribute
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	true	id.token.claim
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	true	access.token.claim
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	updated_at	claim.name
b84d657d-0f1d-45d9-b7dd-7c1b3b906435	String	jsonType.label
c481f5d2-9164-47a4-a8ab-c47ab2a84628	true	userinfo.token.claim
c481f5d2-9164-47a4-a8ab-c47ab2a84628	email	user.attribute
c481f5d2-9164-47a4-a8ab-c47ab2a84628	true	id.token.claim
c481f5d2-9164-47a4-a8ab-c47ab2a84628	true	access.token.claim
c481f5d2-9164-47a4-a8ab-c47ab2a84628	email	claim.name
c481f5d2-9164-47a4-a8ab-c47ab2a84628	String	jsonType.label
c6b4e69f-35b0-488d-9604-befc0b1656d6	true	userinfo.token.claim
c6b4e69f-35b0-488d-9604-befc0b1656d6	emailVerified	user.attribute
c6b4e69f-35b0-488d-9604-befc0b1656d6	true	id.token.claim
c6b4e69f-35b0-488d-9604-befc0b1656d6	true	access.token.claim
c6b4e69f-35b0-488d-9604-befc0b1656d6	email_verified	claim.name
c6b4e69f-35b0-488d-9604-befc0b1656d6	boolean	jsonType.label
cd33de06-3c1a-413d-927f-b8979156040f	formatted	user.attribute.formatted
cd33de06-3c1a-413d-927f-b8979156040f	country	user.attribute.country
cd33de06-3c1a-413d-927f-b8979156040f	postal_code	user.attribute.postal_code
cd33de06-3c1a-413d-927f-b8979156040f	true	userinfo.token.claim
cd33de06-3c1a-413d-927f-b8979156040f	street	user.attribute.street
cd33de06-3c1a-413d-927f-b8979156040f	true	id.token.claim
cd33de06-3c1a-413d-927f-b8979156040f	region	user.attribute.region
cd33de06-3c1a-413d-927f-b8979156040f	true	access.token.claim
cd33de06-3c1a-413d-927f-b8979156040f	locality	user.attribute.locality
f4776660-8fbb-4304-b96b-8311a4298581	true	userinfo.token.claim
f4776660-8fbb-4304-b96b-8311a4298581	phoneNumber	user.attribute
f4776660-8fbb-4304-b96b-8311a4298581	true	id.token.claim
f4776660-8fbb-4304-b96b-8311a4298581	true	access.token.claim
f4776660-8fbb-4304-b96b-8311a4298581	phone_number	claim.name
f4776660-8fbb-4304-b96b-8311a4298581	String	jsonType.label
81e051db-d967-4276-b7c8-7db0ee7c778f	true	userinfo.token.claim
81e051db-d967-4276-b7c8-7db0ee7c778f	phoneNumberVerified	user.attribute
81e051db-d967-4276-b7c8-7db0ee7c778f	true	id.token.claim
81e051db-d967-4276-b7c8-7db0ee7c778f	true	access.token.claim
81e051db-d967-4276-b7c8-7db0ee7c778f	phone_number_verified	claim.name
81e051db-d967-4276-b7c8-7db0ee7c778f	boolean	jsonType.label
fe6f4e6e-57c9-48cb-9344-e98b1632931d	true	multivalued
fe6f4e6e-57c9-48cb-9344-e98b1632931d	foo	user.attribute
fe6f4e6e-57c9-48cb-9344-e98b1632931d	true	access.token.claim
fe6f4e6e-57c9-48cb-9344-e98b1632931d	realm_access.roles	claim.name
fe6f4e6e-57c9-48cb-9344-e98b1632931d	String	jsonType.label
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	true	multivalued
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	foo	user.attribute
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	true	access.token.claim
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	resource_access.${client_id}.roles	claim.name
b3beaf89-a03e-4ba8-86a1-c6ac227cd36f	String	jsonType.label
dfb6f530-6a6f-444c-b345-6a41b35c905f	true	userinfo.token.claim
dfb6f530-6a6f-444c-b345-6a41b35c905f	username	user.attribute
dfb6f530-6a6f-444c-b345-6a41b35c905f	true	id.token.claim
dfb6f530-6a6f-444c-b345-6a41b35c905f	true	access.token.claim
dfb6f530-6a6f-444c-b345-6a41b35c905f	upn	claim.name
dfb6f530-6a6f-444c-b345-6a41b35c905f	String	jsonType.label
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	true	multivalued
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	foo	user.attribute
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	true	id.token.claim
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	true	access.token.claim
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	groups	claim.name
1d50a08c-c7a4-4130-9c2d-76d6d9256e4d	String	jsonType.label
59f9f3c2-6405-4180-b33a-9d72363f2941	true	userinfo.token.claim
59f9f3c2-6405-4180-b33a-9d72363f2941	locale	user.attribute
59f9f3c2-6405-4180-b33a-9d72363f2941	true	id.token.claim
59f9f3c2-6405-4180-b33a-9d72363f2941	true	access.token.claim
59f9f3c2-6405-4180-b33a-9d72363f2941	locale	claim.name
59f9f3c2-6405-4180-b33a-9d72363f2941	String	jsonType.label
480c1928-1d09-465a-943a-6081dc09e367	false	userinfo.token.claim
480c1928-1d09-465a-943a-6081dc09e367	x-hasura-default-role	user.attribute
480c1928-1d09-465a-943a-6081dc09e367	false	id.token.claim
480c1928-1d09-465a-943a-6081dc09e367	true	access.token.claim
480c1928-1d09-465a-943a-6081dc09e367	x-hasura-default-role	claim.name
480c1928-1d09-465a-943a-6081dc09e367	String	jsonType.label
34d72e70-2e99-48dc-ad33-39f5689f03e4	false	userinfo.token.claim
34d72e70-2e99-48dc-ad33-39f5689f03e4	x-hasura-allowed-roles	user.attribute
34d72e70-2e99-48dc-ad33-39f5689f03e4	false	id.token.claim
34d72e70-2e99-48dc-ad33-39f5689f03e4	true	access.token.claim
34d72e70-2e99-48dc-ad33-39f5689f03e4	x-hasura-allowed-roles	claim.name
34d72e70-2e99-48dc-ad33-39f5689f03e4	JSON	jsonType.label
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	false	userinfo.token.claim
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	x-hasura-role	user.attribute
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	false	id.token.claim
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	true	access.token.claim
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	x-hasura-role	claim.name
0fc2f4c2-07ac-49a1-9f52-60d0d19e8c3a	String	jsonType.label
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	false	userinfo.token.claim
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	id	user.attribute
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	false	id.token.claim
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	true	access.token.claim
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	x-hasura-user-id	claim.name
7fd3e5ee-405d-4ee6-9d68-07c79bf140ba	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me) FROM stdin;
master	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	2f201371-1f6c-4771-bbad-6f14baebcd30	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	5278d875-8e3c-447c-a800-92c69a39861c	3e1d180f-9048-4739-beaa-568d671150ae	6df06a3e-5f9a-4d10-b448-bafc931f51bb	fa44e055-256b-49e4-806d-71d73ae7cb70	a4c3f05c-08fa-4e45-b1a8-f42288cf4de2	2592000	f	900	t	f	9a68e0de-1e15-4357-a9e0-927b14b815d5	0	f	0	0
myrealm	60	300	300	keycloak.v2	\N	\N	t	f	0	\N	myrealm	0	\N	t	t	t	f	EXTERNAL	1800	36000	f	t	cf41fabc-a33a-47f6-8a8f-2b5e301d456a	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	98396637-b99d-4601-bf27-3b706452acca	7e7e1f2d-46f6-4ebb-b426-1fc3fcb62b5e	95d4f575-5779-48b1-a606-87cb07f8bede	680de399-b46b-47f0-9a0f-2237c3d3a8c0	d96d0ad2-d2c8-4798-a41e-2940437e2193	2592000	f	900	t	f	62e63545-8eea-4ae7-af31-22eb8ba911a9	0	f	0	0
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, value, realm_id) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly		master
_browser_header.xContentTypeOptions	nosniff	master
_browser_header.xRobotsTag	none	master
_browser_header.xFrameOptions	SAMEORIGIN	master
_browser_header.contentSecurityPolicy	frame-src 'self'; frame-ancestors 'self'; object-src 'none';	master
_browser_header.xXSSProtection	1; mode=block	master
_browser_header.strictTransportSecurity	max-age=31536000; includeSubDomains	master
bruteForceProtected	false	master
permanentLockout	false	master
maxFailureWaitSeconds	900	master
minimumQuickLoginWaitSeconds	60	master
waitIncrementSeconds	60	master
quickLoginCheckMilliSeconds	1000	master
maxDeltaTimeSeconds	43200	master
failureFactor	30	master
displayName	Keycloak	master
displayNameHtml	<div class="kc-logo-text"><span>Keycloak</span></div>	master
offlineSessionMaxLifespanEnabled	false	master
offlineSessionMaxLifespan	5184000	master
clientSessionIdleTimeout	0	myrealm
clientSessionMaxLifespan	0	myrealm
clientOfflineSessionIdleTimeout	0	myrealm
clientOfflineSessionMaxLifespan	0	myrealm
displayName	LT Webapp	myrealm
displayNameHtml	LT Webapp	myrealm
bruteForceProtected	false	myrealm
permanentLockout	false	myrealm
maxFailureWaitSeconds	900	myrealm
minimumQuickLoginWaitSeconds	60	myrealm
waitIncrementSeconds	60	myrealm
quickLoginCheckMilliSeconds	1000	myrealm
maxDeltaTimeSeconds	43200	myrealm
failureFactor	30	myrealm
actionTokenGeneratedByAdminLifespan	43200	myrealm
actionTokenGeneratedByUserLifespan	300	myrealm
offlineSessionMaxLifespanEnabled	false	myrealm
offlineSessionMaxLifespan	5184000	myrealm
webAuthnPolicyRpEntityName	keycloak	myrealm
webAuthnPolicySignatureAlgorithms	ES256	myrealm
webAuthnPolicyRpId		myrealm
webAuthnPolicyAttestationConveyancePreference	not specified	myrealm
webAuthnPolicyAuthenticatorAttachment	not specified	myrealm
webAuthnPolicyRequireResidentKey	not specified	myrealm
webAuthnPolicyUserVerificationRequirement	not specified	myrealm
webAuthnPolicyCreateTimeout	0	myrealm
webAuthnPolicyAvoidSameAuthenticatorRegister	false	myrealm
webAuthnPolicyRpEntityNamePasswordless	keycloak	myrealm
webAuthnPolicySignatureAlgorithmsPasswordless	ES256	myrealm
webAuthnPolicyRpIdPasswordless		myrealm
webAuthnPolicyAttestationConveyancePreferencePasswordless	not specified	myrealm
webAuthnPolicyAuthenticatorAttachmentPasswordless	not specified	myrealm
webAuthnPolicyRequireResidentKeyPasswordless	not specified	myrealm
webAuthnPolicyUserVerificationRequirementPasswordless	not specified	myrealm
webAuthnPolicyCreateTimeoutPasswordless	0	myrealm
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	false	myrealm
_browser_header.contentSecurityPolicyReportOnly		myrealm
_browser_header.xContentTypeOptions	nosniff	myrealm
_browser_header.xRobotsTag	none	myrealm
_browser_header.xFrameOptions	SAMEORIGIN	myrealm
_browser_header.contentSecurityPolicy	frame-src 'self'; frame-ancestors 'self'; object-src 'none';	myrealm
_browser_header.xXSSProtection	1; mode=block	myrealm
_browser_header.strictTransportSecurity	max-age=31536000; includeSubDomains	myrealm
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
myrealm	4247cecd-8db8-4c19-ad1d-4bc7fb949812
\.


--
-- Data for Name: realm_default_roles; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_roles (realm_id, role_id) FROM stdin;
master	79a285b0-74a5-4d1c-b72a-d564e4c263b0
master	b4c4bc58-9237-431b-bc1a-df8b9b85b8b8
myrealm	f307ed86-64d1-4a2e-9102-fa7b08fcabd1
myrealm	bb2e247c-de9d-4973-9ed7-d3008c8abdbd
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
myrealm	UPDATE_CONSENT_ERROR
myrealm	SEND_RESET_PASSWORD
myrealm	GRANT_CONSENT
myrealm	UPDATE_TOTP
myrealm	REMOVE_TOTP
myrealm	REVOKE_GRANT
myrealm	LOGIN_ERROR
myrealm	CLIENT_LOGIN
myrealm	RESET_PASSWORD_ERROR
myrealm	IMPERSONATE_ERROR
myrealm	CODE_TO_TOKEN_ERROR
myrealm	CUSTOM_REQUIRED_ACTION
myrealm	RESTART_AUTHENTICATION
myrealm	UPDATE_PROFILE_ERROR
myrealm	IMPERSONATE
myrealm	LOGIN
myrealm	UPDATE_PASSWORD_ERROR
myrealm	CLIENT_INITIATED_ACCOUNT_LINKING
myrealm	TOKEN_EXCHANGE
myrealm	REGISTER
myrealm	LOGOUT
myrealm	DELETE_ACCOUNT_ERROR
myrealm	CLIENT_REGISTER
myrealm	IDENTITY_PROVIDER_LINK_ACCOUNT
myrealm	UPDATE_PASSWORD
myrealm	DELETE_ACCOUNT
myrealm	FEDERATED_IDENTITY_LINK_ERROR
myrealm	CLIENT_DELETE
myrealm	IDENTITY_PROVIDER_FIRST_LOGIN
myrealm	VERIFY_EMAIL
myrealm	CLIENT_DELETE_ERROR
myrealm	CLIENT_LOGIN_ERROR
myrealm	RESTART_AUTHENTICATION_ERROR
myrealm	REMOVE_FEDERATED_IDENTITY_ERROR
myrealm	EXECUTE_ACTIONS
myrealm	TOKEN_EXCHANGE_ERROR
myrealm	PERMISSION_TOKEN
myrealm	SEND_IDENTITY_PROVIDER_LINK_ERROR
myrealm	EXECUTE_ACTION_TOKEN_ERROR
myrealm	SEND_VERIFY_EMAIL
myrealm	EXECUTE_ACTIONS_ERROR
myrealm	REMOVE_FEDERATED_IDENTITY
myrealm	IDENTITY_PROVIDER_POST_LOGIN
myrealm	IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR
myrealm	UPDATE_EMAIL
myrealm	REGISTER_ERROR
myrealm	REVOKE_GRANT_ERROR
myrealm	LOGOUT_ERROR
myrealm	UPDATE_EMAIL_ERROR
myrealm	EXECUTE_ACTION_TOKEN
myrealm	CLIENT_UPDATE_ERROR
myrealm	UPDATE_PROFILE
myrealm	FEDERATED_IDENTITY_LINK
myrealm	CLIENT_REGISTER_ERROR
myrealm	SEND_VERIFY_EMAIL_ERROR
myrealm	SEND_IDENTITY_PROVIDER_LINK
myrealm	RESET_PASSWORD
myrealm	CLIENT_INITIATED_ACCOUNT_LINKING_ERROR
myrealm	UPDATE_CONSENT
myrealm	REMOVE_TOTP_ERROR
myrealm	VERIFY_EMAIL_ERROR
myrealm	SEND_RESET_PASSWORD_ERROR
myrealm	CLIENT_UPDATE
myrealm	IDENTITY_PROVIDER_POST_LOGIN_ERROR
myrealm	CUSTOM_REQUIRED_ACTION_ERROR
myrealm	UPDATE_TOTP_ERROR
myrealm	CODE_TO_TOKEN
myrealm	IDENTITY_PROVIDER_FIRST_LOGIN_ERROR
myrealm	GRANT_CONSENT_ERROR
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
master	jboss-logging
myrealm	hasura_event_listener
myrealm	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	master
password	password	t	t	myrealm
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
myrealm	The Admin	replyToDisplayName
myrealm		starttls
myrealm	false	auth
myrealm	1025	port
myrealm	mailhog	host
myrealm	admin@webapp.com	replyTo
myrealm	admin@webapp.com	from
myrealm	LT Webapp	fromDisplayName
myrealm		ssl
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
myrealm	
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
ac80f8a3-baed-43d5-b6e6-010d1e34b7f1	/realms/master/account/*
039edccc-f22b-4c35-afa7-06aa26f6d1b6	/realms/master/account/*
1d762543-1e89-4e78-af2e-02c1e56b0ba0	/admin/master/console/*
723b4775-6ec2-44ff-9adf-01102831b159	/realms/myrealm/account/*
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	/realms/myrealm/account/*
324dcc7d-4bef-4361-abbd-eb0dda84aed6	/admin/myrealm/console/*
76f65bf9-3b38-4021-bd64-8119d10e1b8e	http://localhost:3000/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
9741eda3-0d7d-4c38-bf7b-17b2f7bc3d1e	VERIFY_EMAIL	Verify Email	master	t	f	VERIFY_EMAIL	50
253dcb0a-d61a-4cfc-8bf8-6f4a3f815957	UPDATE_PROFILE	Update Profile	master	t	f	UPDATE_PROFILE	40
f5a8abfe-7d06-4d4b-a3cf-939054b8256e	CONFIGURE_TOTP	Configure OTP	master	t	f	CONFIGURE_TOTP	10
312f1442-a90c-4004-bae1-31148b8d46ec	UPDATE_PASSWORD	Update Password	master	t	f	UPDATE_PASSWORD	30
ad97fff9-75b4-4800-a694-c97175950783	terms_and_conditions	Terms and Conditions	master	f	f	terms_and_conditions	20
280416b8-298a-42d7-90ac-08be06614486	update_user_locale	Update User Locale	master	t	f	update_user_locale	1000
01dc0bad-f972-476d-a141-281b10c3f5e5	delete_account	Delete Account	master	f	f	delete_account	60
6cb9c87b-7f55-47c7-9017-55943707b35e	VERIFY_EMAIL	Verify Email	myrealm	t	f	VERIFY_EMAIL	50
93877ecf-5411-4586-b809-4eaa9deb09d3	UPDATE_PROFILE	Update Profile	myrealm	t	f	UPDATE_PROFILE	40
aee40a56-0525-4476-9898-ad3a5e0041aa	CONFIGURE_TOTP	Configure OTP	myrealm	t	f	CONFIGURE_TOTP	10
d58df35a-8737-459f-9279-816bab488f3e	UPDATE_PASSWORD	Update Password	myrealm	t	f	UPDATE_PASSWORD	30
390e5a12-a1d9-4718-be3f-fa4fb6851722	terms_and_conditions	Terms and Conditions	myrealm	f	f	terms_and_conditions	20
84af17d1-3948-43b7-b63a-3a162b63dab2	update_user_locale	Update User Locale	myrealm	t	f	update_user_locale	1000
3b577623-4198-498c-8bc9-e4126587c2d9	delete_account	Delete Account	myrealm	f	f	delete_account	60
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
039edccc-f22b-4c35-afa7-06aa26f6d1b6	553c721f-6964-47fd-ae7e-fbb44b655c19
a05b5e3d-05d3-4ee4-8581-ffb84a67a275	a854fd93-763d-440f-8bc5-cda240a787d9
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
fcd1ddd8-aed9-42e0-8dc3-42700043a9f7	\N	5095da66-b123-45c6-8f7e-570e16c01b62	f	t	\N	\N	\N	master	admin	1610640229700	\N	0
b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b	a@b.com	a@b.com	t	t	\N	Foo	Bar	myrealm	test	1610640862784	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
4247cecd-8db8-4c19-ad1d-4bc7fb949812	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
b4c4bc58-9237-431b-bc1a-df8b9b85b8b8	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7
79a285b0-74a5-4d1c-b72a-d564e4c263b0	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7
09be7933-8986-4f12-a6e9-9a53ae4e8d6c	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7
553c721f-6964-47fd-ae7e-fbb44b655c19	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7
657756a2-0e23-407e-8b97-d443caa9a2c4	fcd1ddd8-aed9-42e0-8dc3-42700043a9f7
f307ed86-64d1-4a2e-9102-fa7b08fcabd1	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b
bb2e247c-de9d-4973-9ed7-d3008c8abdbd	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b
147c0888-de85-44f6-9612-76432590202f	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b
a854fd93-763d-440f-8bc5-cda240a787d9	b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
1d762543-1e89-4e78-af2e-02c1e56b0ba0	+
324dcc7d-4bef-4361-abbd-eb0dda84aed6	+
76f65bf9-3b38-4021-bd64-8119d10e1b8e	http://localhost:3000
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: client_default_roles constr_client_default_roles; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT constr_client_default_roles PRIMARY KEY (client_id, role_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: realm_default_roles constraint_realm_default_roles; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT constraint_realm_default_roles PRIMARY KEY (realm_id, role_id);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client_default_roles uk_8aelwnibji49avxsrtuf6xjow; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT uk_8aelwnibji49avxsrtuf6xjow UNIQUE (role_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: realm_default_roles uk_h4wpd7w4hsoolni3h0sw7btje; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT uk_h4wpd7w4hsoolni3h0sw7btje UNIQUE (role_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_def_roles_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_def_roles_client ON public.client_default_roles USING btree (client_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_def_roles_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_roles_realm ON public.realm_default_roles USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_client fk_c_cli_scope_client; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_client FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_scope_client fk_c_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT fk_c_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_roles fk_evudb1ppw84oxfax2drs03icc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_roles
    ADD CONSTRAINT fk_evudb1ppw84oxfax2drs03icc FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_default_roles fk_nuilts7klwqw2h8m2b5joytky; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_default_roles
    ADD CONSTRAINT fk_nuilts7klwqw2h8m2b5joytky FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client fk_p56ctinxxb9gsk57fo49f9tac; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT fk_p56ctinxxb9gsk57fo49f9tac FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope fk_realm_cli_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT fk_realm_cli_scope FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

