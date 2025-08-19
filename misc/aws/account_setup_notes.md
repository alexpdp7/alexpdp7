# Account setup notes

> [!CAUTION]
> I do not have AWS training nor significant experience.
> The information here can be insecure and dangerous.

## Initial setup

### Creating the initial management account and initial configuration

Opening an account requires a credit card and a phone number.

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

For tests, you might want to tear down an account and start from scratch.

[Close an AWS account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-closing.html) says:

> Within a few minutes, you should receive an email confirmation that your account has been closed.

> If you don’t receive this email within a few hours ...

You cannot create a new account with the same account email until the account is completely removed.
(TODO: when? I deleted my account around August 19th 23:00 and I have not received it after half an hour.)

Create more email addresses or use plus addressing for faster experiments.
(Note to self: OVH "redirect" supports plus addressing.)

## References

* [AWS Organization Formation](https://github.com/org-formation) declarative management of AWS accounts
  * [org-formation-reference](https://github.com/org-formation/org-formation-reference) A reference architecture which aims to provide some best practices for any AWS Organization starting out using org-formation.
  * [Part 1 – Managing AWS accounts like a PRO](https://fourtheorem.com/managing-aws-accounts-part-1/)
  * [Part 2 – Managing accounts using IaC with OrgFormation](https://fourtheorem.com/managing-accounts-using-iac-and-orgformation/)
