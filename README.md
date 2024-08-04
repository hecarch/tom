# tom
Simple and unbloated Hugo implementation in bash

## Goal of tom
I made tom to generate HTML pages from HTML template, based on Markdown articles.

## Functionning of tom
The `main` function converts provided Markdown file into a HTML fragment. This fragment is inserted in a template copy, just after a keyword.

All these copy are named from the Markdown file assiociated.

The `update_summary` function get the filename, add it in a div to the index.html file and generate an extract of the html text.

This is my arborescence :

```
.
├── about.html
├── articles
│   └── article-eu.html
├── index.html
├── src
│   └── article-eu.md
├── style.css
├── template.html
├── tom.sh
└── Ubuntu-L.ttf
```
