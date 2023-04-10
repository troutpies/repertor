repertor
========

**repertor** is a document opener, wrapped around `fzf`. 

# Command-line options

* `-d <search-dir>` - the directory to search. For relative paths, the
  `search-dir` is searched for in the current directory, as well as the $HOME
  directory.
* `-p <picker>` - the command to use to select the file to open. Ideally, this
  should be a simple base command, with display options set via an environment
  variable. Support is provided for `fzf` (the default option), `rofi` and
  `dmenu`
* `-t <type>` - this a pipe (`|`) separated list of extensions to search for.
  e.g. "pdf|txt|doc|docx"
  This is inserted into an `egrep` style *regular expression*, so some more
  complex patterns, such as 'jp[e]?g' are permitted. Do not include spaces
  between the pipes - this value will be inserted directly into a regular
  expression.
* `-v <viewer>` - make sure that the viewer is appropriate to the specified
  filetype. The default value is `xdg-open`, and the intended use-case is to use
  appropriate mime-types to open files via `xdg-open`
* `-b` - verBose: display internal variable information
* `-h` - display help information
