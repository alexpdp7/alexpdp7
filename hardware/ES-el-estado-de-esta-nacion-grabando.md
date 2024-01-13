# El estado de esta nación grabando

## Introducción

Un familiar está encantado con su "vídeo" de hace ya muchos años.
El vídeo es un receptor de TDT con disco duro (y DVD-RW) con el que puede grabar programas emitidos por TDT en España.
Está acostumbrado a ver la tele y grabar, y hasta muy recientemente no han tenido Internet en casa, por lo que no están acostumbrados a usar plataformas tipo Netflix.

El vídeo es antiguo y sólo puede grabar programas "SD" (de "baja" calidad).
Al comenzar la TDT, la mayoría de canales eran SD, y sólo algunos canales tenían variante SD y HD (e.g. Televisión Española).

Ahora por 2024, está planteado eliminar los canales SD para ir introduciendo canales 4K y varias cosas más.
Ya se han retirado algunos canales SD, creo.

Por tanto, el vídeo que usa mi familiar dejará de ser útil en breve.

## Alternativas "distintas"

El familiar comienza a usar Amazon Prime y alguna otra plataforma, pero no acaba de acostumbrarse y sigue grabando.

Una posible alternativa sería algún servicio como [Tivify](https://www.tivify.tv/), que permite ver canales tradicionales de TDT como una plataforma de streaming normal y permite reproducir programas de los días anteriores.
Esto sería incluso más práctico, ya que no haría falta programar grabaciones.
Existen servicios parecidos (Movistar+ incluye un servicio similar).
La única desventaja es que tiene un coste mensual, y investigando sobre este tema, me he encontrado a gente en situaciones familiares que lo han probado y no se han "apañado".

Otra opción es HbbTV, conocido en España como LovesTv.
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

## Primera solución casera

Desde hace tiempo que tengo una Raspberry Pi con una sintonizadora USB, que utilizo con LibreElec + Kodi + TVHeadend.
LibreElec es un sistema operativo fácil de instalar en Raspberry que integra Kodi y TVHeadend.
Kodi es un interfaz para televisores con reproductor de medios, que se integra con TVHeadend.
TVHeadend es un software para grabar TDT en un ordenador, mediante una sintonizadora.

A mí me funciona de maravilla para grabar de cuando en cuando películas.
Además, hay aplicaciones para controlarlo (mucho más cómodo que con un mando de TV).
También es fácil hacer streaming y ver grabaciones desde otros dispositivos.

Tenía una Raspberry Pi por ahí sin usar, así que decidí comprar un [Raspberry Pi TV HAT](https://www.raspberrypi.com/products/raspberry-pi-tv-hat/).
Tenía bastante reticencia a comprar un sintonizador USB, porque tiene que funcionar en Linux para que el invento funcione.
Hay listas de compatibilidad, pero no están muy actualizadas y en general es complicado encontrar las que están probadas en España.
Sin embargo, el TV HAT es muy popular con gente que usa Raspberries, así que la compatibilidad estaba prácticamente asegurada (veremos más adelante que esto tiene matices).

Le monté LibreElec con la Raspberry y el HAT y... el familiar no se apañó.
Tiene cierto sentido, porque hay que ir a la entrada de HDMI de la Raspberry en el televisor, aclararse con el interfaz de Kodi (que está bien, pero no es óptimo para gente mayor), y grabar y ver.

## Segunda solución casera

Encontré una [aplicación de Android TV que permite hacer de interfaz de TVHeadend, integrado en Android TV](https://dreamepg.de/index.php/en/apps/tvheadend/playertv).
La probé y es bastante más fácil de usar que Kodi.

Mi idea era montar TVHeadend en la Raspberry, sin Kodi, y conectar la aplicación.

### Interludio friki

Pensé que sería interesante poder acceder remotamente a la Raspberry para hacer soporte si fuera necesario.
Además, me gusta provisionar máquinas y servicios automatizadamente, y me decidí a investigar esto.

Lo primero que descubrí es que Raspberry Pi OS, antes conocido como Raspbian, tiene funcionalidades un poco primitivas para provisionado automático.
Así que me decidí por usar Debian (que es la base de Raspberry Pi OS).
Esto es guay, porque [he encontrado maneras de provisionar la Raspberry con Debian que me gustan](https://github.com/alexpdp7/raspberry-pi-headless-provision) y con las que creo que puedo construir la solución que necesito.

Pero he descubierto que el TV HAT y la Raspberry necesitan bastantes ajustes en el sistema operativo para funcionar.
En Debian, el TV HAT no está soportado directamente.

#### Debian vs. Raspberry Pi OS

Las Raspberries están muy bien, pero son un hardware bastante especialito.
Para empezar, la 5 es la primera que tiene un reloj con batería, que me ha causado más problemas de los que debería.
La Raspberry no está soportada por muchos sistemas operativos directamente (Debian no la soporta oficialmente).

Raspberry Pi OS no me inspira muchísima confianza tampoco.

Así que las Raspberries siempre me tocan un poco la moral.
Son muy baratas, pero muchas veces me planteo si valen la pena, pudiendo conseguir PCs estándar mucho más fáciles de soportar.
Creo que las mayores ventajas de las Raspberries es lo fácil que es experimentar con cambiar la microSD del sistema operativo, y su tamaño y consumo.

### Estado actual

El HAT no funciona en Debian, así que he pasado el HAT a mi Raspberry, que se quedará en LibreElec que lo soporta perfectamente.
Así libero el sintonizador TDT USB que estaba usando.

El plan es instalar Debian, montar un provisionado remoto chulo para soporte, ponerle TVHeadend e integrarlo con el Smart TV con Android TV del familiar.

## Otras opciones para futuro

* Tivify
* Convencer al familiar de que use plataformas y apps
* Buscar otros dispositivos
