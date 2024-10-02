class jellyfin {
    exec {'/usr/bin/apt install -y apt-transport-https && wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add - && echo "deb [arch=amd64] https://repo.jellyfin.org/debian bookworm main" | sudo tee /etc/apt/sources.list.d/jellyfin.list && apt update && apt install -y jellyfin':
        creates => '/usr/share/doc/jellyfin/README.Debian',
    }
}