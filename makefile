all:
	livescript -cb index.ls coord.ls
	sass index.sass index.css
	jade index.jade
