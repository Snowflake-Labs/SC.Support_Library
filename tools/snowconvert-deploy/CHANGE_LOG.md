
# Change Log

## Version 0.0.6

- Adding some documentation for SNOW_xxx environmental variables
- Improvements in the SplitPattern implementation
- Make user parameter optional

## Version 0.0.7

- Change SplitPattern for SplitBefore or After to better handle some scenarios

## Version 0.0.8

- Minor fixes

## Version 0.0.9

- Adding support for external-browser authenticator
- Adding shema option

## Version 0.0.10

- No changes, solving an issue with PyPi publication

## Version 0.0.11

- Schema parameter was not properly passed in connection call

## Version 0.0.12

- Path corrected so the tool can locate the snowsql config file
- Added an option to prompt for password if it was not provided

## Version 0.0.13

- Compatibility with SnowSQL Environment Variables
- Ability to use ~/.snowsql/config parameters
- Folder Sync Feature
- Some Pylint fixes

## Version 0.0.14

- Fixing issue with files in UTF-8 with BOM

## Version 0.0.15

- Adding more  fixes for files in UTF-8 with BOM
- Adding parameter for force prompt for password
- Using rich for more colorful output
- Adding try/catch for ini file parsing issue

## Version 0.0.16

- Fixing some display issues

## Version 0.0.17

- changes for reading user\password\schema from snowsql files

## Version 0.0.18

- several revisions on threading management
- fixing some issues where reported numbers where not accurate
- changing the display for recursive runs
- log results output revision

## Version 0.0.19

- changes in github actions

## Version 0.0.20

- we found some thread not always ending, adding force exit to avoid that

## Version 0.0.21-0.0.23

- some build issues

## Version 0.0.24

- implemented mechanism for parameter substitution

## Version 0.0.25

- remove hard code params