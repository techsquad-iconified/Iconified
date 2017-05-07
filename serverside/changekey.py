import sys
f = open('thenum.js','w')
f.write("module.exports =" + sys.argv[1] + ";")

