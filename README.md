![Version](https://img.shields.io/endpoint?url=https://shield.abappm.com/github/abapPM/ABAP-SemVer-SAP/src/zcl_semver_sap.clas.abap/c_version&label=Version&color=blue)

[![License](https://img.shields.io/github/license/abapPM/ABAP-SemVer-SAP?label=License&color=success)](https://github.com/abapPM/ABAP-SemVer-SAP/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg?color=success)](https://github.com/abapPM/.github/blob/main/CODE_OF_CONDUCT.md)
[![REUSE Status](https://api.reuse.software/badge/github.com/abapPM/ABAP-SemVer-SAP)](https://api.reuse.software/info/github.com/abapPM/ABAP-SemVer-SAP)

# Semantic Version for SAP Releases

Since SAP does not use semantic versioning for components of ABAP systems, this class implements a bi-directional mapping between the two covering as many cases as possible.

NO WARRANTIES, [MIT License](https://github.com/abapPM/ABAP-SemVer-SAP/blob/main/LICENSE)

## Usage

Derive semantic version from SAP release:

```abap
DATA(semver) = NEW zcl_semver_sap( ).

WRITE semver->sap_release_to_semver( '750' ). " 7.50.0
" with support package
WRITE semver->sap_release_to_semver( release = '750' support_pack = '0012' ). " 7.50.12
```

Convert SAP release to semantic version:

```abap
WRITE semver->semver_to_sap_release( '7.50.0' ). " 750
" with support package
semver->semver_to_sap_release_sp(
  EXPORTING
    version      = '7.50.12'
  IMPORTING
    release      = release         " 750
    support_pack = support_pack ). " 0000000012
```

Get semantic version for installed SAP component:

```abap
WRITE semver->sap_component_to_semver( 'SAP_BASIS' ). " 758
```

See the code and test classes for mapping of other "strange SAP release formats" like 1909 or 2011_1_731.

## Prerequisites

SAP Basis 7.50 or higher

## Installation

Install `semver-sap` as a global module in your system using [apm](https://abappm.com).

or

Specify the `semver-sap` module as a dependency in your project and import it to your namespace using [apm](https://abappm.com).

## Contributions

All contributions are welcome! Read our [Contribution Guidelines](https://github.com/abapPM/ABAP-SemVer-SAP/blob/main/CONTRIBUTING.md), fork this repo, and create a pull request.

You can install the developer version of ABAP SEMVER-SAP using [abapGit](https://github.com/abapGit/abapGit) by creating a new online repository for `https://github.com/abapPM/ABAP-SemVer-SAP`.

Recommended SAP package: `$SEMVER-SAP`

## About

Made with ❤ in Canada

Copyright 2025 apm.to Inc. <https://apm.to>

Follow [@marcf.be](https://bsky.app/profile/marcf.be) on Blueksy and [@marcfbe](https://linkedin.com/in/marcfbe) or LinkedIn
