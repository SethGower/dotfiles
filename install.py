#!/usr/bin/env python3
from __future__ import print_function
import subprocess as sp
from sys import argv, stderr, stdout
import os


def eprint(*args, **kwargs):
    print(*args, file=stderr, **kwargs)


def shell(cmd):
    return sp.run(cmd, shell=True)


def install_requirements(package):
    cmd = "$(which bash) {}/install.sh".format(package)
    shell(cmd)


def stow_package(package):
    cmd = "stow --dir={} --target={} package".format(
        package, os.environ["HOME"])
    shell(cmd)


def main():
    if len(argv) == 1:
        eprint("Usage error! Please provide modules to install!")
        eprint("Example: '{} i3 polybar xorg neovim'".format(argv[0]))
        exit(1)
    packages = [package for package in os.listdir(
        '.') if os.path.isdir(package)]
    release = {}
    with open("/etc/os-release", "r") as f:
        for line in f:
            s = line.replace("\n", "").replace("\"", "").split("=")
            release[s[0]] = s[1]
    os.environ["OS"] = release["ID"]

    for package in argv[1:]:
        if not package in packages:
            eprint("Invalid Package name: {}".format(package))
        else:
            install_requirements(package)
            stow_package(package)


if __name__ == "__main__":
    main()
