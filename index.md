---
permalink: /index.html
---
![alt text](https://solariabiodata.com.mx/images/solaria_banner.png "Soluciones de Siguiente Generación")
# Seminario Online de R "WebinR"


### Descripción
En esta sesión haremos algunos ejercicios prácticos sobre lo revisado durante la sesión de presentación, usando RStudio (opcionalmente, R en terminal)

### Requisitos

Para poder realizar este ejercicio, necesitaremos:

1. Datos de Ejemplo:
    - Puedes usar tus propios datos siguiente algunas recomendaciones de este tutorial
    - O puedes usar los datos del respositorio
    - O puedes descargalos desde [https://datos.gob.mx/busca/dataset/informacion-referente-a-casos-covid-19-en-mexico]
2. Sofware Recomendable para esta sesión:
    - Terminal (Mac o Linux)
    - RStudio (Windows)

## Carga de datos y manejo básico

### Datos consultados el 27 de Abril de 2020
~~~
    input = "200427COVID19MEXICO.csv"
~~~
### Catálogos, también consultables del mismo link, pero adaptados para carga más sencilla
~~~
    cat_comorbilidades = "data_covid19/cat_comorbilidad.csv"
~~~
~~~
    cat_resultado = "data_covid19/cat_resultado.csv"
~~~
~~~
    cat_entidad = "data_covid19/cat_entidad.csv"
~~~
~~~
    cat_municipio = "data_covid19/cat_municipio.csv"
~~~

### Este será el dataframe principal que usaremos en el ejercicio
    cov = fread(file)

### Dataframes de catálogos
~~~
    df_comorbilidad = fread(cat_comorbilidad)
~~~
~~~
    df_resultado = fread(cat_resultado)
~~~
~~~
    df_entidad = fread(cat_entidad)
~~~
~~~
    df_municipio = fread(cat_municipio)
~~~
### Visualización rápida del DF principal
~~~
    cov %>% head()
~~~
### Estructura del DF
~~~
  str(cov)
~~~
### Dimensiones del DF
~~~
  dim(cov)
~~~
### Nombres de columnas del DF
~~~
  colnames(cov)
~~~
### Nacionalidades en el DF
~~~
  cov$PAIS_NACIONALIDAD %>% unique()
~~~
### Resultados de Diagnóstico
~~~
  cov$RESULTADO
~~~
### Mapeo de Valores respecto al catálogo
~~~
  cov$RESULTADO = mapvalues(cov$RESULTADO,from=df_resultado$CLAVE,to=resultado$DESCRIPCIÓN)
~~~
### Nuevamente, vemos resultados de Diagnóstico
~~~
  cov$RESULTADO
~~~
### Crearemos una función para mapear algunas comorbilidades
~~~
    mapea_comorbilidades <- function(x){
      res = mapvalues(x,from,df_comorbilidad$CLAVE,to=df_comorbilidad$DESCRIPCIÓN)
      return(res)
      }
~~~
### Y posteriormente usamos la función para mapear ---
~~~
    cov$HIPERTENSION = mapea_comorbilidades(cov$HIPERTENSION)
~~~
~~~
    cov$DIABETES = mapea_comorbilidades(cov$DIABETES)
~~~
~~~
    cov$TABAQUISMO = mapea_comorbilidades(cov$TABAQUISMO)
~~~
### ¿Cómo podriamos mapear las entidades y municipios?
    # De tarea ...

### Podemos seleccionar algunas columnas a partir del DF principal
~~~
    cov %>% select(FECHA_SINTOMAS,ENTIDAD_RES,RESULTADO,EDAD,HIPERTENSION,DIABETES,TABAQUISMO)
~~~
### Podemos filtrar dependiendo de algunos valores
~~~
    cov %>% filter(RESULTADO == "POSITIVO")
~~~
~~~
    cov %>% filter(EDAD > 20) %>% filter(EDAD<65)
~~~
~~~
    cov %>% filter(EDAD > 20)
~~~
## Ploteo de gráficos
 Usaremos algunas estrategias de visualización con ggplot2

### Curva Epidemiológica de casos por día
Esta es la curva que se presenta, de casos acumulados a lo largo de esta contingencia
~~~
    ggplot(cov, aes(x=FECHA_SINTOMAS,fill=RESULTADO) ) + geom_bar()
~~~
### Mapa de calor de presencia en estados por edad
 Esta gráfica presenta la diferencia entre entidades por edad
~~~
    ggplot(cov, aes(x=ENTIDAD_RES,y=RESULTADO,fill=EDAD) ) + geom_raster()
~~~
### Contribución de comorbilidades
Aqui podemos ver la diferencia en áreas respecto al intervalo de edades
~~~
    cov %>% filter(EDAD<=100) %>% ggplot(aes(x=DIABETES,y=EDAD,fill=RESULTADO)) + geom_violin
~~~
### Resolución de casos positivos/negativos respecto al tiempo
En esta curva es visible la progresión del diagnóstico, así como los casos pendientes
~~~
    cov %>% filter(EDAD<=75) %>% ggplot(aes(x=FECHA_SINTOMAS,y=EDAD,fill=RESULTADO)) + geom_boxplot()
~~~
### Decoradores
 No olvides que en la presentación de gráficos podemos usar los siguienters decoradores:
~~~
    labs(x=“eje x”,y=“eje y”)
~~~
~~~
    ggtitle(“Título”)
~~~
~~~
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
~~~
