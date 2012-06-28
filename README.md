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
lemonldap-cli rules-set <uri> <expr> <rule>
lemonldap-cli rules-unset <uri> <expr>
lemonldap-cli rules-get <uri>
```

