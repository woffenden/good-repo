# Good Repository

> An _opinionated_ approach of a "good" repository.

## Repository Settings

- Require contributors to sign off on web-based commits

- Default branch `main`

- Issues

- Allow squash merging

  - Default commit message (Pull request title and description)

- Always suggest updating pull request branches

- Automatically delete head branches

- Owned by a Team

- Ruleset for `main`

  - Restrict deletions

  - Require linear history

  - Require signed commits

  - Require a pull request before merging

    - Required approvals (1)

    - Dismiss stale pull request approvals when new commits are pushed

    - Require review from Code Owners

    - Require approval of the most recent reviewable push

    - Require conversation resolution before merging

    - _Optional_ Request pull request review from Copilot

    - Allowed merge methods (Squash)

  - Require status checks to pass

    - Require branches to be up to date before merging

    - Do not require status checks on creation

    - Required Checks

      > [!NOTE]
      > This section is a work in progress

      - CodeQL (GitHub Advanced Security)

      - Dependency Review (GitHub Actions)

      - Super Linter (GitHub Actions)

      - Zizmor (GitHub Actions)

  - Require code scanning results

    > [!NOTE]
    > This section is a work in progress

    - CodeQL (Security alerts: high or higher, Alerts: Errors)

    - Zizmor (Security alerts: high or higher, Alerts: Errors)

- Actions

  - Require approval for all external contributors

  - `GITHUB_TOKEN` default permissions: Read repository contents and packages permissions

- Advanced Security

  - Secret protections

    - Validity checks

    - Non-provider patterns

    - Scan for generic passwords

    - Push protection

    - Prevent direct alert dismissals

  - Code security

    - _Optional_ Copilot Autofix

    - _Optional_ Copilot Autofix for third-party tools (beta)

    - Prevent direct alert dismissals

    - Protection rules

      - Check runs failure threshold (Security alert severity level: high or higher, Standard alert severity level: only errors)

    - Private vulnerability reporting

    - Dependency graph

    - Automatic dependency submission

    - Dependabot

      - Dependabot alerts

      - Dependabot security updates

      - Grouped security updates

      - Dependabot on Actions runners
