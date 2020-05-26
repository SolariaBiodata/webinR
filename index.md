---
permalink: /index.html
---
![alt text](https://solariabiodata.com.mx/images/solaria_banner.png "Soluciones de Siguiente Generación")
# Seminario Online de R "WebinR-2"


### Descripción
En esta sesión haremos algunos ejercicios prácticos sobre lo revisado durante la sesión de presentación, usando RStudio (opcionalmente, R en terminal)

### Requisitos

Para poder realizar este ejercicio, necesitaremos:

1. Datos de Ejemplo:
    - Puedes usar tus propios datos siguiente algunas recomendaciones de este tutorial
    - O puedes usar los datos de asignación taxonómica transformados a formato BIOM
    - O puedes descargalos desde [asignacion_taxonomica.tsv](asignacion_taxonomica.tsv)
2. Sofware Recomendable para esta sesión:
    - Terminal (Mac o Linux)
    - RStudio (Windows)

## Carga de datos y manejo básico

### Definición del nombre de archivo
> No olvides también indicar la ruta completa de tu sistema de archivos
~~~
    input = "asignacion_taxonomica.tsv"
~~~

### Este será el dataframe principal que usaremos en el ejercicio
~~~    
    dat = read.table(input,sep="\t",header=T)
~~~
### Exploración de la estructura del dataframe
Nombres de las columnas del DF
~~~
    colnames(dat)
~~~
Dimensiones (número de filas y columnas)
~~~
    dim(dat)
~~~
Revisión de la estructura de objeto
~~~
    str(dat)
~~~
Visualización de primeros elementos del objeto
~~~
head(dat)
~~~
### Definición de Funciones Personalizadas
Aquí crearemos una función que nos ayudará a separar valores de un string de taxonomía
~~~
    transform_taxonomy <- function(x){
        tax = x$taxonomy %>% str_split(pattern=";",n=6,simplify=TRUE)
        out = cbind(x,tax)
        return(out)
    }
~~~
Para usar la función, debemos ejecutarla como
~~~
    comp = transform_taxonomy(dat)
~~~


Probaremos cómo resulta esta función y si puede ser utilizada en más casos

### Análisis de Datos
Reemplazo de valores nulos
~~~
    comp = replace(comp,is.na(comp),0)
~~~
Revisión de columnas género, familia, orden, clase
~~~
comp$class %>% unique()
comp$order %>% unique()
comp$family %>% unique()
comp$genus %>% unique()
~~~
Conteo de cada nivel taxonómico
~~~
comp %>% count(order)
~~~
Transformando a data.frame
~~~
comp %>% count(order) %>% as.data.frame()
~~~
Ordenando numéricamente
~~~
comp %>% count(order) %>% as.data.frame() %>% arrange(n)
~~~
Orden descendiente
~~~
comp %>% count(order) %>% as.data.frame() %>% arrange(desc(n))
~~~
Guardando en un objeto nuevo
~~~
comp %>% count(order) %>% as.data.frame() %>% arrange(desc(n)) -> tax_order_resume
~~~

### Filtro
Crearemos una tabla de resumen en nivel de familia
~~~
comp %>% count(family) %>% as.data.frame() %>% arrange(desc(n)) -> tax_family_resume
~~~
Filtrar por valores que no serán informativos (a la tabla comp)
~~~
comp %>% filter(family!="Other")
~~~
~~~
comp %>% filter(family!="Other") %>% filter(family!="f__unidentified") -> comp
~~~
### Agrupación
~~~
comp %>% group_by(family) %>% summarise(sum=sum(sample_1,sample_2,sample_3))
~~~
