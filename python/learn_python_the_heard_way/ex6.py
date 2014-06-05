#! /bin/python

x = "There are %d bytes of people." % 10
binary = "binary"
do_not = "don't"
y = "Those who know %s and those wh %s." % (binary, do_not)
print y
print "I said: %r." % x
print "I also said: '%s'" % y
hilarious = False
joke_evalution = "Isn't that joke so funny?! %r"

print joke_evalution % hilarious

w = "This is the left side of..."
e = "a string with a right size."

print w + e
