sudo docker run --volume $(pwd):/cre/R tamboraorg/crecoding:2020.0 R -e "rmarkdown::render('/cre/R/README.Rmd')"
