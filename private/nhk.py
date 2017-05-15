#!/usr/bin/env python

import os, sys, re, json, urllib2, gzip, StringIO;
from pprint import pprint;

def get_by_id(the_list, the_id):
    for i, val in enumerate(the_list):
        if val["airingId"] == the_id:
          return val
    raise Exception("Program not found with airing id: " + the_id)

def get_id(val):
  return val["airingId"].strip()

def get_uniq_id(meta):
    a_id = str(meta["airingId"])
    title = get_title(meta)
    raw_id = (a_id + " " + title)
    return re.sub(r"[^a-zA-Z0-9]+", ".", raw_id)

def get_nhk():
    the_dir = sys.argv[1].strip()
    return get_list(the_dir + "/nhk.json")

def get_list(f):
    the_list = get_json(f)
    return the_list["channel"]["item"]

def get_json(f):
    f = open(f, "r")
    txt = f.read()
    return json.loads(txt)

def get_full(meta):
    return '{{' + get_title(meta) + "}} " + get_duration(meta) + "\n" + get_desc(meta)

def get_dur_secs(meta):
    begins = int(meta["pubDate"])/1000
    ends   = int(meta["endDate"])/1000
    duration = (ends - begins)
    return duration

def get_dur(meta):
    duration = (get_dur_secs(meta))/60
    return duration

def get_duration(meta):
    return "(" + str(get_dur(meta)) + " mins)"

def get_desc(meta):
    return meta["description"].strip()

def get_title(meta):
    title = meta["title"].strip()
    subtitle = (meta["subtitle"] or "").strip()
    if meta["subtitle"] == "":
        return title
    else:
        return title + " : " + subtitle

if sys.argv[1] == "--json":
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

    the_action = sys.argv[2].strip()

    if the_action == "titles":
      the_list = get_nhk()
      for i, val in enumerate(the_list):
          print get_id(val) + ": " + get_title(val)

    elif the_action == "all":
        the_list = get_nhk()
        key = sys.argv[3].strip()
        for i, entry in enumerate(the_list):
            print str(entry[key]) + " : " + get_title(entry)

    elif the_action == "meta":
        the_list = get_nhk()
        v = the_list[0]
        keys = v.keys()
        keys.sort()
        for i, k in enumerate(keys):
            print k + " : " + repr(v[k])

    elif the_action == "key":
        the_list = get_nhk()
        v = the_list[0]
        print v[sys.argv[3].strip()]

    elif the_action == "keys":
        the_list = get_nhk()
        keys = the_list[0].keys()
        keys.sort()
        print ", ".join(keys)

    elif the_action == "desc":
        the_list = get_nhk()
        the_id = sys.argv[3].strip()
        print get_full(get_by_id(the_list, the_id))

    elif the_action == "current":
        the_list = get_nhk()
        print get_full(the_list[0])

    elif the_action == "next":
        the_list = get_nhk()
        print get_full(the_list[1])

    elif the_action == "record-info":
        the_list = get_nhk()
        the_id = sys.argv[3].strip()
        val = get_by_id(the_list, the_id)
        begins = int(val["pubDate"])/1000
        print str(begins) + " " + str(get_dur_secs(val)) + " " + get_uniq_id(val) + " " + get_id(val)

    else:
      raise Exception("Invalid option: " + repr(the_action))



