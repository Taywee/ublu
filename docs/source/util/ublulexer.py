#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright © 2016 Taylor C. Richberger <taywee@gmx.com>
# This code is released under the license described in the LICENSE file

import re

from pygments.lexer import RegexLexer
from pygments import token

_specialkeywords = ['CALL', 'CATCH', 'LOCAL', 'TASK', 'BREAK', 'RETURN', 'TASK', 'THROW', 'TRY', 'DO', 'FOR', 'in', 'IN', 'WHILE', 'FUN', 'FUNC', 'IF', 'THEN', 'ELSE', 'SWITCH']
_commands = ['as400', 'ask', 'bye', 'calljava', 'collection', 'commandcall', 'const', 'cs', 'db', 'dbug', 'defun', 'dict', 'dpoint', 'dq', 'eval', 'exit', 'file', 'ftp', 'gensh', 'help', 'histlog', 'history', 'h', 'host', 'ifs', 'interpret', 'include', 'jmx', 'job', 'joblist', 'joblog', 'jrnl', 'json', 'jvm', 'license', 'lifo', 'list', 'monitor', 'msg', 'msgq', 'num', 'objdesc', 'objlist', 'outq', 'ppl', 'printer', 'programcall', 'props', 'put', 'record', 'rs', 'savf', 'savef', 'server', 'sess', 'session', 'smapi', 'sock', 'spoolf', 'spoolflist', 'string', 'subsys', 'system', 'sysval', 'test', 'thread', 'tn5250', 'trace', 'tuple', 'usage', 'user', 'userlist']
_constants = ['AUTOSTART', 'BATCH', 'INTERACTIVE', 'SUBSYSTEM_MONITOR', 'SPOOLED_READER', 'SYSTEM', 'SPOOLED_WRITER', 'SCPF_SYSTEM', 'ALL']

def toregex(words):
    return r'\b(?:{})\b'.format('|'.join(re.escape(word) for word in words))

class UbluLexer(RegexLexer):
    name = 'Ublu'
    aliases = ['ublu']
    filenames = ['*.ublu']
    mimetypes = ['text/x-ublu']

    tokens = {
        'root': [
            (r'\s+', token.Text),
            (r'#!? .*?$', token.Comment),
            (r'0x[0-9a-fA-F]+|[0-9]+(\.[0-9]+)?(e[0-9]+(\.[0-9]+)?)?', token.Literal.Number),
            (r'-\S+', token.Operator.Word),
            (r'@\S+', token.Name.Variable),
            (r'\$\{\s.*?\s\}\$', token.String),
            (toregex(_specialkeywords), token.Keyword),
            (toregex(_commands), token.Keyword),
            (toregex(_constants), token.Keyword.Constant),
            (r'\S+', token.Text),
            ]
        }

