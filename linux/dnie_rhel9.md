# Usando el DNIe en CentOS 9 Stream

El RPM que anuncian para Fedora/SuSE funciona bien en CentOS 9 Stream.
Pero depende de un paquete deprecado "pinentry-gtk2".
No es necesario este paquete para el correcto funcionamiento, así que podemos usar `create-fake-rpm` para crear un paquete falso que nos permita instalar el RPM del DNI electrónico.

```
sudo dnf install create-fake-rpm
create-fake-rpm --build pinentry-gtk2 pinentry-gtk2
sudo dnf install noarch/fake-pinentry-gtk2-0-0.noarch.rpm https://www.dnielectronico.es/descargas/distribuciones_linux/libpkcs11-dnie-1.6.8-1.x86_64.rpm
```

Una vez hecho esto, cargar `/usr/lib64/libpkcs11-dnie.so` como nuevo "security device" en Firefox.
