#!/bin/bash
#from hecatonchire
### Hugo implementation in bash
### Pretty simple isn't it

update_summary() {
	#créé le content avec le titre du .md, la date et les premières lignes de l'article puis l'ajouter a l'index
	article_name=$(echo "$1" | sed 's/.html//')
	add_content="<div class=\"sum-article\"><h2><a href="articles/$article_name.html">$article_name - $(date "+%x")</a></h2><p>$(cat src/${article_name}.md | pandoc --from=markdown --to=html | sed 's/<p>//;s/<\/p>//' | sed "/<h[0-9]/d" | head -n 5) [...]</p></div>"
	echo $add_content > tmp-index.html
	sed -i "/articleindice/r tmp-index.html" index.html
	rm tmp-index.html
}

main() {
	pandoc src/$1 -o pandoc-tmp.html
	#insérer dans une copie du template html l'article en html après le keyword
	article_name=$(echo "$1"| sed 's/.md//g')
	cp template.html articles/$article_name.html
	sed -i -e '/tomindice/r pandoc-tmp.html' articles/$article_name.html
	rm pandoc-tmp.html
	sed -i "s/TESTINDICE/$article_name/" articles/$article_name.html
	update_summary $article_name
}

if [[ -z $1 ]]; then
	echo "Markdown filename must be provided\n"
	echo "Don't forget to add keyword 'tomindice'"
else
	main $1
fi
