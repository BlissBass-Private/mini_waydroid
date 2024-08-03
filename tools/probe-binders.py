import logging
import os
import glob
import fcntl
import struct
import subprocess


BINDER_DRIVERS = [
    "anbox-binder",
    "puddlejumper",
    "bonder",
    "binder"
]
VNDBINDER_DRIVERS = [
    "anbox-vndbinder",
    "vndpuddlejumper",
    "vndbonder",
    "vndbinder"
]
HWBINDER_DRIVERS = [
    "anbox-hwbinder",
    "hwpuddlejumper",
    "hwbonder",
    "hwbinder"
]


def isBinderfsLoaded():
    with open("/proc/filesystems", "r") as handle:
        for line in handle:
            words = line.split()
            if len(words) >= 2 and words[1] == "binder":
                return True

    return False

def allocBinderNodes(binder_dev_nodes):
    NRBITS = 8
    TYPEBITS = 8
    SIZEBITS = 14
    NRSHIFT = 0
    TYPESHIFT = NRSHIFT + NRBITS
    SIZESHIFT = TYPESHIFT + TYPEBITS
    DIRSHIFT = SIZESHIFT + SIZEBITS
    WRITE = 0x1
    READ = 0x2

    def IOC(direction, _type, nr, size):
        return (direction << DIRSHIFT) | (_type << TYPESHIFT) | (nr << NRSHIFT) | (size << SIZESHIFT)

    def IOWR(_type, nr, size):
        return IOC(READ|WRITE, _type, nr, size)

    BINDER_CTL_ADD = IOWR(98, 1, 264)
    binderctrlfd = open('/dev/binderfs/binder-control','rb')

    for node in binder_dev_nodes:
        node_struct = struct.pack(
            '256sII', bytes(node, 'utf-8'), 0, 0)
        try:
            fcntl.ioctl(binderctrlfd.fileno(), BINDER_CTL_ADD, node_struct)
        except FileExistsError:
            pass

def probeBinderDriver():
    binder_dev_nodes = []
    has_binder = False
    has_vndbinder = False
    has_hwbinder = False
    for node in BINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_binder = True
    if not has_binder:
        binder_dev_nodes.append(BINDER_DRIVERS[0])
    for node in VNDBINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_vndbinder = True
    if not has_vndbinder:
        binder_dev_nodes.append(VNDBINDER_DRIVERS[0])
    for node in HWBINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_hwbinder = True
    if not has_hwbinder:
        binder_dev_nodes.append(HWBINDER_DRIVERS[0])

    if len(binder_dev_nodes) > 0:
        if not isBinderfsLoaded():
            devices = ','.join(binder_dev_nodes)
            command = ["modprobe", "binder_linux",
                       "devices=\"{}\"".format(devices)]
            output = subprocess.run(command, check=False, capture_output=True)
            if output.returncode:
                logging.error("Failed to load binder driver")
                logging.error(output.strip())

        if isBinderfsLoaded():
            command = ["mkdir", "-p", "/dev/binderfs"]
            subprocess.run(command, check=False)
            command = ["mount", "-t", "binder", "binder", "/dev/binderfs"]
            subprocess.run(command, check=False)
            allocBinderNodes(binder_dev_nodes)
            command = ["ln", "-s"]
            command.extend(glob.glob("/dev/binderfs/*"))
            command.append("/dev/")
            subprocess.run(command, check=False)

    return 0

def probeAshmemDriver():
    if not os.path.exists("/dev/ashmem"):
        command = ["modprobe", "-q", "ashmem_linux"]
        subprocess.run(command, check=False)

    if not os.path.exists("/dev/ashmem"):
        return -1
    
    return 0

def setupBinderNodes():
    has_binder = False
    has_vndbinder = False
    has_hwbinder = False
    probeBinderDriver()
    for node in BINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_binder = True
    if not has_binder:
        raise OSError('Binder node "binder" for waydroid not found')

    for node in VNDBINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_vndbinder = True
    if not has_vndbinder:
        raise OSError('Binder node "vndbinder" for waydroid not found')

    for node in HWBINDER_DRIVERS:
        if os.path.exists("/dev/" + node):
            has_hwbinder = True
    if not has_hwbinder:
        raise OSError('Binder node "hwbinder" for waydroid not found')

probeBinderDriver()
