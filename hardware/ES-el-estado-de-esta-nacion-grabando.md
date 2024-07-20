# El estado de esta nación grabando

Un familiar estaba encantado con su "vídeo" de hace ya muchos años.
El vídeo es un receptor de TDT con disco duro (y DVD-RW) con el que puede grabar programas emitidos por TDT en España.
Está acostumbrado a ver la tele y grabar, y hasta muy recientemente no han tenido Internet en casa, por lo que no están acostumbrados a usar plataformas tipo Netflix.

Pero este vídeo sólo soporta SD, y en 2024 se produce el apagón.

## Alternativas "distintas"

El familiar comienza a usar Amazon Prime y alguna otra plataforma, pero no acaba de acostumbrarse y sigue grabando.

* [Tivify](https://www.tivify.tv/) y similares permiten ver canales tradicionales de TDT como una plataforma de streaming normal y permite reproducir programas de los días anteriores.
  Es más práctico, ya que no hay que programar grabaciones.
  Sin embargo, tiene coste y la gente acostumbrada a grabar parece no apañarse.

* Otra opción es HbbTV, conocido en España como LovesTv.
  Es una "capa" sobre una Smart TV que integra la emisión en TDT con una versión de la web de cada canal.
  Si estamos viendo TVE1, podemos activar el LovesTv y acceder al listado de programas anteriores del canal y verlos.
  Sin embargo, como veremos más adelante, le compramos al familiar una de las pocas teles del mercado (Xiaomi, de la que tenía excelentes referencias) que no tiene, pues no conocíamos esta característica.

## Intentar mantener lo mismo

### Dispositivos TDT varios

Lo primero que intentamos fue comprar un receptor de TDT de Amazon con capacidad de grabar.
Son bastate comunes, tienen un puerto USB en el que podemos enchufar almacenamiento, y se pueden programar grabaciones.

Sin embargo, el primero que compramos no había manera de hacerlo funcionar.
Tiene menús para programar las grabaciones, pero la grabación nunca se llega a hacer; es indiferente si dejamos el aparato en funcionamiento o no, o variando el dispositivo de almacenamiento, no se hace la grabación.

Investigando reseñas en Amazon, esto aparece en la mayoría de dispositivos similares con un número de reseñas alto.
A saber si hacemos algo mal, pero parece un problema común.

Quizá poca gente graba y el control de calidad de los dispositivos baratos es nefasto.
No parecía una buena idea ir comprando cacharros similares hasta dar con uno que funcione.

### Televisores con grabador

Otra opción que vimos es que hay televisores que también permiten grabar, conectando un dispositivo de almacenamiento por USB también.
Esto se implementa poniendo dos sintonizadores en el TV, uno para poder ver la tele y otro para grabar mientras funciona el otro sintonizador.

Sin embargo, esto sólo está disponible en teles de gama alta *y más importante*, a partir de cierto tamaño.
El familiar tiene un mueble antiguo donde pone la TV, y es un problema poner un televisor de más de 32".
¡No he sido capaz de encontrar ningún televisor de 32" o menos con esta funcionalidad!

Si no tenéis el problema del espacio y no os importa comprar una tele de gama alta, aunque me da mala espina por la mala experiencia con los dispositivos TDT que no nos han funcionado, confío que los televisores de marcas con reputación podrán grabar.

### Dispositivo Android TV con receptor TDT

Buscando, encontré [este dispositivo](https://weareyouin.com/es-es/p/you-box-tdt), con Android TV y un sintonizador.
También probé a comprarlo, pero lo devolvimos por lo mismo que el otro dispositivo: se podían programar las grabaciones, pero no había manera de que funcionasen.
Una lástima, porque en otros países parece ser que hay dispositivos parecidos que funcionan.
Además, el aparato también tiene funciones de Smart TV que van bastante bien, y parecía una buena solución.

## Otras opciones

Hay otros países donde parece que es más común seguir grabando de la TV.
En EEUU son populares los HDHomeRun, que tienen funcionalidades bastante majas (a parte de funcionar con el televisor, hacen streaming a otros dispositivos; se pueden controlar por aplicaciones, etc.).
En Inglaterra he encontrado cosas parecidas.

Sin embargo, se han de comprar al extranjero, y parecen más problemáticos de conseguir aquí, tener garantía, certeza que funcionan en España, etc.

## Primer intento

OADesde hace tiempo que tengo una Raspberry Pi con una sintonizadora USB, que utilizo con LibreElec + Kodi + TVHeadend.
LibreElec es un sistema operativo fácil de instalar en Raspberry que integra Kodi y TVHeadend.
Kodi es un interfaz para televisores con reproductor de medios, que se integra con TVHeadend.
TVHeadend es un software para grabar TDT en un ordenador, mediante una sintonizadora.

A mí me funciona de maravilla para grabar de cuando en cuando películas.
Además, hay aplicaciones para controlarlo (mucho más cómodo que con un mando de TV).
También es fácil hacer streaming y ver grabaciones desde otros dispositivos.

Primero probé con un [Raspberry Pi TV HAT](https://www.raspberrypi.com/products/raspberry-pi-tv-hat/) y LibreElec + Kodi + TVHeadend sobre Raspbian.

## Solución actual

Ahora usa una [aplicación de Android TV que permite hacer de interfaz de TVHeadend, integrado en Android TV](https://dreamepg.de/index.php/en/apps/tvheadend/playertv).
Es más fácil de usar que Kodi.

Uso [un sistema propio para provisionar una Raspberry](https://github.com/alexpdp7/raspberry-pi-headless-provision), instalando Debian y TVHeadend.

El HAT no es compatible con Debian, sólo con Raspbian y similares.
Así, he pasado el HAT a mi Raspberry con LibreElec y he puesto un sintonizador nuevo en la Raspberry del familiar.

El familiar controla TVHeadend con dream Player TV for TVheadend en la Android TV y con el interfaz web de TVHeadend en un portátil.

También he puesto un script cutre para montar un túnel SSH para poder hacer soporte en remoto.

Esto funciona más o menos bien, pero:

* Debian en la Raspberry tarda como tres minutos en arrancar.
* Hay que pelearse bastante para sintonizar los canales bien.
* La guía no es del todo robusta.
* TVHeadend no funciona muy bien con grabaciones solapadas.

De momento el familiar va tirando con Tivify como plan B.
