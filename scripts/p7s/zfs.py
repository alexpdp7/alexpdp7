import subprocess


def update_zfs():
    version = subprocess.run(["rpm", "-q", "zfs-dkms", '--queryformat=%{VERSION}'], check=True, stdout=subprocess.PIPE, encoding="utf8").stdout
    subprocess.run(["sudo", "dkms", "install", f"zfs/{version}"], check=True)
