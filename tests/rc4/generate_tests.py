#!/usr/bin/python

from random import randint
import os

def writeRand(handle, length):
	handle.write(bytes([randint(0,0xff) for k in range(length)]))

def mkTest(filename, length):
	with open(filename+'.key', 'wb') as handle:
		writeRand(handle, 78)
		handle.close()
	with open(filename+'.data', 'wb') as handle:
		writeRand(handle, length)
		handle.close()

def fnameOfInt(num):
	if(num < 10):
		return 'testdir/0'+str(num)
	return 'testdir/'+str(num)

def main():
	if(not os.path.isdir("testdir")):
		os.mkdir('testdir')
	sizes = [ (10, 8), (15, 16), (40, 1024), (21, 4096),
			  (13, 1<<16), (1, 1<<22) ]

	cId = 0
	for (num, size) in sizes:
		for k in range(num):
			mkTest(fnameOfInt(cId), size)
			cId += 1

if(__name__=='__main__'):
	main()
