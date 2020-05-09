#!/usr/bin/env ruby

# copy files from ./repo_files to the repo
# index.html, stylesheets, etc

`mkdir -p styles`
`cp mmx/bin/repo_files/base.css ./styles/base.css`
`cp mmx/bin/repo_files/index.html ./index.html`

