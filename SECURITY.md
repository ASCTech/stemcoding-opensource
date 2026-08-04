# Security Policy

## Reporting a Vulnerability

Please **do not** open a public issue for security vulnerabilities.

Instead, report them privately to **<INSERT SECURITY CONTACT EMAIL>** (or via
GitHub's private ["Report a vulnerability"](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
feature if enabled on this repository).

Please include:

- A description of the vulnerability and its impact
- Steps to reproduce or a proof of concept
- Any suggested remediation

We will acknowledge your report as quickly as we can and keep you informed of
progress toward a fix. Please give us a reasonable amount of time to address the
issue before any public disclosure.

## Handling secrets

This application stores secrets in Rails encrypted credentials
(`config/credentials.yml.enc`). The decryption key (`config/master.key` /
`RAILS_MASTER_KEY`) is **never** committed. If you believe a key or secret has
been exposed, rotate it immediately and notify the maintainers.
