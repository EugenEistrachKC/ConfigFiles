#!/usr/bin/python

import csv
import sys
import http.client
import re
import ssl

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
    try:
        with open("template.xml") as template_file:
            return template_file.read()
    except IOError:
        return None

def post(url, path, port, data):
    conn = http.client.HTTPSConnection(url.rstrip(), port=port, context=ssl._create_unverified_context())
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

def import_users(environment, template):
    env = load_environment(environment)

    if env is None:
        print("Environment '" + environment + "' does not exist in config")
        exit(3)

    users = load_users("users_to_import.csv")

    if users is None:
        print("Can not open users_to_import.csv")
        exit(4)

    print("Creating users for " + environment + " environment")

    for user in users:
        message = template \
            .replace("__SECUSERNAME__", env["sec-username"]) \
            .replace("__SECPASSWORD__", env["sec-password"]) \
            .replace("__ENCRYPTEDPASSWORD__", env["encrypted-user-password"]) \
            .replace("__EMAIL__", user["email"]) \
            .replace("__FIRSTNAME__", user["firstname"]) \
            .replace("__LASTNAME__", user["lastname"]) \
            .replace("__BRAND__", user["brand"]) \
            .replace("__B2BUNIT__", user["b2bUnit"]) \
            .replace("__STORE__", user["store"]) \
            .replace("__ROLE__", user["role"])

        response = post(env["url"], env["path"], int(env["port"]), message)
        print(user["email"] + ": " + response)


template = load_template()
if template is None:
    print("Can not load template")
    exit(2)

if len(sys.argv) == 2:
    import_users(sys.argv[1], template)
else:
    for e in ["dev", "qa"]:
        import_users(e, template)
