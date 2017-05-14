#!/usr/bin/env python
#  nhk.py --json
#  nhk.py file.json titles        # Prints: NUM TITLE : SUBTITLE
#  nhk.py file.json desc      NUM
#  nhk.py file.json record-at NUM # Prints: START SECONDS

import os, sys, re, json, urllib2, gzip, StringIO;
from pprint import pprint;

def get_full(meta):
    return get_title(meta) + " " + get_duration(meta) + "\n" + get_desc(meta)

def get_dur(meta):
    begins = int(meta["pubDate"])/1000
    ends   = int(meta["endDate"])/1000
    duration = (ends - begins)/60
    return duration

def get_duration(meta):
    return "(" + str(get_dur(meta)) + " mins)"

def get_desc(meta):
    return meta["content_clean"].strip()

def get_title(meta):
    if meta["subtitle"] == "":
        return meta["title"]
    else:
        return meta["title"] + " : " + meta["subtitle"]

if sys.argv[1] == "--file":
    resp = urllib2.urlopen("http://api.nhk.or.jp/nhkworld/epg/v6/world/now.json?apikey=EJfK8jdS57GqlupFgAfAAwr573q01y6k");
    raw  = resp.read().strip()
    try:
        gzipped = StringIO.StringIO(raw)
        decoded = gzip.GzipFile(fileobj=gzipped).read()
        print decoded.strip()
        # the_json = json.loads(decoded);
    except IOError:
        print raw.strip()
else:
    the_file = sys.argv[1].strip()
    f = open(the_file, "r")
    the_json = json.loads(f.read());

    the_list = the_json["channel"]["item"]
    the_action = sys.argv[2].strip()

    if the_action == "titles":
      for i, val in enumerate(the_list):
          print str(i) + ": " + get_title(val)

    elif the_action == "all":
        key = sys.argv[3].strip()
        for i, entry in enumerate(the_list):
            print str(entry[key]) + " : " + get_title(entry)

    elif the_action == "meta":
        v = the_list[0]
        keys = v.keys()
        keys.sort()
        for i, k in enumerate(keys):
            print k + " : " + repr(v[k])

    elif the_action == "key":
        v = the_list[0]
        print v[sys.argv[3].strip()]

    elif the_action == "keys":
        keys = the_list[0].keys()
        keys.sort()
        print ", ".join(keys)

    elif the_action == "desc":
        the_index = int(sys.argv[3].strip())
        print get_full(the_list[the_index])

    elif the_action == "current":
        print get_full(the_list[0])

    elif the_action == "next":
        print get_full(the_list[1])

    elif the_action == "record-at":
        the_index = int(sys.argv[3].strip())
        val = the_list[the_index]
        begins = int(val["pubDate"])/1000
        print str(begins) + " " + str(get_dur(val))

    else:
      raise Exception("Invalid option: " + repr(the_action))



