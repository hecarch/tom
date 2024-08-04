#!/bin/bash
#author : hecatonchire
### Hugo implementation in bash

# color variables
readonly normal="\033[0m"
readonly red_strong="\033[1;31m"
readonly white_strong="\033[1;37m"
readonly green_strong="\033[1;32m"

help_fn() {
	printf "${red_strong}[+] ${white_strong}Help page for tom usage and option.\n"
	printf "${green_strong}-h${white_strong} ; ${green_strong}--help\n"
	printf "${white_strong}		Print this help page.\n"
	printf "\n"
	printf "${green_strong}-d${white_strong} ; ${green_strong}--dependencies\n"
	printf "${white_strong}		Print tom's dependencies.\n"
	printf "\n"
	printf "${red_strong}[+] ${white_strong}How to use tom ?\n"
	printf "${green_strong}->	${white_strong}template.html is the html file from which generated html articles are based. You should write <!-- tomindice --> before your article. It should be in the website root directory.\n"
	printf "${green_strong}->	${white_strong}index.html is the page where your html article pages are sum-up. If you generate an article with tom, an extract will be automatically added to this file, with a link for your article.\n"
	printf "${green_strong}->	${white_strong}src/ is the directory where you should put your markdown files.\n"
	printf "${green_strong}->	${white_strong}articles/ is the directory where html pages are generated.\n"
}

dep_fn() {
	printf "${red_strong}[+] ${white_strong}Softwares needed by tom to work.\n"
	printf "${green_strong}->	${white_strong}pandoc\n"
}

update_summary() {
	#generates article fragment based on its markdown file's title, date of generation and the first article lines, then add it to index.html
	article_name=$(echo "$1" | sed 's/.html//')
	add_content="<div class=\"sum-article\"><h2><a href="articles/$article_name.html">$article_name - $(date "+%x")</a></h2><p>$(cat src/${article_name}.md | pandoc --from=markdown --to=html | sed 's/<p>//;s/<\/p>//' | sed "/<h[0-9]/d" | head -n 5) [...]</p></div>"
	echo $add_content > tmp-index.html
	sed -i "/articleindice/r tmp-index.html" index.html
	rm tmp-index.html
}

main() {
	pandoc src/$1 -o pandoc-tmp.html
	#inserts html article just after the keyword "tomindice" in the template.html
	article_name=$(echo "$1"| sed 's/.md//g')
	cp template.html articles/$article_name.html
	sed -i -e '/tomindice/r pandoc-tmp.html' articles/$article_name.html
	rm pandoc-tmp.html
	sed -i "s/TESTINDICE/$article_name/" articles/$article_name.html
	update_summary $article_name
}

if [[ -z $1 ]]; then
	printf "${red_strong}[->	Markdown filename or option must be provided.\n"
	printf "${green_strong}[?	${white_strong}Type ./tom.sh -h to get some help.\n"
else
	case $1 in
		-h | --help)
			help_fn
			;;
		-d | --dependencies)
			dep_fn
			;;
		-c | --config)
			conf_fn
			;;
		*)
			if [[ -e "src/$1" ]]; then
				main $1
			else
				echo "Option not understood."
			fi
			;;
	esac
fi

caddy reload
