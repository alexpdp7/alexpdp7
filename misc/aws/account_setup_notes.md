# Account setup notes

> [!CAUTION]
> I do not have AWS training nor significant experience.
> The information here can be insecure and dangerous.

## Initial setup

### Creating the initial management account and initial configuration

Opening an account requires a credit card, a phone number and an email address.

Once an email address is associated with an AWS account, no other AWS account can be created with the same email address, even if you delete the AWS account.
Create use multiple email addresses or plus addressing for experiments, etc..
(OVH "redirect", Gmail and Google Groups support plus addressing.)

Go to "IAM Identity Center" and enable it in your preferred region.
This enables AWS Organizations and creates a `Root` OU that contains the management account.

By default, this uses an internal "Identity Center directory".
Alternatively, you can integrate with an external identity provider.
(TODO: using SAML?)

Create an `Admins` group.

Create an `admin` user, adding the user to the `Admins` group.

Create a predefined permission set with the `AdministratorAccess` policy.

Go to multi-account permissions, AWS accounts, select the management account and click "assign users or groups".
Assign the `Admins` group with the `AdministratorAccess` permission set.

Note the "AWS access portal URL", users use this URL to log in.

### Setting up the `admin` user

Depending on how you created the user, you create the password by following an email link or you receive an initial password.

You have to set up MFA.

When the user signs in, they are redirected to the AWS access portal.
An account tab displays the AWS accounts that the user can access.
Expand the account and click `AdministratorAccess` to access the AWS Console with full administrator access.

#### Configuring `awscli`

```
$ aws configure sso
SSO session name (Recommended): ${enter something}
SSO start URL [None]: ${the AWS access portal URL from an earlier step}
SSO region [None]: ${enter one}
SSO registration scopes [sso:account:access]: ${leave blank}
```

The `configure sso` command prints:

```
aws s3 ls --profile ${your profile name}
```

You can use this command to test access.

To log in again:

```
aws sso login --profile ${the profile name from an earlier step}
```

## First steps with AWS Organization Formation

```
npx --package aws-organization-formation -- org-formation init ${starter template yaml} --profile ${the profile name from an earlier step}
```

This command creates a `${starter template yaml}` file with the skeleton of your current AWS account structure.

## Account closure

TODO: verify when deleting an account disposes resources that incur billing.

## References

* [AWS Organization Formation](https://github.com/org-formation) declarative management of AWS accounts
  * [org-formation-reference](https://github.com/org-formation/org-formation-reference) A reference architecture which aims to provide some best practices for any AWS Organization starting out using org-formation.
  * [Part 1 – Managing AWS accounts like a PRO](https://fourtheorem.com/managing-aws-accounts-part-1/)
  * [Part 2 – Managing accounts using IaC with OrgFormation](https://fourtheorem.com/managing-accounts-using-iac-and-orgformation/)
