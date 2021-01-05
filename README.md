# adryd-dotfiles
## Goals
 - Quickly deploy systems with as little interaction as possible
 - Identify the environment and install 
 - The install script should be able to run again with no issue
 - The install script should be able to update installed configurations
 - Plug and play modules
## Notes for myself
`gsetting set org.gnome.desktop.peripherals.touchpad disable-while-typing false`  
bash is hard to read quickly, comment as much as makes sense.

## Code quality rules
 - variables that will be accessed outside of just one module are formatted like so `AR_VARIABLE_NAME`
 - variables that will be only accessed within one module are formatted like so `arModuleVariableName`
 - logging will always start with a capital letter and end with no period like so `info nginx Building`
 - strings which do not use a template must use single quotes `'hello'` `"hello $USER"`