#!/usr/bin/env python3
import os
import json
import subprocess as sp
from xdg import BaseDirectory as bd


def shell(cmd):
    return sp.run(cmd, shell=True, stdout=sp.PIPE).stdout.decode("utf-8")


class State:
    def __init__(self):
        cmd = "xrandr | grep \" disconnected\" | sed -e \"s/\\([A-Z0-9]\\+\\) disconnected.*/\\1/\" | sed 's/ *$//'"
        self.disconnected = set(shell(cmd).strip().split("\n"))

        cmd = "xrandr | grep \" connected\" | sed -e \"s/\\([A-Z0-9]\\+\\) connected.*/\\1/\" | sed 's/ *$//'"
        self.connected = set(shell(cmd).strip().split("\n"))

        self.outputs = self.disconnected.union(self.connected)

        cmd = "xrandr | grep -e \" connected [^(]\" | sed -e \"s/\\([A-Z0-9]\\+\\) connected.*/\\1/\""
        self.active = set(shell(cmd).strip().split("\n"))

        cmd = "cat /proc/acpi/button/lid/LID**/state"
        self.lid = shell(cmd).split(':')[1].strip()
        print(self.lid)


class Configuration:
    def __init__(self, name, **params):
        self.name = name
        self.outputs = set(params['outputs'])
        if 'transition_output' in params:
            self.transition_output = params['transition_output']
        else:
            self.transition_output = None
        self.command = params['command']
        has_lid = 'lid' in params
        if has_lid:
            self.lid = params['lid']


class Config:
    def __init__(self, **params):
        self.configurations = [Configuration(name, **c) for name, c in
                               params['configurations'].items()]


config_file = bd.save_config_path("scripts/") + "displays.json"
config = None
with open(config_file, "r") as f:
    config = Config(**(json.load(f)))

state = State()
print("All outputs: {}".format(state.outputs))
print("Disconnected outputs: {}".format(state.disconnected))
print("Connected outputs: {}".format(state.connected))
print("Active outputs: {}".format(state.active))

for c in config.configurations:
    if c.outputs == state.connected:
        print("Using configuration: {}".format(c.name))
        if c.transition_output:
            cmd = "xrandr --output {} --auto".format(c.transition_output)
            for o in state.outputs:
                if not o == c.transition_output:
                    cmd += " --output {} --off".format(o)
            print("Transition output:\n {}".format(cmd))
            shell(cmd)
        cmd = c.command
        print("Configure outputs:\n {}".format(cmd))
        shell(cmd)
        break
