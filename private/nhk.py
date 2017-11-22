#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, re, json, urllib2, gzip, StringIO;
import time
from pprint import pprint;

def epoch_time():
    return int(time.time())

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

def is_running(meta):
    starts = starts_at(meta)
    ends  = ends_at(meta)
    now = epoch_time()
    return(starts < now and ends > now)

def get_nhk():
    the_file = sys.argv[-1].strip()
    return get_list(the_file)

def get_list(f):
    the_list = get_json(f)
    return the_list["channel"]["item"]

def get_current(the_list):
    right_now = epoch_time()
    last_item = None;
    for i, item in enumerate(the_list):
        last_item = item
        if (ends_at(item) > right_now):
            return item
    return last_item

def get_next(the_list):
    right_now = epoch_time()
    last_item = None;
    for i, item in enumerate(the_list):
        last_item = item
        if (starts_at(item) > right_now):
            return item
    return last_item

def get_starts_at_mins(meta):
    return ((get_pub_epoch(meta) - epoch_time())/60)

def get_json(f):
    f = open(f, "r")
    txt = f.read()
    return json.loads(txt)

def get_full(meta):
    return get_title(meta) + " \n" + get_duration(meta)  + ", ID: " + get_id(meta) + "\n" + get_desc(meta)

def starts_at(meta):
    return int(meta["pubDate"])/1000

def ends_at(meta):
    return int(meta["endDate"])/1000

def get_pub_epoch(meta):
    return int(meta["pubDate"])/1000

def is_in_future(meta):
    return(starts_at(meta) > epoch_time())

def get_dur_secs(meta):
    begins   = starts_at(meta)
    ends     = ends_at(meta)
    duration = (ends - begins)
    return duration

def get_dur(meta):
    duration = (get_dur_secs(meta))/60
    return duration

def get_duration(meta):
    return str(get_dur(meta)) + " mins., starts in " + str(get_starts_at_mins(meta)) + " mins."

def get_desc(meta):
    return meta["description"].strip()

def get_plain_title(meta):
    return meta["title"].strip()

def get_title(meta):
    title    = get_plain_title(meta)
    subtitle = (meta["subtitle"] or "").strip()
    if meta["subtitle"] == "":
        return title
    else:
        return title + " : " + subtitle

def download_schedule():
    resp = urllib2.urlopen("https://api.nhk.or.jp/nhkworld/epg/v7/world/now.json?apikey=EJfK8jdS57GqlupFgAfAAwr573q01y6k");

    raw  = resp.read().strip()
      # Sometimes newlines are randomly included in the raw JSON output.
      # Even if you pipe this to tr, it will still output newlines for some reason.
      # So we save the entire output first (RAW), then delete newlines with tr.
      # Newlines in JSON will throw an error in Python.

    try:
        gzipped = StringIO.StringIO(raw)
        decoded = gzip.GzipFile(fileobj=gzipped).read()
        print decoded.strip()
        # the_json = json.loads(decoded);
    except IOError:
        print raw.strip()


the_action = sys.argv[1].strip()


if the_action == "seconds-left":
    the_list = get_nhk()
    item = get_current(the_list)
    print str(ends_at(item) - epoch_time())

elif the_action == "schedule-download":
    download_schedule()


elif the_action == "title":
  the_list = get_nhk()
  the_id = sys.argv[2].strip()
  if the_id == "title" or re.search(".json", the_id):
      print get_plain_title(get_current(the_list))
  elif the_id == "next":
      print get_plain_title(get_next(the_list))
  else:
      print get_by_id(the_list, the_id)["title"]

elif the_action == "titles":
  the_list = get_nhk()
  for i, val in enumerate(the_list):
      print u''.join((get_id(val) , ": " , get_title(val) , " ("  , get_duration(val) + ")")).encode('utf-8').strip()

elif the_action == "subtitles":
  the_list = get_nhk()
  for i, val in enumerate(the_list):
      print u''.join((get_id(val) , ": " , (val["subtitle"] or ""))).encode('utf-8').strip()

elif the_action == "all":
    the_list = get_nhk()
    key = sys.argv[2].strip()
    for i, entry in enumerate(the_list):
        print str(entry[key]) + " : " + get_title(entry)

elif the_action == "meta":
    the_list = get_nhk()
    v = get_current(the_list)
    keys = v.keys()
    keys.sort()
    for i, k in enumerate(keys):
        print k + " : " + repr(v[k])

elif the_action == "key":
    the_list = get_nhk()
    v = get_current(the_list)
    print v[sys.argv[2].strip()]

elif the_action == "keys":
    the_list = get_nhk()
    keys = get_current(the_list).keys()
    keys.sort()
    print ", ".join(keys)

elif the_action == "desc":
    the_list = get_nhk()
    the_id = sys.argv[2].strip()
    print get_full(get_by_id(the_list, the_id))

elif the_action == "current":
    the_list = get_nhk()
    print get_full(get_current(the_list))

elif the_action == "next":
    the_list = get_nhk()
    print get_full(get_next(the_list))

elif the_action == "nexts":
    the_list = get_nhk()
    for i, show in enumerate(the_list):
        if is_in_future(show):
            print get_id(show) + " " + get_plain_title(show) + " " + get_desc(show)

elif the_action == "record-info":
    the_list = get_nhk()
    the_id = sys.argv[2].strip()
    val = get_by_id(the_list, the_id)
    begins = int(val["pubDate"])/1000
    print str(begins) + " " + str(get_dur_secs(val)) + " " + get_uniq_id(val) + " " + get_id(val)

else:
  raise Exception("Invalid option: " + repr(the_action))



