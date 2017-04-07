# Light Mac diagnostic tool
Generates a report of different elements of a Mac OS X computer.

It uses only built-in tools, with no root rights.

## Usage
```shell
sh diagnostic.sh
```

### Variants
#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/gafhyb/lmd/master/diagnostic.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/gafhyb/lmd/master/diagnostic.sh -O -)"
```
