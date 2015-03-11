#!/usr/bin/env python

import json
import sys

from oslo_config import cfg

LOCAL_OPTS = [
    cfg.StrOpt("conf",
               short="c",
               required=True,
               help="Configuration template"),
    cfg.StrOpt("filename",
               short="f",
               required=True,
               help="Filename for all variables with their values"),
]

OPTS = []


def split_local_args():
    LOCAL_ARGS = []
    EXTERNAL_ARGS = []
    argc = len(sys.argv)
    for i in xrange(argc):
        if sys.argv[i] == "--":
            LOCAL_ARGS = sys.argv[:i]
            EXTERNAL_ARGS = sys.argv[i:]
            return LOCAL_ARGS, EXTERNAL_ARGS
    return sys.argv, []


def create_stropt(tmpl):
    for var in tmpl:
        val = tmpl[var]

        OPTS.append(cfg.StrOpt(
            val["name"],
            short=val["short"],
            required=True,
            default=val["default"],
            help=val["help"] + " ( Default: '" + val["default"] + "' )"))


def write_values(tmpl, name):

    f = open(name, 'w+')

    for var in tmpl:
        val = tmpl[var]

        s = var + "=" + str(cfg.CONF.get(val["name"])) + "\n"
        f.write(s)

    f.close()


def main():

    conf = cfg.CONF

    # Parse our local args

    conf.register_cli_opts(LOCAL_OPTS)
    conf.register_opts(LOCAL_OPTS)

    LOCAL_ARGS, EXTERNAL_ARGS = split_local_args()

    sys.argv = LOCAL_ARGS

    try:
        conf()
    except cfg.RequiredOptError as e:
        print('Error: %s' % e)
        conf.print_usage()
        exit(1)

    tmpl = json.loads(cfg.CONF.conf)
    filename = cfg.CONF.filename

    conf.reset()
    conf.unregister_opts(LOCAL_OPTS)

    # Parse external args

    sys.argv = EXTERNAL_ARGS

    create_stropt(tmpl)

    conf.register_cli_opts(OPTS)
    conf.register_opts(OPTS)

    try:
        conf()
    except cfg.RequiredOptError as e:
        print('Error: %s' % e)
        conf.print_usage()
        exit(1)

    write_values(tmpl, filename)

    return 0


if __name__ == '__main__':
    exit(main())
