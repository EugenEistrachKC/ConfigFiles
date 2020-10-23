#!/usr/bin/python

import csv
import sys
import http.client
import re

def load_environment(env):
    environments = {}
    with open("config.csv") as config_file:
        reader = csv.DictReader(config_file)
        for row in reader:
            environments[row["env"]] = row
    if env in environments:
        return environments[env]
    return None

def load_users(filename):
    users_list = []
    try:
        with open(filename) as users_file:
            reader = csv.DictReader(users_file)
            for row in reader:
                users_list.append(row)
    except IOError:
        return None
    return users_list

def load_template():
    with open("template.xml") as template_file:
        return template_file.read()

def post(url, path, port, data):
    conn = http.client.HTTPSConnection(url.rstrip(), port=port)
    conn.request('POST', path.rstrip(), data)
    response = conn.getresponse().read().decode()
    conn.close()
    if "<ns2:Status>OK</ns2:Status>" in response:
        return "OK"
    p = re.findall(r"faultstring.*>(.*)</faultstring>", response)
    if len(p) > 0:
        return p[0]
    else:
        return response

if len(sys.argv) != 3:
    print("Incorrect usage")
    exit(1)

env = load_environment(sys.argv[2])

if env is None:
    print("Environment '" + sys.argv[2] + "' does not exist in config")
    exit(2)

users = load_users(sys.argv[1])

if users is None:
    print("Can not open " + sys.argv[1])
    exit(3)

template = load_template()

for user in users:
    message = template\
        .replace("__SECUSERNAME__", env["sec-username"])\
        .replace("__SECPASSWORD__", env["sec-password"])\
        .replace("__ENCRYPTEDPASSWORD__", env["encrypted-user-password"])\
        .replace("__EMAIL__", user["email"])\
        .replace("__FIRSTNAME__", user["firstname"])\
        .replace("__LASTNAME__", user["lastname"])\
        .replace("__BRAND__", user["brand"])\
        .replace("__B2BUNIT__", user["b2bUnit"])\
        .replace("__STORE__", user["store"])\
        .replace("__ROLE__", user["role"])\

    response = post(env["url"], env["path"], int(env["port"]), message)
    print(user["email"] + ": " + response)




