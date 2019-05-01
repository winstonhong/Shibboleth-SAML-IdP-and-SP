# Steps to Reproduce

### Requirements

- Docker 17.09.0
- Ubuntu Linux 16.04 or Mac OS X 10.12.5

### Before you Begin
Before you begin you should collect the following items and information:
a TLS key/certificate that you'll use to secure your browser-facing HTTP(S) connection on port `443`.

Assuming you plan to use the IdP for SAML support (as opposed to CAS support for example), you will need:

- the `entityID` URL you want to use to name your IdP (the installer will suggest one from your hostname, but this may not be a good choice)
- the second- or third-level DNS subdomain to append to any "scoped" attributes, often the same as your organization's email domain
- a source of SAML Metadata for the service providers your IdP needs to support (this could come from a "federation" of organizations you've joined, directly from the SP owners, or created and maintained by hand)

If you don't have any SAML metadata to give the IdP, you won't have an easy time making it do anything useful without changing a lot of defaults, so please take the time and start by acquiring or creating that metadata first if you're just starting out. If you have nothing else to use, the TestShib site can help you get started, but if you're using it longer than a couple of weeks, you should rethink what you're trying to accomplish.

The installation process will suggest or generate the following information for you:
the IdP's `entityID` (which you can override as noted above) and separate self-signed key/certificate pairs for:

- Message signing.
- Securing web service connections, generally on port `8443`.
- Encryption of data by other systems for decryption by the IdP.
- A secret key and key version file for securing cookies and other data produced by the IdP for its own use (this is a special Java keystore of type "JCEKS").
- Some initial sample metadata describing the IdP for use by partner SPs, once it's reviewed and supplemented.
- A default set of IdP configuration files based on this information.

### 1. Clone the Repository
```
git clone https://github.com/winstonhong/Shibboleth-SAML-IdP-SP
```

### 2. Build the Initial Container
```
./build.sh
```
**Note:** All configuration present in the `base/` directory will be persisted in the container upon build. Runtime configuration of container instances is done through additional configuration files in the `ext-conf/` directory. On container start, this directory is mounted inside the container and merged with the base configuration.

### 3. Initialize Configuration Files
An Shibboleth IdP configuration has been included in the directory './ext-conf' for demo purpose. You can skip the Steps 3 to 5 to keep IdP configuration and LDAP configuration by default.

If you want to create your own Shibboleth IDP configuration, you can delete the existing directory './ext-conf' and then create a starting set of configuration files by running: `./init.sh`

You will need to answer the following questions:

|Variable|Information|
|--------|-----------|
|Hostname | The FQDN of the Shibboleth IdP host. Should be DNS resolvable from the outside. For example: `idp.example.com`|
|Attribute Scope | The scope under which user attributes are federated. For more information see [Shibboleth Documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/ResolverScopedAttributeDefinition). For example: `example.com`|
|SAML EntityID| According to the SAML Core specification, it is recommended that the URI is a URL that contains the domain name of the entity. If you are to expose metadata, the EntityId is used as a well known URL for the meta data of the entity. For example: `https://idp.example.com/idp/shibboleth`|
|Backchannel PKCS12 Password| The password for the backchannel keystore |
|Cookie Encryption Key Password | The key used to encrypt SAML cookies|

This command automatically creates a directory `./ext-conf` with configuration files that can be further customized to the target environment.

**Note:** Remember the password for `backchannel keystore`, you will require it later! Example: `abcde`

### 4. LDAP Configuration

The file `ext-conf/conf/ldap.properties` contains the configuration of connectivity to an ldap directory containing user accounts and enterprise application specific attributes.

### 5. Generate a Browser Keystore
If you create your own Shibboleth IdP configuration, you can generate a browser keystore by running
 
```
./mk-browser-keystore.sh
```
**Note:** Remember the password you supplied as `export password`, you will require it later! Example: `12345`

### 6. Starting the container
If you create your own Shibboleth IdP configuration through Steps 3 to 5, you need to replace the passwords for `backchannel keystore` and 'browser keystore' with the passwords specified by you.

```
./run.sh
```

### Typical Next Steps
- Review the top of the [Configuration](https://wiki.shibboleth.net/confluence/display/IDP30/Configuration) page to get some basic familiarity with the installation tree and how to use it.
- Load SAML metadata for the service provider(s) with which you will interact.
- Configure [authentication](https://wiki.shibboleth.net/confluence/display/IDP30/AuthenticationConfiguration).
- Configure [attribute resolution](https://wiki.shibboleth.net/confluence/display/IDP30/AttributeResolverConfiguration) and [attribute release policy](https://wiki.shibboleth.net/confluence/display/IDP30/AttributeFilterConfiguration).
- [Customize](https://wiki.shibboleth.net/confluence/display/IDP30/PasswordAuthnConfiguration) your login UI, error handling, etc.
- [Productionization](https://wiki.shibboleth.net/confluence/display/IDP30/Productionalization?src=contextnavpagetreemode)
- Multi-Factor Authentication [Flows](https://wiki.shibboleth.net/confluence/display/IDP30/MultiFactorAuthnConfiguration)
