# What is it ?

This project was started by [**9h37 SAS**](http://9h37.fr)

*lemonldap-cli* is a command line tool to configure **LemonLDAP::NG** from the
command line. Make you able to deploy your web application faster and easier.

# Installation

***To be written***

# How to use

Set/get variables in the configuration:

```
lemonldap-cli set <variable> <value>
lemonldap-cli unset <variable>
lemonldap-cli get <variable>
```

Define macros:

```
lemonldap-cli set-macro <macro name> <perl expression>
lemonldap-cli unset-macro <macro name>
lemonldap-cli get-macro <macro name>
```

Modify application list:

```
lemonldap-cli apps-set-cat <cat id> <cat name>
lemonldap-cli apps-get-cat <cat id>

lemonldap-cli apps-add <app id> <cat id>
lemonldap-cli apps-set-uri <app id> <app uri>
lemonldap-cli apps-set-name <app id> <app name>
lemonldap-cli apps-set-desc <app id> <app description>
lemonldap-cli apps-set-logo <app id> <logo>
lemonldap-cli apps-set-display <app id> <app display>

lemonldap-cli apps-get <app id>
lemonldap-cli apps-rm <app id>
```

Manage rules:

```
lemonldap-cli rules-set <virtual host> <expr> <rule>
lemonldap-cli rules-unset <virtual host> <expr>
lemonldap-cli rules-get <virtual host>
```

Manage exported variables:

```
lemonldap-cli export-var <key> <value>
lemonldap-cli unexport-var <key>
lemonldap-cli get-exported-vars
```

Manage exported headers:

```
lemonldap-cli export-header <virtual host> <HTTP header> <perl expression>
lemonldap-cli unexport-header <virtual host> <HTTP header>
lemonldap-cli get-exported-headers <virtual host>
```

Manage virtual hosts:

```
lemonldap-cli vhost-add <virtual host uri>
lemonldap-cli vhost-del <virtual host>
lemonldap-cli vhost-list
```

