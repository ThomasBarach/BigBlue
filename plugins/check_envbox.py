#!/usr/bin/env python
# -*- coding: utf-8 -*-

import system
from easysnmp import snmp_get

def do_snmpget(*args):
	snmp_get(oid, hostname=host, community='eikeo', version=2)
	
if __name__ == '__main__':
	parser = argparse.argumentParser(description="Check Envbox")
	parser.add_argument('parameter', help = 'Parameters : Temperature, Fan, and so on..')
	parser.add_argument('identifier', help = 'Probe ID')
	parser.add_argument('address', help = 'Ip address')
	
	args = parser.parse_args()

	

