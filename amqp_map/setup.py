#!/usr/bin/env python

import os
import sys

from numpy.distutils.core import setup
from numpy.distutils.misc_util import Configuration

def configuration(parent_package='', top_path=None):
    config = Configuration('amqp_map', parent_package, top_path)

    config.add_data_dir('example')

    return config


if __name__ == '__main__':
    setup(**configuration(top_path='').todict())
