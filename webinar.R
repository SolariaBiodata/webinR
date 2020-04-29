library(tidyverse)
library(data.table)
library(plyr)

# Datos consultados el 27 de Abril de 2020
# https://datos.gob.mx/busca/dataset/informacion-referente-a-casos-covid-19-en-mexico

input = "200427COVID19MEXICO.csv"

# CatÃ¡logos, tambiÃ©n consultables del mismo link, pero adaptados para carga mÃ¡s sencilla
cat_comorbilidad = "data_covid19/cat_comorbilidad.csv"
cat_resultado = "data_covid19/cat_resultado.csv"
cat_entidad = "data_covid19/cat_entidad.csv"
cat_municipio = "data_covid19/cat_municipio.csv"


# Este serÃ¡ el dataframe principal que usaremos en el ejercicio
cov = fread(input,encoding="UTF-8")

# Dataframes de catÃ¡logos
df_comorbilidad = fread(cat_comorbilidad,encoding="UTF-8")
df_resultado = fread(cat_resultado,encoding="UTF-8")
df_entidad = fread(cat_entidad,encoding="UTF-8")
df_municipio = fread(cat_municipio,encoding="UTF-8")

# VisualizaciÃ³n rÃ¡pida del DF principal
# Recuerda que esto es lo mismo que head(cov)
cov %>% head()

# Estructura del DF
str(cov)

# Dimensiones del DF
dim(cov)

# Nombres de columnas del DF
colnames(cov)

# Nacionalidades en el DF
cov$PAIS_NACIONALIDAD %>% unique()

# Resultados de DiagnÃ³stico
cov$RESULTADO

# Mapeo de Valores respecto al catÃ¡logo
cov$RESULTADO = mapvalues(cov$RESULTADO,from=df_resultado$CLAVE,to=df_resultado$DESCRIPCIÓN)

# Nuevamente, vemos resultados de DiagnÃ³stico
cov$RESULTADO

# Crearemos una funciÃ³n para mapear algunas comorbilidades
mapea_comorbilidades <- function(x){
  res = mapvalues(x,from=df_comorbilidad$CLAVE,to=df_comorbilidad$DESCRIPCIÓN)
  return(res)
}

# Y posteriormente usamos la funciÃ³n para mapear ---
cov$HIPERTENSION = mapea_comorbilidades(cov$HIPERTENSION)
cov$DIABETES = mapea_comorbilidades(cov$DIABETES)
cov$TABAQUISMO = mapea_comorbilidades(cov$TABAQUISMO)

# Â¿CÃ³mo podriamos mapear las entidades y municipios?
#
# De tarea ...

# Podemos seleccionar algunas columnas a partir del DF principal
cov %>% select(FECHA_SINTOMAS,ENTIDAD_RES,RESULTADO,EDAD,HIPERTENSION,DIABETES,TABAQUISMO)

# Podemos filtrar dependiendo de algunos valores
cov %>% filter(RESULTADO == "POSITIVO")
cov %>% filter(EDAD > 20)
cov %>% filter(EDAD > 20) %>% filter(EDAD<65)

# Ploteo de grÃ¡ficos
## Usaremos algunas estrategias de visualizaciÃ³n con ggplot2

## Curva EpidemiolÃ³gica de casos por dÃ­a
# Esta es la curva que se presenta, de casos acumulados a lo largo de esta contingencia
ggplot(cov, aes(x=FECHA_SINTOMAS,fill=RESULTADO) ) + geom_bar()

## Mapa de calor de presencia en estados por edad
# Esta grÃ¡fica presenta la diferencia entre entidades por edad
ggplot(cov, aes(x=ENTIDAD_RES,y=RESULTADO,fill=EDAD) ) + geom_raster()

## ContribuciÃ³n de comorbilidades
# Aqui podemos ver la diferencia en Ã¡reas respecto al intervalo de edades
cov %>% filter(EDAD<=100) %>% ggplot(aes(x=DIABETES,y=EDAD,fill=RESULTADO)) + geom_violin()

## ResoluciÃ³n de casos positivos/negativos respecto al tiempo
# En esta curva es visible la progresiÃ³n del diagnÃ³stico, asÃ­ como los casos pendientes
cov %>% filter(EDAD<=75) %>% ggplot(aes(x=FECHA_SINTOMAS,y=EDAD,fill=RESULTADO)) + geom_boxplot()

# Decoradores
## No olvides que en la presentaciÃ³n de grÃ¡ficos podemos usar los siguienters decoradores:
# labs(x=âeje xâ,y=âeje yâ)
# ggtitle(âTÃ­tuloâ)
# theme(axis.text.x = element_text(angle = 90, hjust = 1))
