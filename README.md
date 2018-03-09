# iatistandard.org Website Generator

### Rationale

At present, each of the components of the [IATI Standard SSOT](https://github.com/IATI/IATI-Standard-SSOT) includes scripts to generate the [iatistandard.org](http://iatistandard.org) website. These scripts are quite messy, and since they aren’t part of the standard, they shouldn’t really be in these repositories.

A first step towards tidying this up would be to move these scripts out into a separate website generator repository. This is that.

### Setup

```sh
pip install -r requirements.txt
```

### Usage

So far, this just generates codelist-related stuff.

```sh
./codelists/gen.sh version-{1.04,1.05,2.01,2.02,2.03}
```

### TODO

Add tests, to check this is doing exactly the same thing as the existing code.
