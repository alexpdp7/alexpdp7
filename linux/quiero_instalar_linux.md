# Quiero instalar Linux

Si estás leyendo esto, es porque estás pensando en pasar tu ordenador a Linux.

¡Excelente!

En este documento recojo mis consejos para los que estáis en esta situación.

## No es necesario pasarse a Linux

Vaya por delante que aunque llevo usando Linux en mis ordenadores personales desde los inicios de siglo, y laboralmente más de una década.
Linux es indudablemente uno de los mejores sistemas operativos que podemos usar en nuestros ordenadores personales, especialmente si creemos que es mejor para nuestros intereses usar software libre.

Sin embargo:

* Usar Linux sigue siendo algo más complicado que usar Windows, macOS, ChromeOS, Android y otros.
* Todos los fabricantes de ordenadores y componentes dedican un esfuerzo razonable a hacer funcionar sus productos en Windows.
  Muy pocos fabricantes hacen lo mismo para Linux.
  Aunque muchas veces los desarrolladores de Linux consiguen hacer funcionar hardware, escoger hardware con buen soporte para Linux es prácticamente indispensable, y esto no garantiza una experiencia libre de problemas.

Aunque uso Linux, he usado Windows, macOS, ChromeOS y Android, y es perfectamente lícito usarlos.
Usando Linux seguramente aprendáis cosas nuevas y obtengáis beneficios, pero no siempre es lo mejor que podéis hacer con vuestro tiempo libre.

Sed conscientes que pasaros a Linux requerirá esfuerzo, tiempo e incluso dinero.

## No es necesario pasar nuestro único ordenador a Linux

La mejor manera de instalar Linux en la mayoría de casos es reemplazar el sistema operativo de un ordenador completamente.
(Se puede instalar Linux en paralelo a Windows, por ejemplo, y esto tiene ventajas, pero también es una fuente de quebraderos de cabeza.)

Esto quiere decir que hasta que no tengamos Linux funcionando, el ordenador donde estemos jugando seguramente estará inservible.
Podemos tener problemas de instalación que nos impidan usar Linux, o incluso una vez instalado, podría no gustarnos.

Para hacer pruebas, recomiendo siempre considerar las siguientes posibilidades:

* Probar Linux en una máquina virtual.

  La mayoría de ordenadores hoy en día tienen suficientes recursos para crear una máquina virtual.
  Una máquina virtual es un ordenador dentro de nuestro ordenador donde podemos instalar un sistema operativo distinto.

  Instalar Linux en una máquina virtual es más sencillo que instalarlo en hardware real (en general, nunca hay problemas de compatibilidad de hardware).
  Aunque el rendimiento de Linux será menor al que tendrá instalado directamente en el hardware, nos permite hacernos una idea de lo que implica usar Linux antes de dar el salto.

* Usar un ordenador secundario del que no dependemos.

  En general, es posible encontrar ordenadores que no están en uso.
  Recomiendo cualquier ordenador con cuatro gigas de RAM y un SSD para hacer pruebas.

  Además, tener un ordenador para hacer pruebas siempre nos servirá para otra cosa, como sustituir temporalmente nuestro ordenador principal averiado u otros.

  Si no disponemos de uno, considerar examinar las tiendas de segunda mano.
  No suele ser complicado encontrar ordenadores de segunda mano usables a un precio asequible, incluso de modelos cuyo fabricante soporta el uso de Linux, como algunos ThinkPads, HP y Dell.

* Probar Linux "live".

  La mayoría de distribuciones Linux tienen una versión "live" que permite ejecutar Linux desde un disco USB sin modificar nuestra instalación existente.
  Esto es más conveniente para probar si un ordenador del que disponemos tiene buen soporte de Linux, pero también nos sirve para hacernos una idea del funcionamiento de Linux.

* Usar discos duros totalmente separados para diferentes sistemas operativos.

  La mayoría de sistemas permiten añadir un segundo disco duro y escoger cuál usar al arrancar el ordenador.
  Esto tiene un coste extra, y en muchos casos como la mayoría de los portátiles, añade la inconveniencia de un disco duro externo.
  Sin embargo, elimina la mayoría de los problemas del arranque dual e incluso los dispositivos separados (y especialmente los externos) nos pueden dar un plus de flexibilidad.

  (Es recomendable siempre que los sistemas operativos estén en un disco SSD conectado mediante un interfaz rápido, evitando versiones de USB anteriores a USB 3.)

Para un uso duradero de Linux, en general tampoco recomiendo el arranque dual, por ser una potencial fuente de problemas de fiabilidad difíciles de resolver.

El arranque dual permite que los dos sistemas operativos funcionen directamente sobre el hardware, lo que puede ser necesario para que el software en *ambos* sistemas operativos pueda acceder a todo el hardware al máximo rendimiento.
Sin embargo, la mayoría de sistemas operativos no están pensados para el arranque dual y, por ejemplo las actualizaciones pueden estropear el arranque dual.

Para un uso duradero de Linux, a parte de usar hardware separado, podemos considerar:

* El uso de máquinas virtuales, que adicionalmente pueden evitar problemas de compatibilidad de hardware.
  (No todo el hardware funciona con Linux, pero Linux casi siempre funciona perfectamente en una máquina virtual.)

  Windows además dispone de WSL, que es un mecanismo para integrar una máquina virtual Linux con Windows.

  También podemos correr Windows dentro de una máquina virtual en Linux, aunque la licencia que teníamos de Windows en general no es apta para este uso.

  Las máquinas virtuales tienen menor rendimiento y desventajas respecto a correr en el hardware directamente, aunque tienen otras ventajas.
  (Por ejemplo, es muy fácil hacer una copia de respaldo de una máquina virtual, en general podemos mover máquinas virtuales de un sistema a otro, y más.)

* La mayoría de software disponible en Linux se puede usar en otros sistemas operativos.
  Incluso hay proyectos específicos para ofrecer plataformas similares a Linux dentro de otros sistemas operativos.

## Como estar preparados para trastear con Linux

Siempre que uno utiliza un ordenador es importante tener bien controlados nuestros datos.
Esto es todavía más importante si queremos experimentar con distintos sistemas operativos como Linux.

Es recomendable que no tengamos ningún dato que solamente resida en un ordenador.
En condiciones normales, esto implica que un fallo de disco nos puede hacer perder datos valiosos.
Instalando Linux, en general, borraremos el disco o haremos operaciones que pueden hacer que perdamos estos datos temporal o permanentemente.

Es recomendable siempre tener varias copias de nuestros datos importantes, sea en la nube o en medios que tengamos físicamente.

Además, si tenemos varios ordenadores y dispositivos, suele ser muy conveniente poder acceder a nuestros datos desde todos los dispositivos.

Siempre es recomendable tener claro que podemos reinstalar o perder un ordenador sin sufrir por perder ningún dato.

Y en caso de necesidad, siempre es bueno conocer el proceso de reinstalación de Windows.

Muchos fabricantes incluyen una funcionalidad de recuperación de Windows que podemos conservar al instalar Linux (pero hay que prestar atención).
También suelen ofrecer descargar el instalador de Windows.
(Nunca está de más conocer el proceso de recuperación o instalación de Windows, pues siempre lo podemos necesitar sin ser usuarios de Linux.)

## No todos los ordenadores soportan bien Linux

Aunque Linux tiene una amplísima variedad de soporte de hardware, todavía tenemos muchos números de que el ordenador donde queramos instalar Linux nos dé problemas.

Es recomendable siempre buscar el modelo del ordenador y "Linux" para ver si encontramos otras personas que hayan usado el mismo modelo de ordenador con éxito en Linux.

Obviamente, con la inmensa variedad de ordenadores en el mercado, esto no siempre será posible.

Algunas empresas que trabajan con Linux prueban modelos de ordenador en colaboración algunos fabricantes y publican listas de ordenadores certificados, como por ejemplo:

* [Ubuntu](https://ubuntu.com/certified)
* [Red Hat](https://catalog.redhat.com/search?searchType=hardware&type=System&system_types=Desktop%2FWorkstation|Laptop&p=1)

Así mismo, algunos fabricantes venden modelos con Linux preinstalados.

Por supuesto, puede ser ventajoso poder reciclar hardware que ya tenemos, pero hoy en día hay bastante hardware con soporte para Linux y suele ser siempre una buena opción.

Como mencionábamos anteriormente, siempre antes de instalar es recomendable probar una versión "live" de Linux para comprobar si el hardware funciona bien en Linux.
Es recomendable siempre comprobar:

* Conexión a la red: deberíamos poder acceder a Internet con o sin cable según sea nuestra preferencia
* Sonido: que funcionen bien las salidas de audio que usemos (tomas de auriculares, altavoces, etc.).
* Vídeo: nunca está de más comprobar que podemos reproducir vídeo de YouTube a buena calidad a toda pantalla con fluidez.
* Accesorios: probar otros accesorios que usemos como auriculares bluetooth, impresoras, webcams, etc.

No es raro que funcione todo menos algún detalle, con lo que es mejor ser lo más exhaustivo posible.
Por ejemplo, hay webcams de portátil que no funcionan en Linux, y es un detalle fácil de pasar por alto.

## ¿Qué Linux usar?

Existe una infinita variedad de "distribuciones" de Linux y la elección es uno de los dilemas más populares entre los usuarios de Linux.

Además, es común que los usuarios de Linux sean entusiastas de ciertas distribuciones.

Siempre es recomendable dejarse asesorar, especialmente por personas que nos puedan ayudar ante ciertas dificultades.
Será siempre más fácil ayudarnos con una distribución con la que estamos familiarizados.

Sin embargo, hay que considerar que hay diversos grados de dificultad en las distribuciones Linux, y los usuarios avanzados a menudo escogen distribuciones más complejas para aprovechar sus peculiaridades.

Hay una serie de criterios a observar al escoger una distribución:

* Que tenga versión "live" para poder probar nuestro hardware.
* Que sea muy popular en Internet.
  Muchos problemas tienen soluciones distintas según la distribución que usemos.
  Siempre es más fácil seguir instrucciones para la misma distribución.
* Diferentes distribuciones tienen políticas distintas sobre distribuir software no libre:

  * La distribución distribuye software no libre sin diferenciarlo del software libre.
  * La distribución distribuye software no libre, aunque haya que activarlo o hacer alguna pequeña configuración.
  * La distribución no distribuye software no libre, pero hay entidades que empaquetan software no libre para esta distribución.
  * La distribución no distribuye software no libre, no hay entidades que empaqueten software no libre para esta distribución, o hay cierta hostilidad al uso de software no libre entre la comunidad.

  Esto puede no parecer importante, pero es más común de lo que parece que ciertos dispositivos hardware o algunas funcionalidades dependan de software no libre y esto nos suponga un problema en ciertas distribuciones.

Otro criterio importante pero más complejo es la política de versiones de la distribución.

### Distribuciones Linux de soporte prolongado

Hay distribuciones de soporte prolongado, como Ubuntu (LTS), Debian (stable) o Red Hat Enterprise Linux (y derivados) que sacan una versión nueva cada 2-3 años y se comprometen a soportar esa versión durante un periodo largo de tiempo.

Esto quiere decir que el software que llevan puede no estar muy al día y que podemos tener problemas de soporte de hardware, especialmente para hardware muy moderno.
Sin embargo, respecto a distribuciones con ciclos de vida más cortos, ofrece la gran ventaja de que las actualizaciones rutinarias son más sencillas y conllevan menos riesgo de problemas.

Si encontramos una distribución Linux con soporte prolongado que soporta bien nuestro hardware, recomiendo comenzar con una distribución así mientras aprendemos Linux.

Cada varios años tendremos que aplicar una actualización grande, pero en general, como estas actualizaciones son poco frecuentes, se prueban más ampliamente.

(Las distribuciones de soporte prolongado también tienen actualizaciones de software, claro, pero intentan sólo sacar actualizaciones de seguridad o corrección de errores, excluyendo actualizaciones que introduzcan grandes cambios.)

### Distribuciones Linux de soporte breve

Otras distribuciones, como Fedora y Ubuntu (no LTS), sacan una versión nueva con mayor cadencia (cada 6 meses, típicamente), y el soporte para versiones no recientes decae rápidamente.

Estas distribuciones tienen software más actualizado, pero por contra, tendremos que aplicar con más frecuencia actualizaciones grandes que pueden ser más problemáticas.

Es cierto que estas distribuciones también prueban mucho las actualizaciones, y que al ser actualizaciones grandes más frecuentes en teoría deberían tener menos riesgo, pero recomiendo sólo usar distribuciones de soporte breve si funcionan en nuestro hardware y las de soporte prolongado no.

### Distribuciones Linux de versionado continuo

Otras distribuciones, como Arch o Debian (testing y otras) no tienen versiones, se actualiza todo su software continuamente, con actualizaciones de seguridad y corrección de errores, pero también grandes cambios.

Las distribuciones de versionado continuo son idóneas si necesitamos el software más actualizado o queremos contribuir probando actualizaciones, pero no las recomiendo a no ser que se sea un usuario experimentado de Linux.

## ¿Cómo instalar Linux?

Por lo general, hoy en día todas las distribuciones Linux contienen instrucciones para descargar el instalador de la distribución y grabarlo en un disco USB.

Estas instrucciones, si no queremos complicarnos la vida, borran el contenido del USB y lo reemplazan completamente, con lo que debemos usar un USB que no contenga datos importantes.

La mayoría de instaladores tienen funcionalidad "live".
Es muy recomendable probar todas las funcionalidades que podamos con la versión "live" de la manera más exhaustiva posible antes de hacer la instalación definitiva.

Si el instalador no es "live", normalmente podremos encontrar una versión alternativa para la misma distribución, o en el peor caso, probar con el "live" de otra distribución.

La distribución debería documentar adecuadamente el proceso de instalación, pero casi siempre consiste en:

* Configurar el ordenador para arrancar el instalador en vez del sistema operativo que ya tenemos instalado.
  Esto en general se hace con lo que se suele llamar "BIOS", a la que accedemos pulsando una tecla específica durante el proceso de arranque.
  Si nuestro sistema actual es Windows, las versiones modernas tienen funcionalidades de arranque rápido que pueden interferir con la selección de arranque.
  Es posible que necesitemos consultar instrucciones más específicas para cambiar el arranque.

* Probar el sistema en el entorno "live" y luego seleccionar una opción para hacer la instalación definitiva.

* Escoger el nombre del ordenador, de nuestro usuario y otras opciones durante el proceso de instalación.

* Una opción importante es si queremos que Linux y nuestro sistema operativo existente (típicamente Windows) coexistan o reemplazar el sistema operativo existente completamente con Linux.
  Anteriormente en este documento se detallan recomendaciones sobre evitar la coexistencia de varios sistemas operativos en un mismo disco duro.

### ¿Qué problemas puede haber?

#### Problemas de medios USB

Los discos USB tienen un amplio abanico de calidades.

No es tan raro encontrar USB defectuosos que pueden causar que el proceso de instalación falle.

Además, aunque es poco común, la descarga del instalador puede no funcionar adecuadamente.

Ante problemas extraños, siempre es recomendable:

* Verificar la descarga siguiendo las instrucciones de la distribución.
* Verificar el disco USB; muchos instaladores permiten hacer una verificación antes de empezar, algunos programas para grabar USB pueden hacer una comprobación después de grabar.

Aunque las verificaciones no encuentren problemas, sigue habiendo margen para el error.
Siempre es conveniente tener otro USB para hacer otra prueba, para descartar problemas.

#### Problemas de instalación

Incluso con un medio correcto, la instalación puede fallar.
Los instaladores pueden tener defectos inesperados o podemos toparnos con problemas temporales de la infraestructura de la distribución que impidan la instalación.

Una vez descartamos problemas de medios, es recomendable probar con otra distribución.

Tampoco es imposible que simplemente el ordenador que estemos usando tenga algún problema de hardware preexistente que sólo se manifieste durante el proceso de instalación, por someter al ordenador a una carga no habitual.

En general, todos los instaladores de Linux dan actualizaciones constantes del avance de la instalación.
Puede que el sistema se bloquee o no responda fluidamente, pero nunca más de unos minutos.

Si el sistema no responde durante varios minutos, tendremos que reiniciar el ordenador a la fuerza.
Si los problemas se repiten, lo mejor es probar con otro disco USB, verificar la descarga del instalador, o probar con otra distribución.

(Tendremos que volver a seleccionar el arranque del instalador.
Este proceso puede ser distinto; si antes lo hicimos desde Windows, una vez reemplazado Windows, tendremos que usar "la BIOS".)

### ¿Y si no me gusta?

Como mencionamos anteriormente, siempre debería ser posible volver a Windows.
Si nos hemos asegurado que nuestros datos estén protegidos, podemos reinstalar Windows de nuevo o usar las funcionalidades de recuperación.

## Instalando programas en Linux

Un ordenador y un sistema operativo no son más que medios para usar programas.
De hecho, las distribuciones de Linux se llaman distribuciones porque aparte de Linux en sí (que por sí mismo no sirve de mucho), empaquetan una colección de programas para que nuestro ordenador sea útil.

Por tanto, es importante saber qué programas necesitamos y cómo instalarlos en Linux.

Lo más fácil suele ser instalar los programas que empaqueta nuestra distribución.
Además, las actualizaciones de los programas instalados desde nuestra distribución están integradas con las actualizaciones del sistema, lo que supone una ventaja interesante respecto a otros sistemas operativos.

Sin embargo, ni la distribución más extensa puede contener todos los programas que pueda necesitar todo el mundo.
(Aunque en general, cualquiera puede pasar por un proceso para añadir el programa que quiera a una distribución, aunque en general empaquetar programas para distribuciones es de las maneras más complejas de distribuir software.)

Adicionalmente, las distribuciones (especialmente las de soporte prolongado[^1]) no siempre están al día con las últimas versiones del software que empaquetan.

[^1]: las distribuciones de soporte prolongado y muchas de soporte breve sólo incorporan actualizaciones de seguridad y corrección de defectos.
      Aunque esto supone sus ventajas, muchas veces nos impedirá tener acceso a las funcionalidades más nuevas de un programa.

La mayoría de distribuciones tienen páginas web donde podemos buscar un programa y ver qué versiones están empaquetadas en qué versión de la distribución, como por ejemplo:

* [Debian](https://www.debian.org/distrib/packages)
* [Ubuntu](https://packages.ubuntu.com/)
* [Fedora](https://packages.fedoraproject.org/)

Nota: los paquetes de una distribución en general sólo se deben usar en la misma distribución *y* versión de la distribución para la que está hecho el paquete.
Aunque a veces es posible aprovechar paquetes, no es recomendable si no sabemos bien cómo funciona.

Pero existen más mecanismos para instalar software.

### Sistemas de paquetes genéricos

Principalmente Flatpak y Snap son dos sistemas para instalar software que funcionan en muchas distribuciones.
A diferencia de los paquetes de una distribución, que sólo funcionan en esa distribución, un Flatpak o un Snap funcionarán en todas las distribuciones que estén soportadas ([aquí las distribuciones que soporta Flatpak](https://flatpak.org/setup/ "Instrucciones para instalar Flatpak en distribuciones soportadas") y [las soportadas por Snap](https://snapcraft.io/docs/installing-snapd "Instrucciones para instalar Snap en distribuciones soportadas")).

La ventaja indirecta para el usuario es que el autor de un programa (o cualquiera) puede hacer un Flatpak o un Snap e inmediatamente lo pueden usar usuarios de distintas distribuciones, sin tener que hacer el esfuerzo de empaquetarlo para todas las distribuciones.
Con esto, hay bastantes programas que están mejor mantenidos como Flatpak o Snap que en las distribuciones.

Sin embargo, mientras que ya confiamos implícitamente en nuestra distribución para tener programas libres de malicia (o al menos, si distribuyen programas maliciosos ya lo sufrimos), al añadir Flatpaks o Snaps debemos ser más cuidadosos, porque los programas pueden quedar desactualizados, el empaquetador no necesariamente es el autor del software, y un largo etcétera.

Flatpak y Snap incorporan mecanismos para aislar los programas de manera que no puedan tener efectos negativos sobre nuestro sistema (como código malicioso, por ejemplo), que pueden ser más avanzados que los mecanismos de protección de la mayoría de distribuciones.
Esto nos da cierta tranquilidad, pero puede causar problemas.
Tanto el hecho de que los Flatpak y Snaps funcionan bajo varias distribuciones como estos mecanismos de protección pueden causar algunos problemas en algunos programas.

A menudo pero no siempre, los Flatpak y Snap están integrados con las actualizaciones del sistema.

### Empaquetados de terceros

La mayoría de distribuciones dan mecanismos para que cualquiera pueda crear repositorios de paquetes alternativos.

Algunos programas proporcionan repositorios para algunas distribuciones, y hay grupos que se dedican a crear repositorios con programas adicionales para distribuciones específicas.

Usando estos repositorios, casi siempre conservamos que las actualizaciones de programas de estos repositorios se integran en las actualizaciones del sistema, con lo que es sencillo estar actualizado.

Cuando el repositorio está empaquetado por los autores del programa, en general mejora la confiabilidad del paquete.
En repositorios alternativos, nos tenemos que fiar más de quién mantiene el repositorio, aunque hay repositorios de terceros con un largo historial de confiabilidad y calidad.

### Distribuciones binarias

Algunos autores distribuyen versiones binarias de su programa, que funcionan de una manera similar a como se distribuye la mayoría de software en Windows o macOS.

Estos binarios suelen ser confiables y de calidad, pero principalmente ofrecen dos problemas:

* Los binarios no siempre funcionan en todas las distribuciones.
* Si el programa no incorpora un mecanismo de actualizaciones, tendremos que actualizar el programa manualmente.
